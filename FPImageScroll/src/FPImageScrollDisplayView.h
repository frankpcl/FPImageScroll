//
//  FPImageScrollDisplayController.h
//  FPImageScroll
//
//  Created by pcl on 3/24/15.
//  Copyright (c) 2015 pcl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPImageDisplayViewSetting.h"
#import "DDPageControl.h"

@interface FPImageScrollDisplayView : UIView<UIScrollViewDelegate>
{
    
}

@property (strong,nonatomic) void(^tapBlock)(NSInteger index) ;
@property          NSInteger startIndex;
@property         DDPageControl*  pageControl;
@property          NSInteger currentIndex;
@property          UIScrollView* scrollView;

-(id)initWithFrame:(CGRect)frame andImages:(NSArray*)images;

-(id)initWithFrame:(CGRect)frame imageurls:(NSArray*)urls startIndex:(NSInteger)index;

-(id)initWithFrame:(CGRect)frame imageurls:(NSArray*)urls startIndex:(NSInteger)index setting:(FPImageDisplayViewSetting*)setting;

-(void)loadImageByIndex:(NSInteger)index;

-(void)heightAdded:(float)height bottomtoTop:(BOOL)isBottomtoTop;
-(void)setCurrentOffset:(CGPoint)point;

-(UIImageView*)getCurrentImageView;

@end
