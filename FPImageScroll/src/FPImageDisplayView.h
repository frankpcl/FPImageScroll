//
//  FPImageDisplayView.h
//  FPImageScroll
//
//  Created by pcl on 3/24/15.
//  Copyright (c) 2015 pcl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPImageDisplayViewSetting.h"

@interface FPImageDisplayView : UIScrollView<UIScrollViewDelegate>

//@property BOOL canTap;
@property (strong) void(^tapBlock)(NSInteger index) ;
@property (strong) UIImage* image;
@property  BOOL hasLoaded;
@property  UIImageView* imageView;

-(id)initWithFrame:(CGRect)frame imageURL:(NSString *)imgUrl;
-(id)initWithFrame:(CGRect)frame imageURL:(NSString *)imgUrl setting:(FPImageDisplayViewSetting *)_settings;

-(id)initWithFrame:(CGRect)frame image:(UIImage *)image;
-(id)initWithFrame:(CGRect)frame image:(UIImage *)image setting:(FPImageDisplayViewSetting *)_settings;

-(void)heightAdded:(float)height bottomtoTop:(BOOL)isBottomtoTop;

@end
