//
//  FPImageScrollDisplayController.m
//  FPImageScroll
//
//  Created by pcl on 3/25/15.
//  Copyright (c) 2015 pcl. All rights reserved.
//

#import "FPImageScrollDisplayController.h"
#import "FPImageScrollDisplayView.h"

@interface FPImageScrollDisplayController ()
{
    FPImageScrollDisplayView* _scrollDisplayView;
}

@end

@implementation FPImageScrollDisplayController

#pragma mark - life cycle

-(id)initWithimageurls:(NSArray*)urls startIndex:(NSInteger)index
{
    return [self initWithimageurls:urls startIndex:index setting:[FPImageDisplayViewSetting fullScreenSetting]];
}

-(id)initWithimageurls:(NSArray*)urls startIndex:(NSInteger)index setting:(FPImageDisplayViewSetting*)setting
{
    if (self = [super init]) {
        self.extendedLayoutIncludesOpaqueBars = YES;
        _scrollDisplayView = [[FPImageScrollDisplayView alloc] initWithFrame:CGRectMake(0, 0, [[UIApplication sharedApplication] keyWindow].frame.size.width, [[UIApplication sharedApplication] keyWindow].frame.size.height) imageurls:urls startIndex:index setting:setting];
        _scrollDisplayView.accessibilityLabel = @"fullscreen_image";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    //    if (self.animationStyle == FPImageScrollDisplayViewAnimationNormal) {
    //        [self getCurrentImageView].center = [self getOriginViewFrame].;
    //        [UIView animateWithDuration:0.3 animations:^{
    //
    //            [self getCurrentImageView].center = self.view.center;
    //
    //        } completion:^(BOOL finished) {
    //
    //            if (finished) {
    //
    //            }
    //
    //        }];
    //    }
    //    else{
    {
        UIImageView* currentImageView = [self getCurrentImageView];
        CGRect finishRect = currentImageView.frame;
        currentImageView.frame = [self getOriginViewFrame];
        [UIView animateWithDuration:0.3 animations:^{
            
            [self getCurrentImageView].frame = finishRect;
            
        } completion:^(BOOL finished) {
            
            if (finished) {
                
            }
            
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view = _scrollDisplayView;
}

-(void)dismiss:(FPImageScrollDisplayViewAnimationStyle)animationStyle
{
    
    CGRect originRect = [self getOriginViewFrame];
    
    if (self.animationStyle == FPImageScrollDisplayViewAnimationMoveAndZoom) {
        self.originView.frame = CGRectMake(_scrollDisplayView.currentIndex*self.originView.frame.size.width, self.originView.frame.origin.y, self.originView.frame.size.width, self.originView.frame.size.height);
        [_scrollDisplayView.scrollView insertSubview:self.originView atIndex:0];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        if (self.animationStyle == FPImageScrollDisplayViewAnimationNormal) {
            [self getCurrentImageView].frame = originRect;
            
        }
        else if(self.animationStyle == FPImageScrollDisplayViewAnimationMoveAndZoom){
            [self getCurrentImageView].frame = originRect;
        }
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            //            [self presentViewController:fullScreenImageViewController animated:NO completion:nil];
            //            [fakeImageView removeFromSuperview];
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        }
        
    }];
    
}

#pragma mark - event response

-(void)setTapBlock:(void (^)(NSInteger))tapBlock
{
    _tapBlock = tapBlock;
    _scrollDisplayView.tapBlock = tapBlock;
}

#pragma mark - private methods

-(void)loadImageByIndex:(NSInteger)index
{
    [_scrollDisplayView loadImageByIndex:index];
}

-(UIImageView*)getCurrentImageView
{
    return [_scrollDisplayView getCurrentImageView];
}

-(CGRect)getOriginViewFrame
{
    if (!self.originImageFrameArray || [self.originImageFrameArray count] == 0) {
        return CGRectZero;
    }
    
    NSInteger index = [_scrollDisplayView currentIndex];
    if (index >= [self.originImageFrameArray count]) {
        index = 0;
    }
    
    CGRect originRect = ((NSValue*)[self.originImageFrameArray objectAtIndex:index]).CGRectValue;
    return originRect;
}

@end
