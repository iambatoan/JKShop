//
// MHFacebookImageViewer.m
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


#import "MHFacebookImageViewer.h"
#import "MHFacebookImageViewerCell.h"
#import "UIImageView+WebCache.h"

@interface MHFacebookImageViewer()
<
UIGestureRecognizerDelegate,
UIScrollViewDelegate,
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic, strong) UIView * blackMask;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * doneButton;
@property (nonatomic, assign) CGRect originalFrameRelativeToScreen;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@end
@implementation MHFacebookImageViewer

- (void)loadView
{
    [super loadView];
    
    CGRect windowBounds = [[UIScreen mainScreen] bounds];
    
    // Compute Original Frame Relative To Screen
    CGRect newFrame = [self.senderView convertRect:windowBounds toView:nil];
    newFrame.origin = CGPointMake(newFrame.origin.x, newFrame.origin.y);
    newFrame.size = self.senderView.frame.size;
    self.originalFrameRelativeToScreen = newFrame;
    
    self.view = [[UIView alloc] initWithFrame:windowBounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.blackMask = [[UIView alloc] initWithFrame:windowBounds];
    self.blackMask.backgroundColor = [UIColor blackColor];
    self.blackMask.alpha = 0.0f;
    self.blackMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:self.blackMask atIndex:0];
    
    // Add a rotated Tableview
    self.tableView = [[UITableView alloc] initWithFrame:windowBounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.frame = windowBounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.autoresizesSubviews = YES;
    self.tableView.pagingEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentOffset = CGPointMake(0, self.initialIndex * windowBounds.size.width);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneButton setImageEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];  // make click area bigger
    [self.doneButton setImage:[UIImage imageNamed:@"Done"] forState:UIControlStateNormal];
    self.doneButton.frame = CGRectMake(windowBounds.size.width - (51.0f + 9.0f),15.0f, 51.0f, 26.0f);
    
    //Doesn't matter if this is at the end
    self.statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)dealloc
{
    _rootViewController = nil;
    _imageURL = nil;
    _senderView = nil;
    _imageDatasource = nil;
}



#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Just to retain the old version
    if (!self.imageDatasource)
        return 1;
    
    return [self.imageDatasource numberImagesForImageViewer:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"mhfacebookImageViewerCell";
    MHFacebookImageViewerCell * imageViewerCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!imageViewerCell)
    {
        CGRect windowFrame = [[UIScreen mainScreen] bounds];
        imageViewerCell = [[MHFacebookImageViewerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        imageViewerCell.transform = CGAffineTransformMakeRotation(M_PI_2);
        imageViewerCell.frame = CGRectMake(0,0,windowFrame.size.width, windowFrame.size.height);
        imageViewerCell.originalFrameRelativeToScreen = self.originalFrameRelativeToScreen;
        imageViewerCell.viewController = self;
        imageViewerCell.blackMask = self.blackMask;
        imageViewerCell.rootViewController = self.rootViewController;
        imageViewerCell.closingBlock = self.closingBlock;
        imageViewerCell.openingBlock = self.openingBlock;
        imageViewerCell.superView = self.senderView.superview;
        imageViewerCell.senderView = self.senderView;
        imageViewerCell.doneButton = self.doneButton;
        imageViewerCell.initialIndex = self.initialIndex;
        imageViewerCell.statusBarStyle = self.statusBarStyle;
        imageViewerCell.backgroundColor = [UIColor clearColor];
        [imageViewerCell loadAllRequiredViews];
    }
    
    if (!self.imageDatasource) {
        // Just to retain the old version
        [imageViewerCell setImageURL:self.imageURL
                        defaultImage:self.senderView.image
                          imageIndex:0];
    } else {
        [imageViewerCell setImageURL:[self.imageDatasource imageURLAtIndex:indexPath.row imageViewer:self]
                        defaultImage:[self.imageDatasource imageDefaultAtIndex:indexPath.row imageViewer:self]
                          imageIndex:indexPath.row];
    }
    return imageViewerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Because the tableview is rotated 90 degree
    return self.rootViewController.view.bounds.size.width;
}


#pragma mark - Show

- (void)presentFromRootViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self presentFromViewController:rootViewController];
}

- (void)presentFromViewController:(UIViewController *)controller
{
    _rootViewController = controller;
    [[[[UIApplication sharedApplication]windows]objectAtIndex:0]addSubview:self.view];
    [controller addChildViewController:self];
    [self didMoveToParentViewController:controller];
}

@end
