//
//  newWebImage.m
//  newWebImage
//
//  Created by 庄黛淳华 on 2017/6/6.
//  Copyright © 2017年 庄黛淳华. All rights reserved.
//

#import "newWebImage.h"


#if __has_include("SDImageCache.h")
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "UIView+WebCache.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#define use_SDWebImage 1
#endif

#pragma mark - URL相关
//用NSString返回一个URL
#define URL(unUTF8str) [NSURL URLWithString:unUTF8str]


@implementation UIImageView (newWebImage)
- (void)newLoadURL:(NSObject*_Nonnull)urlstr{
	[self newLoadURL:urlstr placeholder:nil options:0 progress:nil completed:nil];
}
- (void)newLoadURL:(NSObject*_Nonnull)urlstr placeholder:(UIImage*_Nullable)placeholder{
	[self newLoadURL:urlstr placeholder:placeholder options:0 progress:nil completed:nil];
}
- (void)newLoadURL:(NSObject*_Nonnull)urlstr placeholder:(UIImage*_Nullable)placeholder options:(newWebImageOptions)options{
	[self newLoadURL:urlstr placeholder:placeholder options:options progress:nil completed:nil];
}
- (void)newLoadURL:(NSObject*_Nonnull)urlstr placeholder:(UIImage*_Nullable)placeholder completed:(nullable newWebImageDownloaderCompletedBlock)completedBlock{
	[self newLoadURL:urlstr placeholder:placeholder options:0 progress:nil completed:completedBlock];
}
- (void)newLoadURL:(NSObject*_Nonnull)urlstr placeholder:(UIImage*_Nullable)placeholder progress:(nullable newWebImageDownloaderProgressBlock)progressBlock completed:(nullable newWebImageDownloaderCompletedBlock)completedBlock{
	[self newLoadURL:urlstr placeholder:placeholder options:0 progress:progressBlock completed:completedBlock];
	
}
-(void)newLoadURL:(NSObject *)urlstr placeholder:(UIImage *)placeholder options:(newWebImageOptions)options completed:(newWebImageDownloaderCompletedBlock)completedBlock{
	[self newLoadURL:urlstr placeholder:placeholder options:options progress:nil completed:completedBlock];
}
-(void)newLoadURL:(NSObject *)urlstr placeholder:(UIImage *)placeholder options:(newWebImageOptions)options progress:(newWebImageDownloaderProgressBlock)progressBlock completed:(newWebImageDownloaderCompletedBlock)completedBlock{

	
	__unsafe_unretained typeof(self) weakSelf = self;
	NSURL* url;
	if ([urlstr isKindOfClass:[NSString class]]) {
		url = URL(urlstr);
	}else if([urlstr isKindOfClass:[NSURL class]]){
		url = (NSURL*)urlstr;
		urlstr = url.absoluteString;

	}else{
		[self setImage:placeholder];
		return;
	}
	if (((NSString*)urlstr).length<7) {//http://
		[self setImage:placeholder];
		return;
	}
	UIImage *tempImage = [SDImageCache.sharedImageCache imageFromCacheForKey:urlstr];
	
	if (tempImage) {
		[weakSelf setImage:tempImage];
		[weakSelf fitSize];
	}
	
	//MARK:	下载图片
	SDWebImageOptions tempOptions = 0;
	if (options) {
		if (options & newWebImageRetryFailed) tempOptions |= SDWebImageRetryFailed;
		if (options & newWebImageLowPriority) tempOptions |= SDWebImageLowPriority;
		if (options & newWebImageCacheMemoryOnly) tempOptions |= SDWebImageCacheMemoryOnly;
		if (options & newWebImageProgressiveDownload) tempOptions |= SDWebImageProgressiveDownload;
		if (options & newWebImageRefreshCached) tempOptions |= SDWebImageRefreshCached;
		if (options & newWebImageContinueInBackground) tempOptions |= SDWebImageContinueInBackground;
		if (options & newWebImageHandleCookies) tempOptions |= SDWebImageHandleCookies;
		if (options & newWebImageAllowInvalidSSLCertificates) tempOptions |= SDWebImageAllowInvalidSSLCertificates;
		if (options & newWebImageHighPriority) tempOptions |= SDWebImageHighPriority;
		if (options & newWebImageDelayPlaceholder) tempOptions |= SDWebImageDelayPlaceholder;
		if (options & newWebImageTransformAnimatedImage) tempOptions |= SDWebImageTransformAnimatedImage;
		if (options & newWebImageAvoidAutoSetImage) tempOptions |= SDWebImageAvoidAutoSetImage;
		if (options & newWebImageScaleDownLargeImages) tempOptions |= SDWebImageScaleDownLargeImages;
	}else{
		tempOptions=SDWebImageLowPriority|SDWebImageRetryFailed;
	}
	
	if (tempImage) {
		[SDWebImageManager.sharedManager loadImageWithURL:url options:tempOptions progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
			if(progressBlock){
				progressBlock(receivedSize, expectedSize);
			}
		} completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
			[weakSelf setImage:image];
			[weakSelf fitSize];
			UIImage *replace = nil;
			if(completedBlock){
				completedBlock(image,data,error,&replace);
			}
			if (replace) {
				NSData *newData = UIImagePNGRepresentation(replace);
				[SDImageCache.sharedImageCache storeImageDataToDisk:newData forKey:urlstr];
			}else{
				[SDImageCache.sharedImageCache storeImageDataToDisk:data forKey:urlstr];
			}

		}];
	}else{
        
		[self sd_setImageWithURL:url placeholderImage:placeholder options:tempOptions progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
			if(progressBlock){
				progressBlock(receivedSize, expectedSize);
			}
		} completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
			[weakSelf fitSize];
			if(completedBlock){
				completedBlock(image,nil,error,nil);
			}
		}];
	}
}

- (void)fitSize{
	if ((self.frame.size.width == 0)&&(self.frame.size.height == 0)) {
		[self sizeToFit];
	}
}

-(NSURL *)newImageURL{
    return self.sd_imageURL;
}

@end

@implementation UIImage (newWebImage)
+(UIImage *)loadImageCacheWithURL:(NSObject *)urlstr{

	if([urlstr isKindOfClass:[NSURL class]]){
		urlstr = ((NSURL *)urlstr).absoluteString;
	}
	
	if (((NSString*)urlstr).length<7) {//http://
		return nil;
	}
	
	if ([urlstr isKindOfClass:[NSString class]]) {
		return [SDImageCache.sharedImageCache imageFromCacheForKey:(NSString*)urlstr];
	}else{
		return nil;
	}
	



}
+ (void)downloadImageWithURL:(nullable NSObject *)url
				   completed:(nullable newWebImageDownloaderCompletedBlock)completedBlock{
	[self downloadImageWithURL:url options:0 progress:nil completed:completedBlock];
}
+ (void)downloadImageWithURL:(nullable NSObject *)url
					progress:(nullable newWebImageDownloaderProgressBlock)progressBlock
				   completed:(nullable newWebImageDownloaderCompletedBlock)completedBlock{
	[self downloadImageWithURL:url options:0 progress:progressBlock completed:completedBlock];
}
+ (void)downloadImageWithURL:(nullable NSObject *)url
					 options:(newWebImageDownloaderOptions)options
				   completed:(nullable newWebImageDownloaderCompletedBlock)completedBlock{
	[self downloadImageWithURL:url options:0 progress:nil completed:completedBlock];
}
+ (void)downloadImageWithURL:(nullable NSObject *)urlstr
					 options:(newWebImageDownloaderOptions)options
					progress:(nullable newWebImageDownloaderProgressBlock)progressBlock
				   completed:(nullable newWebImageDownloaderCompletedBlock)completedBlock{
    
    UIImage *largeImage = [UIImage loadImageCacheWithURL:urlstr];
    if (largeImage) {
        completedBlock(largeImage,nil,nil,nil);
        return;
    }
    
	NSURL* url;
	if ([urlstr isKindOfClass:[NSString class]]) {
		url = URL(urlstr);
	}else if([urlstr isKindOfClass:[NSURL class]]){
		url = (NSURL*)urlstr;
		urlstr = url.absoluteString;
	}else{
		return;
	}

	SDWebImageDownloaderOptions tempOptions = 0;
	if (options) {
		if (options & newWebImageDownloaderLowPriority) tempOptions |= SDWebImageDownloaderLowPriority;
		if (options & newWebImageDownloaderProgressiveDownload) tempOptions |= SDWebImageDownloaderProgressiveDownload;
		if (options & newWebImageDownloaderUseNSURLCache) tempOptions |= SDWebImageDownloaderUseNSURLCache;
		if (options & newWebImageDownloaderIgnoreCachedResponse) tempOptions |= SDWebImageDownloaderIgnoreCachedResponse;
		if (options & newWebImageDownloaderContinueInBackground) tempOptions |= SDWebImageDownloaderContinueInBackground;
		if (options & newWebImageDownloaderHandleCookies) tempOptions |= SDWebImageDownloaderHandleCookies;
		if (options & newWebImageDownloaderAllowInvalidSSLCertificates) tempOptions |= SDWebImageDownloaderAllowInvalidSSLCertificates;
		if (options & newWebImageDownloaderHighPriority) tempOptions |= SDWebImageDownloaderHighPriority;
		if (options & newWebImageDownloaderScaleDownLargeImages) tempOptions |= SDWebImageDownloaderScaleDownLargeImages;
	}else{
		tempOptions=SDWebImageDownloaderLowPriority;
	}
	
	[SDWebImageDownloader.sharedDownloader downloadImageWithURL:url options:tempOptions progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * targetURL) {
		if (progressBlock) {
            progressBlock(receivedSize,expectedSize);
		}
	} completed:^(UIImage * image, NSData * data, NSError * error, BOOL finished) {
		UIImage *replace = nil;
        if (!data) {
            return ;
        }
		if (completedBlock) {
			completedBlock(image,data,error,&replace);
		}
		if (replace) {
			NSData *newData = UIImagePNGRepresentation(replace);
			[SDImageCache.sharedImageCache storeImageDataToDisk:newData forKey:urlstr];
		}else{
			[SDImageCache.sharedImageCache storeImageDataToDisk:data forKey:urlstr];
		}
	}];
}
/** 清除磁盘缓存 */
+ (void)clearDiskOnCompletion:(void (^)(CGFloat))completionBlock{
	SDImageCache *cache = [SDImageCache sharedImageCache];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *cachePath = [cache valueForKeyPath:@"diskCachePath"];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSUInteger size = [cache getSize];
		[fileManager removeItemAtPath:cachePath error:nil];
		[fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
		
		if (completionBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completionBlock(size);
			});
		}
	});
}

//TODO:	需要研究内存的计算
/** 清除内存缓存 */
+ (void)clearMemoryOnCompletion:(void (^)(CGFloat))completionBlock{
	SDImageCache *cache = [SDImageCache sharedImageCache];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[cache clearMemory];
		if (completionBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completionBlock(0);
			});
		}
	});
	
}
/** 清除磁盘和内存缓存 */
+ (void)clearCacheOnCompletion:(void (^)(CGFloat clearCacheSize,CGFloat clearMemorySize))completionBlock{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		SDImageCache *cache = [SDImageCache sharedImageCache];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *cachePath = [cache valueForKeyPath:@"diskCachePath"];
		NSUInteger size = [cache getSize];
		[cache clearMemory];
		[fileManager removeItemAtPath:cachePath error:nil];
		[fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
		
		if (completionBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completionBlock(size,0);
			});
		}
	});
}

+ (UIImage *)newImageFromDiskCacheForKey:(NSString *)key{
    return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
}

+ (void)cancelAllDownload{
    [SDWebImageManager.sharedManager cancelAll];
}
@end
