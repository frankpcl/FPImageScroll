//
//  FPImageDisplayView.m
//  FPImageScroll
//
//  Created by pcl on 3/24/15.
//  Copyright (c) 2015 pcl. All rights reserved.
//

#import "FPImageDisplayView.h"
#import "UIImageView+WebCache.h"

@implementation FPImageDisplayView
{
    CGRect _originalRect;
    UITapGestureRecognizer* _tapGesture;
    UILongPressGestureRecognizer* _longPressGesture;

    FPImageDisplayViewSetting* _settings;
    
    
    int lazyloadingstatus;
    int retrystatus;
}


#pragma mark - init

-(id)initWithFrame:(CGRect)frame imageURL:(NSString *)imgUrl
{
    return [self initWithFrame:frame imageURL:imgUrl setting:[FPImageDisplayViewSetting defaultSetting]];
}

-(id)initWithFrame:(CGRect)frame imageURL:(NSString *)imgUrl setting:(FPImageDisplayViewSetting *)setting
{
    if (self = [super initWithFrame:frame]) {
        
        [self setUpWithFrame:frame setting:setting];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];

        UIImage* placeHolderImage = _settings.isFullScreenPicture?nil:[UIImage imageNamed:@"img_productbg.png"];
        
        [_imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:placeHolderImage options:SDWebImageRetryFailed  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _image = image;
            [self setImageContentMode:_image];
        }];
    }
    return self;
}

-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return [super hitTest:point withEvent:event];
}

-(id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    return [self initWithFrame:frame image:image setting:[FPImageDisplayViewSetting defaultSetting]];
}

-(id)initWithFrame:(CGRect)frame image:(UIImage *)image setting:(FPImageDisplayViewSetting *)setting
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self setUpWithFrame:frame setting:setting];
        _image = image;
        _imageView.image = _image;
        [self setImageContentMode:_image];
    }
    return self;
}

-(void)setUpWithFrame:(CGRect)frame  setting:(FPImageDisplayViewSetting *)setting
{
    _originalRect = frame;
    _settings = setting;
    
    if (setting.isRoundCorner) {
        [self roundCorner];
    }
    
    if (!setting.isScalable) {
        self.maximumZoomScale = 1;
    }
    else{
        self.maximumZoomScale = 2;
    }
    
    self.delegate = self;
    self.bounces = NO;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _imageView.userInteractionEnabled = YES;
    [self addSubview:_imageView];
   
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    _tapGesture.numberOfTapsRequired = 1;
    [_imageView addGestureRecognizer:_tapGesture];
    
    if (setting.isFullScreenPicture) {
        UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [_tapGesture requireGestureRecognizerToFail:doubleTapGesture];
        [_imageView addGestureRecognizer:doubleTapGesture];
        
        UISwipeGestureRecognizer* upSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipe)];
        upSwipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
        [_imageView addGestureRecognizer:upSwipeGesture];
    }
}


#pragma mark - UI part
-(void)roundCorner
{
    if(_imageView){
        CALayer *layer = [_imageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:_settings.roundCornerRadius];
        [layer setBorderWidth:1.0];
        UIColor *bcolor = [[UIColor alloc] initWithRed:0.8313 green:0.8313 blue:0.8313 alpha:1];
        [layer setBorderColor:[bcolor CGColor]];
        
    }

}

-(void)heightAdded:(float)height bottomtoTop:(BOOL)isBottomtoTop
{
    [self setFrame:CGRectMake(_originalRect.origin.x-height/2,_originalRect.origin.y-1,_originalRect.size.width+height,_originalRect.size.height+height+1)];
    [_imageView setFrame:CGRectMake(0,0,_originalRect.size.width+height,_originalRect.size.height+height+1)];
}

-(void)setImageContentMode:(UIImage*)image
{
    if (!_settings.isFullScreenPicture) {
        if (image.size.width>image.size.height) {
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        else
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    else{
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }

}


#pragma mark - Gesture part
-(void)handleTap:(UITapGestureRecognizer*)sender
{
    if (self.zoomScale!=1.0) {
        [self zoomToRect:self.frame animated:YES];
        _imageView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    }
    else
    {
        if (self.tapBlock) {
            self.tapBlock(self.tag);
        }
    }
}

-(void)doubleTap
{
    if (self.zoomScale!=1.0) {
        [self setZoomScale:1 animated:YES];
        _imageView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    }
   else
    [self setZoomScale:2 animated:YES];
}

-(void)upSwipe
{
    if (self.tapBlock) {
        self.tapBlock(self.tag);
    }
}


#pragma mark - loading图片
-(void)startLoading{
    lazyloadingstatus++;
    if(lazyloadingstatus == 1){
        [self loadingImage];
    }
}

-(void)loadingImage
{
    
}

#pragma mark - scrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}


@end
