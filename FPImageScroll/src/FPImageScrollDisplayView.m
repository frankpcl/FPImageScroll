//
//  FPImageScrollDisplayController.m
//  FPImageScroll
//
//  Created by pcl on 3/24/15.
//  Copyright (c) 2015 pcl. All rights reserved.
//

#import "FPImageScrollDisplayView.h"
#import "FPImageDisplayView.h"
#import "DDPageControl.h"
#define DETAIL_PIC_MARGIN 15.0f
#define DETAIL_PIC_SIZE ([UIScreen mainScreen].bounds.size.width)


@implementation FPImageScrollDisplayView
{
    
    NSMutableDictionary* _imageHolders;
    NSArray* _urls;
    FPImageDisplayViewSetting* _setting;
    NSArray* _images;
    NSInteger _startIndex;
    NSInteger _currentIndex;
    NSMutableDictionary* _loadedURL;
    
    float _singleDisplayWidth;
    float _singleDisplayHeight;
    CGRect _originRect;
}

-(id)initWithFrame:(CGRect)frame andImages:(NSArray*)images
{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame imageurls:(NSArray*)urls startIndex:(NSInteger)index
{
    return [self initWithFrame:frame imageurls:urls startIndex:index setting:[FPImageDisplayViewSetting defaultSetting]];
}


-(id)initWithFrame:(CGRect)frame imageurls:(NSArray*)urls startIndex:(NSInteger)index setting:(FPImageDisplayViewSetting*)setting
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        _originRect = frame;
        _urls = urls;
        _setting = setting;
        _startIndex = index;
        _currentIndex = index;
        _singleDisplayHeight = frame.size.height;
        _singleDisplayWidth = frame.size.width;
        _loadedURL = [[NSMutableDictionary alloc] init];
        _imageHolders = [NSMutableDictionary dictionaryWithCapacity:urls.count];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        if (setting.backGroundColor && ![setting.backGroundColor isEqual:[UIColor clearColor]]) {
            _scrollView.backgroundColor = setting.backGroundColor;
        }
        else {
            _scrollView.backgroundColor = [UIColor blackColor];
        }
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.clipsToBounds = YES;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(urls.count*frame.size.width, frame.size.height);
        [self addSubview:_scrollView];
        
        if(setting.isNeedPageControl && urls.count>1)
        {
            _pageControl = [[DDPageControl alloc] init];
            [_pageControl setCenter:CGPointMake(self.bounds.size.width/2, frame.size.height-15)] ;
            _pageControl.numberOfPages = [_urls count];
            _pageControl.currentPage = index;
            _pageControl.enabled = YES;
            _pageControl.backgroundColor = [UIColor clearColor];
            [_pageControl setType: DDPageControlTypeOnFullOffFull] ;
            [_pageControl setOnColor: [UIColor colorWithRed:0XF4/255.0 green:0X43/255.0 blue:0X36/255.0 alpha:1]] ;
            [_pageControl setOffColor: [UIColor colorWithRed:0XE2/255.0 green:0XE2/255.0 blue:0XE4/255.0 alpha:1]] ;
            [_pageControl setIndicatorDiameter: 8.0f] ;
            [_pageControl setIndicatorSpace: 8.0f] ;
            [self addSubview:_pageControl];
            
        }
    }
    
    //closeIcon
    if (setting.showCancelIcon) {
        UIImageView* closeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 14, 14)];
        closeIcon.image = [UIImage imageNamed:@"scrollImage_close.png"];
        [self addSubview:closeIcon];
    }
    
    [self loadImageByIndex:_startIndex];
    return self;
}

-(UIImageView*)getCurrentImageView
{
    FPImageDisplayView* holder = _imageHolders[@(_currentIndex)];
    return holder.imageView;
}

-(void)loadImageByIndex:(NSInteger)index
{
    if (index >= _urls.count) {
        return;
    }
    _currentIndex = index;
    _pageControl.currentPage = index;
    
    if ([[_loadedURL allKeys] containsObject:@(index)]) {
        [_scrollView setContentOffset:CGPointMake(index*_singleDisplayWidth, 0)];
    }
    else{
        [_scrollView setContentOffset:CGPointMake(index*_singleDisplayWidth, 0)];
        
        FPImageDisplayView* imageHolder = [[FPImageDisplayView alloc] initWithFrame:CGRectMake(index*_singleDisplayWidth, 0, _singleDisplayWidth, _singleDisplayHeight) imageURL:_urls[index] setting:_setting];
        [_imageHolders setObject:imageHolder forKey:@(_currentIndex)];
        imageHolder.tag = index;
        if (self.tapBlock) {
            imageHolder.tapBlock = self.tapBlock;
        }
        [_scrollView addSubview:imageHolder];
        [_loadedURL setObject:_urls[index] forKey:@(index)];
    }
    
    [self bringSubviewToFront:_pageControl];
}

-(void)renderImageByIndex:(NSInteger)index
{
    if (index >= _urls.count || index<0) {
        return;
    }
    
    
    if ([[_loadedURL allKeys] containsObject:@(index)]) {
        return;
    }
    else{
        
        FPImageDisplayView* imageHolder = [[FPImageDisplayView alloc] initWithFrame:CGRectMake(index*_singleDisplayWidth, 0, _singleDisplayWidth, _singleDisplayHeight) imageURL:_urls[index] setting:_setting];
        [_imageHolders setObject:imageHolder forKey:@(index)];
        imageHolder.tag = index;
        if (self.tapBlock) {
            imageHolder.tapBlock = self.tapBlock;
        }
        [_scrollView addSubview:imageHolder];
        [_loadedURL setObject:_urls[index] forKey:@(index)];
    }
    
}


-(void)setTapBlock:(void (^)(NSInteger))tapBlock
{
    _tapBlock = tapBlock;
    for (FPImageDisplayView* imageHolder in _scrollView.subviews) {
        imageHolder.tapBlock = self.tapBlock;
    }
}

-(void)setCurrentOffset:(CGPoint)point
{
    float offsetY = point.y;
    if (offsetY<=0) {
        [self heightAdded:-1*offsetY bottomtoTop:YES];
    }
    else
    {
        [_scrollView setFrame:CGRectMake(0, offsetY/2, _originRect.size.width, _originRect.size.height-offsetY/2)];
        _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, _originRect.size.height-offsetY/2);
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = floor(scrollView.contentOffset.x/_singleDisplayWidth+0.5);
    [self loadImageByIndex:index];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = floor(scrollView.contentOffset.x/_singleDisplayWidth);
    if (index == _currentIndex) {
        index += 1;
    }
    if (index!=_currentIndex) {
        [self renderImageByIndex:index];
    }
}

-(void)heightAdded:(float)height bottomtoTop:(BOOL)isBottomtoTop
{
    FPImageDisplayView* imageHolder =  _imageHolders[@(_currentIndex)];
    _scrollView.frame = CGRectMake(_originRect.origin.x , -1*height, _originRect.size.width, _originRect.size.height+height);
    [imageHolder heightAdded:height bottomtoTop:isBottomtoTop];
}


@end
