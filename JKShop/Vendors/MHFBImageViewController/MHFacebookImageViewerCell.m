
#import "MHFacebookImageViewerCell.h"
#import "UIImageView+MHFacebookImageViewer.h"

static const CGFloat kMinBlackMaskAlpha = 0.3f;
static const CGFloat kMaxImageScale = 2.5f;
static const CGFloat kMinImageScale = 1.0f;

@implementation MHFacebookImageViewerCell

@synthesize originalFrameRelativeToScreen = _originalFrameRelativeToScreen;
@synthesize rootViewController = _rootViewController;
@synthesize viewController = _viewController;
@synthesize blackMask = _blackMask;
@synthesize closingBlock = _closingBlock;
@synthesize openingBlock = _openingBlock;
@synthesize doneButton = _doneButton;
@synthesize senderView = _senderView;
@synthesize imageIndex = _imageIndex;
@synthesize superView = _superView;
@synthesize defaultImage = _defaultImage;
@synthesize initialIndex = _initialIndex;

- (void)loadAllRequiredViews
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    __scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    __scrollView.delegate = self;
    __scrollView.backgroundColor = [UIColor clearColor];
    __scrollView.autoresizesSubviews = YES;
    [self addSubview:__scrollView];
    
    [_doneButton addTarget:self
                    action:@selector(onBtnDone:)
          forControlEvents:UIControlEventTouchUpInside];
}

- (void)setImageURL:(NSURL *)imageURL defaultImage:(UIImage*)defaultImage imageIndex:(NSInteger)imageIndex
{
    _imageIndex = imageIndex;
    _defaultImage = defaultImage;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _senderView.alpha = 0.0f;
        if (!__imageView){
            __imageView = [[JKImageView alloc] initWithFrame:__scrollView.bounds];
            __imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [__scrollView addSubview:__imageView];
            __imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        __block UIImageView * _imageViewInTheBlock = __imageView;
        __block MHFacebookImageViewerCell * weakSelf = self;
        __block UIScrollView * _scrollViewInsideBlock = __scrollView;
        
        // Using custome UIImageView with progress indicator
        [__imageView setImageAsync:[imageURL absoluteString]
                showErrorIndicator:YES
                  placeholderImage:defaultImage
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             if (error != nil) {
                 DLog(@"Image From URL Not loaded");
                 return;
             }
             
             [_scrollViewInsideBlock setZoomScale:1.0f animated:YES];
             [_imageViewInTheBlock setImage:image];
             _imageViewInTheBlock.frame = [weakSelf centerFrameFromImage:_imageViewInTheBlock.image];
         }];
        
        if (_imageIndex==_initialIndex && !_isLoaded)
        {
            __imageView.frame = _originalFrameRelativeToScreen;
            [UIView animateWithDuration:0.4f delay:0.0f options:0 animations:^{
                __imageView.frame = [self centerFrameFromImage:__imageView.image];
                CGAffineTransform transf = CGAffineTransformIdentity;
                // Root View Controller - move backward
                _rootViewController.view.transform = CGAffineTransformScale(transf, 0.95f, 0.95f);
                // Root View Controller - move forward
                //                _viewController.view.transform = CGAffineTransformScale(transf, 1.05f, 1.05f);
                _blackMask.alpha = 1;
            }   completion:^(BOOL finished) {
                if (finished) {
                    _isAnimating = NO;
                    _isLoaded = YES;
                    if (_openingBlock)
                        _openingBlock();
                }
            }];
            
        }
        __imageView.userInteractionEnabled = YES;
        [self addPanGestureToView:__imageView];
        [self addMultipleGesture];
        
    });
}

- (void)addPanGestureToView:(UIView*)view
{
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(gestureRecognizerDidPan:)];
    panGesture.cancelsTouchesInView = YES;
    panGesture.delegate = self;
    [view addGestureRecognizer:panGesture];
}

- (void)addMultipleGesture
{
    UITapGestureRecognizer *twoFingerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTwoFingerTap:)];
    twoFingerTapGesture.numberOfTapsRequired = 1;
    twoFingerTapGesture.numberOfTouchesRequired = 2;
    [__scrollView addGestureRecognizer:twoFingerTapGesture];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    [__scrollView addGestureRecognizer:singleTapRecognizer];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [__scrollView addGestureRecognizer:doubleTapRecognizer];
    
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    
    __scrollView.minimumZoomScale = kMinImageScale;
    __scrollView.maximumZoomScale = kMaxImageScale;
    __scrollView.zoomScale = 1;
    [self centerScrollViewContents];
}



#pragma mark - Gesture recognizer

// This prevent unwanted Horizontal Gesture from starting, not during panning
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
    CGPoint translation = [panGestureRecognizer translationInView:__scrollView];
    return fabs(translation.y) > fabs(translation.x) ;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    _panOrigin = __imageView.frame.origin;
    gestureRecognizer.enabled = YES;
    return !_isAnimating;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //Disable side scrolling while panning up/down
    UITableView * tableView = [self getParentTableView];
    if ( [tableView respondsToSelector:@selector(panGestureRecognizer)] &&
        [otherGestureRecognizer isEqual:(tableView.panGestureRecognizer)] )
    {
        return NO;
    }
    return YES;
}

- (void)gestureRecognizerDidPan:(UIPanGestureRecognizer*)panGesture
{
    if (__scrollView.zoomScale != 1.0f || _isAnimating)
        return;
    
    if (_imageIndex == _initialIndex){
        if (_senderView.alpha!=0.0f)
            _senderView.alpha = 0.0f;
    }else {
        if (_senderView.alpha!=1.0f)
            _senderView.alpha = 1.0f;
    }
    
    // Hide the Done Button
    [self hideDoneButton];
    __scrollView.bounces = NO;
    CGSize windowSize = _blackMask.bounds.size;
    CGPoint currentPoint = [panGesture translationInView:__scrollView];
    CGFloat y = currentPoint.y + _panOrigin.y;
    CGRect frame = __imageView.frame;
    frame.origin = CGPointMake(0, y);
    __imageView.frame = frame;
    
    CGFloat yDiff = abs((y + __imageView.frame.size.height/2) - windowSize.height/2);
    _blackMask.alpha = MAX(1 - yDiff/(windowSize.height/2),kMinBlackMaskAlpha);
    
    if ((panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) && __scrollView.zoomScale == 1.0f)
    {
        if (_blackMask.alpha < 0.7) {
            [self dismissViewController];
        }else {
            [self rollbackViewController];
        }
    }
}

//For Zooming
- (void)didTwoFingerTap:(UITapGestureRecognizer*)recognizer
{
    CGFloat newZoomScale = __scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, __scrollView.minimumZoomScale);
    [__scrollView setZoomScale:newZoomScale animated:YES];
}

//Showing of Done Button if ever Zoom Scale is equal to 1
- (void)didSingleTap:(UITapGestureRecognizer*)recognizer
{
    if (_doneButton.superview)
    {
        [self hideDoneButton];
        return;
    }
    
    if (__scrollView.zoomScale == __scrollView.maximumZoomScale)
    {
        CGPoint pointInView = [recognizer locationInView:__imageView];
        [self zoomInZoomOut:pointInView];
        return;
    }
    
    if (__scrollView.zoomScale == __scrollView.minimumZoomScale)
    {
        if (!_isDoneAnimating){
            _isDoneAnimating = YES;
            [self.viewController.view addSubview:_doneButton];
            _doneButton.alpha = 0.0f;
            [UIView animateWithDuration:0.2f animations:^{
                _doneButton.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [self.viewController.view bringSubviewToFront:_doneButton];
                _isDoneAnimating = NO;
            }];
        }
    }
}

//Zoom in or Zoom out
- (void)didDoubleTap:(UITapGestureRecognizer*)recognizer
{
    CGPoint pointInView = [recognizer locationInView:__imageView];
    [self zoomInZoomOut:pointInView];
}



#pragma mark - Helpers

- (void)rollbackViewController
{
    _isAnimating = YES;
    [UIView animateWithDuration:0.2f delay:0.0f options:0 animations:^{
        __imageView.frame = [self centerFrameFromImage:__imageView.image];
        _blackMask.alpha = 1;
    }   completion:^(BOOL finished) {
        if (finished) {
            _isAnimating = NO;
        }
    }];
}

- (void)dismissViewController
{
    _isAnimating = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideDoneButton];
        __imageView.clipsToBounds = YES;
        CGFloat screenHeight =  [[UIScreen mainScreen] bounds].size.height;
        CGFloat imageYCenterPosition = __imageView.frame.origin.y + __imageView.frame.size.height/2 ;
        BOOL isGoingUp =  imageYCenterPosition < screenHeight/2;
        
        [UIView animateWithDuration:0.35f delay:0.0f options:0 animations:^{
            if (_imageIndex==_initialIndex){
                __imageView.frame = _originalFrameRelativeToScreen;
            }else {
                __imageView.frame = CGRectMake(__imageView.frame.origin.x, isGoingUp?-screenHeight:screenHeight, __imageView.frame.size.width, __imageView.frame.size.height);
            }
            CGAffineTransform transf = CGAffineTransformIdentity;
            _rootViewController.view.transform = CGAffineTransformScale(transf, 1.0f, 1.0f);
            _blackMask.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [_viewController.view removeFromSuperview];
            [_viewController removeFromParentViewController];
            _senderView.alpha = 1.0f;
            _isAnimating = NO;
            if (_closingBlock)
                _closingBlock();
        }];
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [UIApplication sharedApplication].statusBarStyle = _statusBarStyle;
    });
}

//iOS7 has an additional wrapper view outside UITableViewCell
//so we need to do this to get the parent UITableView
- (UITableView *)getParentTableView
{
    UIView * tableView = self.superview;
    while (tableView != nil && [tableView isKindOfClass:[UITableView class]] == NO)
        tableView = tableView.superview;
    
    if (tableView == nil)
        return nil;
    
    return (UITableView *)tableView;
}


- (void)zoomInZoomOut:(CGPoint)point
{
    // Check if current Zoom Scale is greater than half of max scale then reduce zoom and vice versa
    CGFloat newZoomScale = __scrollView.zoomScale > (__scrollView.maximumZoomScale/2)?__scrollView.minimumZoomScale:__scrollView.maximumZoomScale;
    
    CGSize scrollViewSize = __scrollView.bounds.size;
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = point.x - (w / 2.0f);
    CGFloat y = point.y - (h / 2.0f);
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    [__scrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)hideDoneButton
{
    if (!_isDoneAnimating){
        if (_doneButton.superview) {
            _isDoneAnimating = YES;
            _doneButton.alpha = 1.0f;
            [UIView animateWithDuration:0.2f animations:^{
                _doneButton.alpha = 0.0f;
            } completion:^(BOOL finished) {
                _isDoneAnimating = NO;
                [_doneButton removeFromSuperview];
            }];
        }
    }
}

- (void)centerScrollViewContents
{
    CGSize boundsSize = _rootViewController.view.bounds.size;
    CGRect contentsFrame = __imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    __imageView.frame = contentsFrame;
}



#pragma mark - Compute the new size of image relative to width(window)
- (CGRect) centerFrameFromImage:(UIImage*) image
{
    if (!image) return CGRectZero;
    
    CGRect windowBounds = _rootViewController.view.bounds;
    CGSize newImageSize = [self imageResizeBaseOnWidth:windowBounds
                           .size.width oldWidth:image
                           .size.width oldHeight:image.size.height];
    // Just fit it on the size of the screen
    newImageSize.height = MIN(windowBounds.size.height,newImageSize.height);
    return CGRectMake(0.0f, windowBounds.size.height/2 - newImageSize.height/2, newImageSize.width, newImageSize.height);
}

- (CGSize)imageResizeBaseOnWidth:(CGFloat) newWidth oldWidth:(CGFloat) oldWidth oldHeight:(CGFloat)oldHeight
{
    CGFloat scaleFactor = newWidth / oldWidth;
    CGFloat newHeight = oldHeight * scaleFactor;
    return CGSizeMake(newWidth, newHeight);
}


# pragma mark - UIScrollView Delegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return __imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    _isAnimating = YES;
    [self hideDoneButton];
    [self centerScrollViewContents];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    _isAnimating = NO;
}


#pragma mark - Actions

- (void)onBtnDone:(UIButton *)sender {
    self.userInteractionEnabled = NO;
    [sender removeFromSuperview];
    [self dismissViewController];
}

@end
