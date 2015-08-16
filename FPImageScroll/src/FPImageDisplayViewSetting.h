//
//  FPImageDisplayViewSetting.h
//  FPImageScroll
//
//  Created by pcl on 3/26/15.
//  Copyright (c) 2015 pcl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FPImageDisplayViewSetting : NSObject
{

}

@property(nonatomic) BOOL isRoundCorner;                 //是否圆角
@property(nonatomic) float roundCornerRadius;            //圆角半径
@property(nonatomic) BOOL isScalable;                    //是否支持缩放
@property(nonatomic) BOOL isNeedPageControl;             //是否需要bottom部位的翻页指示bar
@property(nonatomic) BOOL isFitWidth;
@property(nonatomic) UIColor* backGroundColor;

@property(nonatomic) BOOL isProportional;                //是否等比例标记,若要设置,请使用初始化方法:
@property(nonatomic) float maxWidthForProportional;      //若等比例的话,需要在startLoading前设置等比例的最大宽度,非等比例无需处理
@property(nonatomic) float maxHeightForProportional;     //若等比例的话,需要在startLoading前设置等比例的最大高度,非等比例无需处理
@property(nonatomic) BOOL isFullScreenPicture;
@property            BOOL showCancelIcon;

+(FPImageDisplayViewSetting*)defaultSetting;
+(FPImageDisplayViewSetting*)fullScreenSetting;

@end
