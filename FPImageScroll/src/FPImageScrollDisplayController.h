//
//  FPImageScrollDisplayController.h
//  FPImageScroll
//
//  Created by pcl on 3/25/15.
//  Copyright (c) 2015 pcl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPImageDisplayViewSetting.h"

typedef NS_ENUM(NSInteger, FPImageScrollDisplayViewAnimationStyle) {
    FPImageScrollDisplayViewAnimationNormal,
    FPImageScrollDisplayViewAnimationMoveAndZoom
};

@interface FPImageScrollDisplayController : UIViewController

@property (strong,nonatomic) void(^tapBlock)(NSInteger index) ;
@property (nonatomic) NSArray*  originImageFrameArray;
@property (nonatomic) UIView* originView;
@property (nonatomic) FPImageScrollDisplayViewAnimationStyle animationStyle;

-(id)initWithimageurls:(NSArray*)urls startIndex:(NSInteger)index;

-(id)initWithimageurls:(NSArray*)urls startIndex:(NSInteger)index setting:(FPImageDisplayViewSetting*)setting;

-(void)loadImageByIndex:(NSInteger)index;

-(void)dismiss:(FPImageScrollDisplayViewAnimationStyle)animationStyle;

-(UIImageView*)getCurrentImageView;

@end
