//
//  UIImage+scaleImage.m
//  IGame
//
//  Created by enqingchen on 14-10-11.
//  Copyright (c) 2014年 IGame. All rights reserved.
//

#import "UIImage+scaleImage.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (scaleImage)

//保证计算出来的size至少有一条边和maxSize一样大
+ (CGSize)fitMaxSize:(CGSize)maxSize bySize:(CGSize)imageSize{
    if(imageSize.height == 0 || imageSize.width == 0) return CGSizeMake(0.001, 0.001);
    
    CGFloat k = imageSize.width/imageSize.height;
    //宽度先相等
    imageSize.width = maxSize.width;
    imageSize.height = imageSize.width/k;
    if(imageSize.height > maxSize.height){
        imageSize.height = maxSize.height;
        imageSize.width = imageSize.height * k;
    }
    
    return imageSize;
}
+ (CGSize)fillMaxSize:(CGSize)maxSize bySize:(CGSize)imageSize{
    if(imageSize.height == 0 || imageSize.width == 0) return CGSizeMake(0.001, 0.001);
    CGFloat k = imageSize.width/imageSize.height;
    //宽度先相等
    imageSize.width = maxSize.width;
    imageSize.height = imageSize.width/k;
    if(imageSize.height < maxSize.height){
        imageSize.height = maxSize.height;
        imageSize.width = imageSize.height * k;
    }
    return imageSize;
}
- (NSData *)compressImage{
    NSData *imageData = nil;
    CGFloat k = 0.8;
    NSInteger length = 0;
    do{
        BOOL isBreak = NO;
        @autoreleasepool {
            imageData = UIImageJPEGRepresentation(self, k);    //压缩
            if(ABS(imageData.length - length) <= 5*1024) isBreak = YES;  //如果两次压缩间缩小的大小小于5K的时候 认为再压缩已经不能有明显效果了，就退出逼近循环。
            k *= 0.5;//缩小压缩系数
            length = imageData.length;//记录下这次压缩后的大小
        }
        if(isBreak) break;
    }while (imageData.length >= 300*1024);//如果达到目标300k 也可以退出循环
    return imageData;
}

-(UIImage *)circleImage{
    //2.开启上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    //3.取得当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //4.画圆
    CGRect circleRect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, circleRect);
    
    //5.裁剪(按照当前的路径形状裁剪)
    CGContextClip(ctx);
    
    //6.画图
    [self drawInRect:circleRect];
    
    //7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //8.结束
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)tiledScaleImageWithSize:(CGSize)itemSize scale:(CGFloat)scale{
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [self drawInRect:imageRect];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+(UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size{
    CGSize imageSize = CGSizeMake(size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (UIImage *)blurryWithBlurLevel:(CGFloat)blur{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer outBuffer;
    
    vImage_Buffer buf = {0};
    vImage_CGImageFormat fmt = {
        .bitsPerComponent = 8,
        .bitsPerPixel = 32,
        .colorSpace = CGImageGetColorSpace(img),
        .bitmapInfo = CGImageGetBitmapInfo(img)
    };
    
    vImageBuffer_InitWithCGImage( &buf, &fmt, NULL, img, kvImageNoFlags ); // allocates buf.data
    
    vImageBuffer_Init( &outBuffer, buf.height, buf.width, fmt.bitsPerPixel, kvImageNoFlags);
    
    vImageBoxConvolve_ARGB8888(&buf,&outBuffer,NULL,0,0,boxSize,boxSize,NULL,kvImageEdgeExtend);
    
    UIImage *returnImage;
    @try {
        free(buf.data);
        buf.data = NULL;
        CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,outBuffer.width,outBuffer.height,8,outBuffer.rowBytes,fmt.colorSpace,fmt.bitmapInfo);
        CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
        returnImage = [UIImage imageWithCGImage:imageRef];
        
        //clean up
        CGContextRelease(ctx);
        CGImageRelease(imageRef);
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return returnImage;
}

+(NSCache*)_getloadedImageCache{
    static NSCache *loadedImageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadedImageCache = [[NSCache alloc] init];
    });
    return loadedImageCache;
}
+(void)setImage:(UIImage*)image forKey:(id<NSCopying>)key{
    [[UIImage _getloadedImageCache] setObject:image forKey:key];
}
+(void)removeImageForKey:(id<NSCopying>)key{
    [[UIImage _getloadedImageCache] removeObjectForKey:key];
}
+(UIImage*)cp_imageNamed:(NSString*)imageName{
    if(!imageName) return nil;
    UIImage* image = [[UIImage _getloadedImageCache] objectForKey:imageName];
    if(!image){
        //imageNamed:方法是线程不安全的
        image = [self save_imageNamed:imageName];
        if(image) [[UIImage _getloadedImageCache] setObject:image forKey:imageName];
    }
    return image;
}
+(UIImage*)save_imageNamed:(NSString*)imageName{
    __block UIImage* image = nil;
    //imageNamed:方法是线程不安全的
    if([NSThread isMainThread]){
        image = [UIImage imageNamed:imageName];
    }
    else{
        dispatch_sync(dispatch_get_main_queue(), ^{
            image = [UIImage imageNamed:imageName];
        });
    }
    return image;
}
/**
 *  释放内存中所有已加载的自定义表情
 */
+(void)releaseAllLoadedImage{
    [[UIImage _getloadedImageCache] removeAllObjects];
}

- (UIImage*)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CGContextAddPath(ctx,path.CGPath);
    CGContextClip(ctx);
    [self drawInRect:rect];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageAddCornerWithRadius:(CGFloat)radius size:(CGSize)size borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    UIImage *backgroundImage = [self scaleToSize:CGSizeMake(size.width, size.height) withContentMode:UIViewContentModeScaleToFill backgroundColor:[UIColor clearColor]];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    
    CGFloat halfBorderWidth = borderWidth / 2;
    //设置上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //边框大小
    CGContextSetLineWidth(context, borderWidth);
    //边框颜色
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    //矩形填充颜色
    CGFloat height = size.height;
    CGFloat width = size.width;
    
    CGContextMoveToPoint(context, width - halfBorderWidth, radius + halfBorderWidth);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, width - halfBorderWidth, height - halfBorderWidth, width - radius  - halfBorderWidth, height - halfBorderWidth, radius);  // 右下角角度
    CGContextAddArcToPoint(context, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height - radius - halfBorderWidth, radius); // 左下角角度
    CGContextAddArcToPoint(context, halfBorderWidth, halfBorderWidth, width - halfBorderWidth, halfBorderWidth, radius); // 左上角
    CGContextAddArcToPoint(context, width , halfBorderWidth, width - halfBorderWidth, radius + halfBorderWidth, radius); // 右上角
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outImage;
}

- (void)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size andCompletionBlock:(void(^)(UIImage *))completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self imageAddCornerWithRadius:radius andSize:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(image);
            }
        });
    });
}

#pragma mark - private 
- (UIImage *)scaleToSize:(CGSize)size withContentMode:(UIViewContentMode)contentMode backgroundColor:(UIColor *)backgroundColor {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    
    if (backgroundColor) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextAddRect(context, rect);
        CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    }
    [self drawInRect:[self convertRect:CGRectMake(0.0f, 0.0f, size.width, size.height) withContentMode:contentMode]];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode {
    
    if (self.size.width != rect.size.width || self.size.height != rect.size.height) {
        if (contentMode == UIViewContentModeLeft) {
            return CGRectMake(rect.origin.x,
                              rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeRight) {
            return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                              rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeTop) {
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                              rect.origin.y,
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeBottom) {
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                              rect.origin.y + floor(rect.size.height - self.size.height),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeCenter) {
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - self.size.width/2),
                              rect.origin.y + floor(rect.size.height/2 - self.size.height/2),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeBottomLeft) {
            return CGRectMake(rect.origin.x,
                              rect.origin.y + floor(rect.size.height - self.size.height),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeBottomRight) {
            return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                              rect.origin.y + (rect.size.height - self.size.height),
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeTopLeft) {
            return CGRectMake(rect.origin.x,
                              rect.origin.y,
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeTopRight) {
            return CGRectMake(rect.origin.x + (rect.size.width - self.size.width),
                              rect.origin.y,
                              self.size.width, self.size.height);
            
        } else if (contentMode == UIViewContentModeScaleAspectFill) {
            CGSize imageSize = self.size;
            if (imageSize.height < imageSize.width) {
                imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
                imageSize.height = rect.size.height;
            } else {
                imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
                imageSize.width = rect.size.width;
            }
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
                              rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
                              imageSize.width, imageSize.height);
        } else if (contentMode == UIViewContentModeScaleAspectFit) {
            CGSize imageSize = self.size;
            if (imageSize.height < imageSize.width) {
                imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
                imageSize.width = rect.size.width;
            } else {
                imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
                imageSize.height = rect.size.height;
            }
            return CGRectMake(rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
                              rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
                              imageSize.width, imageSize.height);
        }
    }
    return rect;
}
- (UIImage *)fixOrientation{
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
