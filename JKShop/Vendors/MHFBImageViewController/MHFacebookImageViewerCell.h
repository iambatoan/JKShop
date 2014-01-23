//
// MHFacebookImageViewer.h
// Version 2.0
//
// Copyright (c) 2013 Michael Henry Pantaleon (http://www.iamkel.net). All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <UIKit/UIKit.h>

@interface MHFacebookImageViewerCell : UITableViewCell
<
UIGestureRecognizerDelegate,
UIScrollViewDelegate
>
{
    JKImageView * __imageView;
    UIScrollView * __scrollView;
    
    CGPoint _panOrigin;
    
    BOOL _isAnimating;
    BOOL _isDoneAnimating;
    BOOL _isLoaded;
}

@property (nonatomic,assign) CGRect originalFrameRelativeToScreen;
@property (nonatomic,weak) UIViewController * rootViewController;
@property (nonatomic,weak) UIViewController * viewController;
@property (nonatomic,weak) UIView * blackMask;
@property (nonatomic,weak) UIButton * doneButton;
@property (nonatomic,weak) UIImageView * senderView;
@property (nonatomic,assign) NSInteger imageIndex;
@property (nonatomic,weak) UIImage * defaultImage;
@property (nonatomic,assign) NSInteger initialIndex;

@property (nonatomic,weak) MHFacebookImageViewerOpeningBlock openingBlock;
@property (nonatomic,weak) MHFacebookImageViewerClosingBlock closingBlock;

@property (nonatomic,weak) UIView * superView;

@property (nonatomic) UIStatusBarStyle statusBarStyle;

- (void)loadAllRequiredViews;
- (void)setImageURL:(NSURL *)imageURL defaultImage:(UIImage*)defaultImage imageIndex:(NSInteger)imageIndex;

@end

