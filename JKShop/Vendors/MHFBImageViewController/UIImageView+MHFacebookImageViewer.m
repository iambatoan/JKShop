
#pragma mark - Custom Gesture Recognizer that will Handle imageURL

@interface MHFacebookImageViewerTapGestureRecognizer : UITapGestureRecognizer
@property (nonatomic,strong) NSURL * imageURL;
@property (nonatomic,strong) MHFacebookImageViewerOpeningBlock openingBlock;
@property (nonatomic,strong) MHFacebookImageViewerClosingBlock closingBlock;
@property (nonatomic,weak) id<MHFacebookImageViewerDatasource> imageDatasource;
@property (nonatomic,assign) NSInteger initialIndex;

@end

@implementation MHFacebookImageViewerTapGestureRecognizer
@synthesize imageURL;
@synthesize openingBlock;
@synthesize closingBlock;
@synthesize imageDatasource;
@end



@implementation UIImageView (MHFacebookImageViewer)

#pragma mark - Initializer for UIImageView
- (void)setupImageViewer {
    [self setupImageViewerWithCompletionOnOpen:nil onClose:nil];
}

- (void)setupImageViewerWithCompletionOnOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close {
    [self setupImageViewerWithImageURL:nil onOpen:open onClose:close];
}

- (void)setupImageViewerWithImageURL:(NSURL*)url {
    [self setupImageViewerWithImageURL:url onOpen:nil onClose:nil];
}


- (void)setupImageViewerWithImageURL:(NSURL *)url onOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close{
    self.userInteractionEnabled = YES;
    MHFacebookImageViewerTapGestureRecognizer * tapGesture = [[MHFacebookImageViewerTapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tapGesture.imageURL = url;
    tapGesture.openingBlock = open;
    tapGesture.closingBlock = close;
    [self addGestureRecognizer:tapGesture];
    tapGesture = nil;
}


- (void)setupImageViewerWithDatasource:(id<MHFacebookImageViewerDatasource>)imageDatasource onOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close {
    [self setupImageViewerWithDatasource:imageDatasource initialIndex:0 onOpen:open onClose:close];
}

- (void)setupImageViewerWithDatasource:(id<MHFacebookImageViewerDatasource>)imageDatasource initialIndex:(NSInteger)initialIndex onOpen:(MHFacebookImageViewerOpeningBlock)open onClose:(MHFacebookImageViewerClosingBlock)close{
    self.userInteractionEnabled = YES;
    MHFacebookImageViewerTapGestureRecognizer *  tapGesture = [[MHFacebookImageViewerTapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tapGesture.imageDatasource = imageDatasource;
    tapGesture.openingBlock = open;
    tapGesture.closingBlock = close;
    tapGesture.initialIndex = initialIndex;
    [self addGestureRecognizer:tapGesture];
    tapGesture = nil;
}


#pragma mark - Handle Tap
- (void)didTap:(MHFacebookImageViewerTapGestureRecognizer*)gestureRecognizer {
    
    MHFacebookImageViewer * imageBrowser = [[MHFacebookImageViewer alloc]init];
    imageBrowser.senderView = self;
    imageBrowser.imageURL = gestureRecognizer.imageURL;
    imageBrowser.openingBlock = gestureRecognizer.openingBlock;
    imageBrowser.closingBlock = gestureRecognizer.closingBlock;
    imageBrowser.imageDatasource = gestureRecognizer.imageDatasource;
    imageBrowser.initialIndex = gestureRecognizer.initialIndex;
    if (self.image)
        [imageBrowser presentFromRootViewController];
}


#pragma mark Removal
- (void)removeImageViewer
{
    for (UIGestureRecognizer * gesture in self.gestureRecognizers)
    {
        if ([gesture isKindOfClass:[MHFacebookImageViewerTapGestureRecognizer class]])
        {
            [self removeGestureRecognizer:gesture];
            
            MHFacebookImageViewerTapGestureRecognizer *  tapGesture = (MHFacebookImageViewerTapGestureRecognizer *)gesture;
            tapGesture.imageURL = nil;
            tapGesture.openingBlock = nil;
            tapGesture.closingBlock = nil;
        }
    }
}

@end


