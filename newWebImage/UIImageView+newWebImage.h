//
//  UIImageView+newWebImage.h
//  newWebImage
//
//  Created by 庄黛淳华 on 2017/6/6.
//  Copyright © 2017年 庄黛淳华. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, newWebImageOptions) {
	/** sd有,下载失败重试*/
	newWebImageRetryFailed = 1 << 0,
	
	/** sd有,下载图片时不阻塞UI刷新*/
	newWebImageLowPriority = 1 << 1,
	
	/** sd有,仅内存缓存*/
	newWebImageCacheMemoryOnly = 1 << 2,
	
	/** sd有,下载时逐层显示图片*/
	newWebImageProgressiveDownload = 1 << 3,
	
	/** sd特有
	 * 即使图像被缓存，也要尊重HTTP响应缓存控制，如果需要，请从远程位置刷新映像。
	 * 磁盘缓存将由NSURLCache处理，而不是SDWebImage，导致轻微的性能下降。
	 * 此选项有助于处理在相同请求URL之后变化的图像，例如 Facebook图表api简介图片。
	 * 如果缓存的图像被刷新，则使用缓存的图像再次调用完成块，并再次使用最终的图像。
	 *
	 * 仅当您无法使用嵌入式缓存无效化参数使您的网址静态时，才使用此标志。
	 */
	newWebImageRefreshCached = 1 << 4,
	
	/** sd有,
	 * 在iOS 4+中，即使应用程序进入后台，也将继续下载图像。 这是通过在后台询问系统额外的时间来完成的。 如果后台任务到期，操作将被取消。
	 */
	newWebImageContinueInBackground = 1 << 5,
	
	/** sd有,
	 * 通过设置NSMutableURLRequest.HTTPShouldHandleCookies = YES;处理存储在NSHTTPCookieStore中的cookie。
	 */
	newWebImageHandleCookies = 1 << 6,
	
	/** sd有,
	 * 启用以允许不可信SSL证书。
	 * 用于测试目的。 在生产中谨慎使用。
	 */
	newWebImageAllowInvalidSSLCertificates = 1 << 7,
	
	/** sd有,最高优先级下载该图片 */
	newWebImageHighPriority = 1 << 8,
	
	/** sd有,让placeholder与下载的图片同步显示(不知道有什么用) */
	newWebImageDelayPlaceholder = 1 << 9,
	
	/** sd有,
	 * 因为大多数转换代码会调用transformDownloadedImage的delegate方法,所以我们通常不会在动画图像上调用它
	 * 使用此标志来无视条件使用代理方法转换。
	 */
	newWebImageTransformAnimatedImage = 1 << 10,
	
	/** sd有,交换流程,改为:先获取到图片再显示到imageView上*/
	newWebImageAvoidAutoSetImage = 1 << 11,
	
	/**sd有,缩小下载大图片的尺寸比*/
	newWebImageScaleDownLargeImages = 1 << 12
};
typedef NS_OPTIONS(NSUInteger, newWebImageDownloaderOptions) {
	newWebImageDownloaderLowPriority = 1 << 0,
	newWebImageDownloaderProgressiveDownload = 1 << 1,
	
	/** sd有,使用NSURLCache进行缓存*/
	newWebImageDownloaderUseNSURLCache = 1 << 2,
	
	/** sd有,开启了上面后,将使用nil代替completion的block*/
	newWebImageDownloaderIgnoreCachedResponse = 1 << 3,
	
	/** sd有,
	 * 在iOS 4+中，即使应用程序进入后台，也将继续下载图像。 这是通过在后台询问系统额外的时间来完成的。 如果后台任务到期，操作将被取消。
	 */
	newWebImageDownloaderContinueInBackground = 1 << 4,
	
	/** sd有,
	 * 通过设置NSMutableURLRequest.HTTPShouldHandleCookies = YES;处理存储在NSHTTPCookieStore中的cookie。
	 */
	newWebImageDownloaderHandleCookies = 1 << 5,
	
	/** sd有,
	 * 启用以允许不可信SSL证书。
	 * 用于测试目的。 在生产中谨慎使用。
	 */
	newWebImageDownloaderAllowInvalidSSLCertificates = 1 << 6,
	
	/** sd有,最高优先级下载该图片 */
	newWebImageDownloaderHighPriority = 1 << 7,
	
	/**sd有,缩小下载大图片的尺寸比*/
	newWebImageDownloaderScaleDownLargeImages = 1 << 8,
};
typedef void(^newWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger totalSize);
typedef void(^newWebImageDownloaderCompletedBlock)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error);


@interface UIImageView (newWebImage)
/** 仅网络加载图片 */
- (void)newLoadURL:(NSString*_Nonnull)urlstr;
/** 设置占位图再网络加载图片 */
- (void)newLoadURL:(NSString*_Nonnull)urlstr placeholder:(UIImage*_Nullable)placeholder;
/** 设置占位图再网络加载图片,带加载参数 */
- (void)newLoadURL:(NSString*_Nonnull)urlstr placeholder:(UIImage*_Nullable)placeholder options:(newWebImageOptions)options;
/** 设置占位图再网络加载图片,并返回下载的图片 */
- (void)newLoadURL:(NSString*_Nonnull)urlstr placeholder:(UIImage*_Nullable)placeholder completed:(nullable newWebImageDownloaderCompletedBlock)completedBlock;
/** 设置占位图再网络加载图片,并返回下载的图片和返回下载时的过程 */
- (void)newLoadURL:(NSString*_Nonnull)urlstr placeholder:(UIImage*_Nullable)placeholder progress:(nullable newWebImageDownloaderProgressBlock)progressBlock completed:(nullable newWebImageDownloaderCompletedBlock)completedBlock;
/** 设置占位图再网络加载图片,并返回下载的图片,带加载参数 */
- (void)newLoadURL:(NSString*_Nonnull)urlstr placeholder:(UIImage*_Nullable)placeholder options:(newWebImageOptions)options completed:(nullable newWebImageDownloaderCompletedBlock)completedBlock;
/** 网络加载图片的完整方法,带加载参数 */
- (void)newLoadURL:(NSString*_Nonnull)urlstr placeholder:(UIImage*_Nullable)placeholder options:(newWebImageOptions)options progress:(nullable newWebImageDownloaderProgressBlock)progressBlock completed:(nullable newWebImageDownloaderCompletedBlock)completedBlock;
/** 仅下载网络图片 */
+ (void)downloadImageWithURL:(nullable NSURL *)url
				   completed:(nullable newWebImageDownloaderCompletedBlock)completedBlock;
/** 下载网络图片,并返回下载的图片和返回下载时的过程 */
+ (void)downloadImageWithURL:(nullable NSURL *)url
					progress:(nullable newWebImageDownloaderProgressBlock)progressBlock
				   completed:(nullable newWebImageDownloaderCompletedBlock)completedBlock;
/** 下载网络图片,并返回下载的图片,带下载参数 */
+ (void)downloadImageWithURL:(nullable NSURL *)url
					 options:(newWebImageDownloaderOptions)options
				   completed:(nullable newWebImageDownloaderCompletedBlock)completedBlock;
/** 下载网络图片的完整方法,带下载参数 */
+ (void)downloadImageWithURL:(nullable NSURL *)url
					 options:(newWebImageDownloaderOptions)options
					progress:(nullable newWebImageDownloaderProgressBlock)progressBlock
				   completed:(nullable newWebImageDownloaderCompletedBlock)completedBlock;

/** 清除磁盘缓存 */
+ (void)clearDiskOnCompletion:(void (^_Nullable)(CGFloat clearCacheSize))completionBlock;
/** 清除内存缓存 */
+ (void)clearMemoryOnCompletion:(void (^_Nullable)(CGFloat clearMemorySize))completionBlock;
/** 清除磁盘和内存缓存 */
+ (void)clearCacheOnCompletion:(void (^_Nullable)(CGFloat clearCacheSize,CGFloat clearMemorySize))completionBlock;

@end

