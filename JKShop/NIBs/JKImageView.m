//
//  JKImageView.m
//  JKShop
//
//  Created by Toan Slan on 1/23/14.
//  Copyright (c) 2014 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKImageView.h"
#import "UIImage+Additions.h"

@interface JKImageView()
@property (nonatomic, strong) UIImageView *imgWarningIcon;
@property (nonatomic, strong) DACircularProgressView * progressView;
@property (nonatomic, strong) UILabel *lblText;
@property (nonatomic, strong) NSString *currentUrl;
@end

@implementation JKImageView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self == nil)
    return nil;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [self setupXYZ];
  });
  
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self == nil)
    return nil;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [self setupXYZ];
  });
  
  return self;
}

- (void)setupXYZ
{
  //Warning icon
  if (self.imgWarningIcon == nil) {
    UIImage *warningIcon = [UIImage imageNamed:@"icon_warning"];
    self.imgWarningIcon = [[UIImageView alloc] initWithImage:warningIcon];
    self.imgWarningIcon.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
    self.imgWarningIcon.autoresizingMask = AUTORESIZING_MASK_ALL_SIDES;
    self.imgWarningIcon.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.imgWarningIcon.layer.shadowOffset = CGSizeZero;
    self.imgWarningIcon.layer.shadowRadius = 1;
    self.imgWarningIcon.layer.masksToBounds = NO;
    self.imgWarningIcon.layer.shadowOpacity = 1;
    [self addSubview:self.imgWarningIcon];
  }
  self.imgWarningIcon.hidden = YES;
  
  //Warning text
  if (self.lblText == nil) {
    CGRect lblFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 0.8, 24);
    self.lblText = [[UILabel alloc] initWithFrame:lblFrame];
    self.lblText.numberOfLines = 0;
    self.lblText.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblText.clipsToBounds = YES;
    self.lblText.textAlignment = NSTextAlignmentCenter;
    self.lblText.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.lblText.backgroundColor = [UIColor clearColor];
    self.lblText.textColor = [UIColor lightGrayColor];
    self.lblText.font = [UIFont appFontOfSize:11];
    self.lblText.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.lblText.layer.shadowOffset = CGSizeZero;
    self.lblText.layer.shadowRadius = 1;
    self.lblText.layer.masksToBounds = NO;
    self.lblText.layer.shadowOpacity = 1;
    [self addSubview:self.lblText];
  }
  self.lblText.hidden = YES;
  self.lblText.center = self.imgWarningIcon.center;
  [self.lblText alignBelowView:self.imgWarningIcon offsetY:0 sameWidth:NO];
  
  //Progress
  CGRect progressFrame = CGRectMake(0, 0, 24, 24);
  self.progressView = [[DACircularProgressView alloc] initWithFrame:progressFrame];
  self.progressView.center = CGPointMake(self.width/2, self.height/2);
  self.progressView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
  | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
  self.progressView.alpha = 0;
  self.progressView.progress = 0;
  self.progressView.roundedCorners = YES;
  self.progressView.trackTintColor = [UIColor clearColor];
  self.progressView.layer.shadowRadius = MIN(20, CGRectGetWidth(self.bounds)/2 - CGRectGetWidth(progressFrame)/2);
  self.progressView.layer.shadowColor = [UIColor blackColor].CGColor;
  self.progressView.layer.shadowOffset = CGSizeZero;
  self.progressView.layer.shadowOpacity = 0.3;
  [self addSubview:self.progressView];
  
  //Too small to have a progress indicator
  if (MAX(self.width, self.height) < 60) {
    [self.progressView removeFromSuperview];
    self.progressView = nil;
  }
  
  [self reset];
}

- (void)reset
{
  self.tag = 0;
  self.backgroundColor = [UIColor clearColor];
  self.imgWarningIcon.hidden = YES;
  self.lblText.text = @"";
  self.lblText.hidden = [self.lblText.text length] <= 0;
}

- (void)showError:(NSError *)error
{
  NSString *errorMessage = @"Failed to retrieve image";
  if (error != nil)
    errorMessage = [errorMessage stringByAppendingFormat:@" (%d)", error.code];
  
  self.backgroundColor = [UIColor whiteColor];
  self.imgWarningIcon.hidden = NO;
  self.lblText.text = errorMessage;
  self.lblText.hidden = [self.lblText.text length] <= 0;
  [self.lblText alignBelowView:self.imgWarningIcon offsetY:0 sameWidth:NO];
}

- (void)setImageAsync:(NSString *)fullUrlString
{
  [self setImageAsync:fullUrlString showErrorIndicator:NO];
}

- (void)setImageAsync:(NSString *)fullUrlString showErrorIndicator:(BOOL)showErrorIndicator
{
  [self setImageAsync:fullUrlString showErrorIndicator:showErrorIndicator placeholderImage:nil completed:nil];
}

- (void)setImageAsync:(NSString *)fullUrlString showErrorIndicator:(BOOL)showErrorIndicator placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock
{
  self.currentUrl = fullUrlString;
  
  if (placeholder == nil)
    placeholder = [UIImage imageNamed:@"nodata"];
  
  if ([fullUrlString length] < 5)
  {
    if (showErrorIndicator == NO)
      return;
    [self showError:nil];
    self.lblText.text = @"Invalid URL";
    return;
  }
  
  NSString *fullUrlStringCopy = [fullUrlString copy];
  __block JKImageView *weakSelf = self;
  
  [[SDImageCache sharedImageCache] queryDiskCacheForKey:fullUrlStringCopy done:^(UIImage *image, SDImageCacheType cacheType) {
    
    //Has cache
    if (image != nil)
    {
      weakSelf.alpha = 1;
      weakSelf.image = image;
      self.progressView.alpha = 0;
      self.progressView.progress = 0;
      if (completedBlock)
        completedBlock(image, nil, cacheType, nil);
      return;
    }
    
    //No cache, need to download
    self.progressView.progress = 0;
    [weakSelf.progressView fadeInWithDuration:0.1];
    
    [self sd_setImageWithURL:[NSURL URLWithString:fullUrlString]
         placeholderImage:weakSelf.image
                  options:SDWebImageRetryFailed
                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                   //This block must be present for the image not to be auto assigned after downloaded
                   weakSelf.progressView.progress = (CGFloat)receivedSize / (CGFloat)expectedSize;
                 }
                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageUrl) {
                  
                  //Check if the image view has been reused (in UITableViewCell)
                  if ([weakSelf.currentUrl isEqualToString:fullUrlStringCopy] == NO)
                    return;
                  
                  [weakSelf.progressView fadeOutWithDuration:0.3];
                  if (image != nil) {
                    [weakSelf fadeToImage:image duration:0.4];
                    if (completedBlock)
                      completedBlock(image, error, cacheType, imageUrl);
                    return;
                  }
                  
                  //Error indicator
                  if (showErrorIndicator && image == nil) {
                    [weakSelf showError:error];
                  }
                  
                  //Error callback
                  if (error != nil && completedBlock)
                    completedBlock(image, error, cacheType, imageUrl);
                }];
  }];
}

@end
