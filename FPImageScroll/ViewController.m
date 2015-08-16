//
//  ViewController.m
//  FPImageScroll
//
//  Created by pcl on 7/26/15.
//  Copyright (c) 2015 pcl. All rights reserved.
//

#import "ViewController.h"
#import "FPImageScrollDisplayView.h"
#import "FPImageScrollDisplayController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray* urls = @[@"http://www.cctv.com/performance/20070207/images/105368_1.jpg",@"http://i01.i.aliimg.com/wsphoto/v0/2013832523_1/Women-all-match-cowboy-hippie-street-style-fashion-lady-lazy-pillow-bags-Vintage-Canvas-women-bag.jpg_200x200.jpg",@"http://i01.i.aliimg.com/wsphoto/v1/32253726799_1/2015-Hot-Sale-Luxury-Bag-Women-Messenger-Bags-Genuine-Leather-Women-Handbags-for-Women-Shoulder-Bags.jpg_200x200.jpg",@"http://i01.i.aliimg.com/wsphoto/v0/32276812015_1/6-Colors-Star-Style-Metal-Frame-Coating-Eyewear-Glasses-2015-New-Vintage-Fashion-Sunglasses-Women-Brand.jpg_200x200.jpg"];
    FPImageScrollDisplayView* imageDisplay = [[FPImageScrollDisplayView alloc] initWithFrame:CGRectMake(100, 100, 200, 200) imageurls:urls startIndex:0 setting:[FPImageDisplayViewSetting defaultSetting]];
    [self.view addSubview:imageDisplay];
    
    __weak FPImageScrollDisplayView* _weakImageDisplay = imageDisplay;
    
    [imageDisplay setTapBlock:^(NSInteger index) {
       
        FPImageScrollDisplayController* imageDisplayControll = [[FPImageScrollDisplayController alloc] initWithimageurls:urls startIndex:index setting:[FPImageDisplayViewSetting fullScreenSetting]];
        imageDisplayControll.originImageFrameArray = @[[NSValue valueWithCGRect:_weakImageDisplay.frame]];
        
        __weak FPImageScrollDisplayController* _weakImageDisplayControll = imageDisplayControll;
        [imageDisplayControll setTapBlock:^(NSInteger index) {
            [_weakImageDisplayControll dismiss:FPImageScrollDisplayViewAnimationNormal];
            [_weakImageDisplay setCurrentIndex:index];
        }];
        
        [self presentViewController:imageDisplayControll animated:NO completion:nil];
        
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
