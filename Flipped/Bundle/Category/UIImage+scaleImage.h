//
//  UIImage+scaleImage.h
//  IGame
//
//  Created by enqingchen on 14-10-11.
//  Copyright (c) 2014年 IGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (scaleImage)
/**
 *  按imageSize的长宽比等比缩放到maxSize大小,保证计算出来的size至少有一条(较大的边)边和maxSize一样大
 *
 *  @param maxSize
 *  @param imageSize
 *
 *  @return size 不大于maxSize
 */
+ (CGSize)fitMaxSize:(CGSize)maxSize bySize:(CGSize)imageSize;
/**
 *  按imageSize的长宽比等比缩放到maxSize大小,保证计算出来的size至少有一条(较小的边)边和maxSize一样大
 *
 *  @param maxSize
 *  @param imageSize
 *
 *  @return size 不小于maxSize
 */
+ (CGSize)fillMaxSize:(CGSize)maxSize bySize:(CGSize)imageSize;
/**
 *  压缩图片
 *
 *  @return 
 */
- (NSData *)compressImage;
/**
 *  图片缩放方法
 *
 *  @param itemSize 需要缩放至的size
 *
 *  @return 返回缩放过后的图片
 */
- (UIImage *)tiledScaleImageWithSize:(CGSize)itemSize scale:(CGFloat)scale;
/**
 *  通过颜色色值生成图片
 *
 *  @param color
 *  @param size
 *
 *  @return 生成的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
/**
 *  用vImage方法模糊图片
 *
 *  @param image 需要模糊的图片
 *  @param blur  模糊半径
 *
 *  @return 模糊后的图片
 */
- (UIImage *)blurryWithBlurLevel:(CGFloat)blur;

/**
 *  自己缓存图片指针
 *
 *  @param imageName
 *
 *  @return
 */
+(UIImage*)cp_imageNamed:(NSString*)imageName;
/**
 *  线程安全的imageNamed方法
 *
 *  @param imageName
 *
 *  @return 
 */
+(UIImage*)save_imageNamed:(NSString*)imageName;
+(void)setImage:(UIImage*)image forKey:(id<NSCopying>)key;
+(void)removeImageForKey:(id<NSCopying>)key;

/**
 *  释放已经加载的图片指针
 */
+(void)releaseAllLoadedImage;

-(UIImage *)circleImage;

/**
 *  create a image with corner radius and border
 *
 *  @param radius      radius
 *  @param size        size to contain image, better to be the size of container imageview
 *  @param borderColor borderColor
 *  @param borderWidth borderWidth
 *
 *  @return image with corner and border
 */

- (UIImage *)imageAddCornerWithRadius:(CGFloat)radius size:(CGSize)size borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
/**
 *  create a image with corner radius
 *
 *  @param radius radius
 *  @param size   size to contain image, better to be the size of container imageview
 *
 *  @return image with corner
 */
- (UIImage*)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size;

/**
 *  create a image with corner radius in a async way, used in performance sensitive scene
 *
 *  @param radius          radius
 *  @param size            size to contain image, better to be the size of container imageview
 *  @param completionBlock async callback block, parameter is the result image
 */
- (void)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size andCompletionBlock:(void(^)(UIImage *image))completionBlock;

- (UIImage *)fixOrientation;
@end
