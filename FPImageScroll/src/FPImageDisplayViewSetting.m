//
//  FPImageDisplayViewSetting.m
//  FPImageScroll
//
//  Created by pcl on 3/26/15.
//  Copyright (c) 2015 pcl. All rights reserved.
//

#import "FPImageDisplayViewSetting.h"

@implementation FPImageDisplayViewSetting


+(FPImageDisplayViewSetting*)defaultSetting
{
    FPImageDisplayViewSetting* setting = [[FPImageDisplayViewSetting alloc] init];
    setting.backGroundColor = [UIColor whiteColor];
    setting.isFitWidth = YES;
    setting.isScalable = NO;
    setting.isNeedPageControl = YES;
    setting.isRoundCorner = NO;
    setting.isFullScreenPicture = NO;
    setting.showCancelIcon = NO;
//    setting.isRoundCorner = YES;
//    setting.roundCornerRadius = 10;
    return setting;
}

+(FPImageDisplayViewSetting*)fullScreenSetting
{
    FPImageDisplayViewSetting* setting = [[FPImageDisplayViewSetting alloc] init];
    setting.backGroundColor = [UIColor clearColor];
    setting.isFitWidth = YES;
    setting.isScalable = YES;
    setting.isNeedPageControl = YES;
    setting.isRoundCorner = NO;
    setting.isFullScreenPicture = YES;
    setting.showCancelIcon = YES;
    return setting;
}


@end
