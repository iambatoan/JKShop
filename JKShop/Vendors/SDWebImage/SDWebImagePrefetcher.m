/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImagePrefetcher.h"
#import "SDWebImageManager.h"

@interface SDWebImagePrefetcher ()

@property (nonatomic, strong) SDWebImageManager *manager;
@property (nonatomic, strong) NSMutableArray *prefetchURLs;
@property (nonatomic, assign) NSUInteger requestedCount;
@property (nonatomic, assign) NSUInteger skippedCount;
@property (nonatomic, assign) NSUInteger finishedCount;

@end

@implementation SDWebImagePrefetcher

+ (SDWebImagePrefetcher *)sharedImagePrefetcher
{
  static dispatch_once_t once;
  static id instance;
  dispatch_once(&once, ^{instance = self.new;});
  return instance;
}

- (id)init
{
  if ((self = [super init]))
  {
    _manager = SDWebImageManager.new;
    _options = SDWebImageLowPriority;
    self.maxConcurrentDownloads = 3;
  }
  return self;
}

- (void)setMaxConcurrentDownloads:(NSUInteger)maxConcurrentDownloads
{
  self.manager.imageDownloader.maxConcurrentDownloads = maxConcurrentDownloads;
}

- (NSUInteger)maxConcurrentDownloads
{
  return self.manager.imageDownloader.maxConcurrentDownloads;
}

- (void)startPrefetchingAtIndex:(NSUInteger)index
{
  if (index >= self.prefetchURLs.count) return;
  self.requestedCount++;
  [self.manager downloadWithURL:self.prefetchURLs[index] options:self.options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
   {
     if (!finished) return;
     self.finishedCount++;
     
     if (image)
     {
       //NSLog(@"Prefetched %d out of %d", self.finishedCount, self.prefetchURLs.count);
     }
     else
     {
       DLog(@"Prefetched %d out of %d (Failed)", self.finishedCount, [self.prefetchURLs count]);
       
       // Add last failed
       self.skippedCount++;
     }
     
     if (self.prefetchURLs.count > self.requestedCount)
     {
       [self startPrefetchingAtIndex:self.requestedCount];
     }
     else if (self.finishedCount == self.requestedCount)
     {
       [self reportStatus];
     }
   }];
}

- (void)reportStatus
{
  //Do nothing
}

- (void)prefetchURLs:(NSArray *)urls
{
  if (self.prefetchURLs == nil)
    self.prefetchURLs = [NSMutableArray array];
  [self.prefetchURLs addObjectsFromArray:urls];
  
  // Starts prefetching from the very first image on the list with the max allowed concurrency
  NSUInteger listCount = self.prefetchURLs.count;
  for (NSUInteger i = 0; i < self.maxConcurrentDownloads && self.requestedCount < listCount; i++)
  {
    [self startPrefetchingAtIndex:i];
  }
}

- (void)cancelPrefetching
{
  self.skippedCount = 0;
  self.requestedCount = 0;
  self.finishedCount = 0;
  [self.manager cancelAll];
}

@end
