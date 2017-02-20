//
//  YGBanner.m
//  ScrollView循环滚到-2
//
//  Created by wuyiguang on 16/1/8.
//  Copyright (c) 2016年 YG. All rights reserved.
//

#import "YGBanner.h"
#import "UIImageView+WebCache.h"
//#import "YGMacroHeader.h"
@implementation YGBannerModel

@end


@interface YGBanner () <UIScrollViewDelegate>

@property (nonatomic, copy) imageHandle block;


@end

@implementation YGBanner
{
   
    UIPageControl *_pgCtrl;
    UIImageView *_leftView; // 左边的图片
    UIImageView *_centerView; // 中间的图片
    UIImageView *_rightView; // 右边的图片;
    UILabel *_titleLbl; // 标题
    NSArray *_models; // 轮播显示的模型
    NSInteger _currIndex; // 当前下标
    NSTimer *_timer;
    CGSize _size; // scollView的宽高
}

- (instancetype)initWithFrame:(CGRect)frame imageHandle:(imageHandle)handle
{
    if (self = [super initWithFrame:frame]) {
        
        
        // 记录
        _size = frame.size;
        _currIndex = 0;
        self.block = handle;
   
        // 实例化ScrollView
        _sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _size.width, _size.height)];
   //++++++++++++++++++++++++++++++++++
        _sv.pagingEnabled = YES;
        
        _sv.bounces = NO;
        
        _sv.showsHorizontalScrollIndicator = NO;
        
        _sv.showsVerticalScrollIndicator = NO;
        
        _sv.delegate = self;
        
        // 三屏循环滚到
        _sv.contentSize = CGSizeMake(_size.width * 3, _size.height);
 //++++++++++++++++++++++++++++++++++
        
        [self addSubview:_sv];
        
       
        //////////////  小轮播图
//        self.smallvc = [[UIScrollView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(_sv.frame), _size.width, 70)];
//        self.smallvc.bounces = NO;
//        self.smallvc.showsHorizontalScrollIndicator = NO;
//        self.smallvc.showsVerticalScrollIndicator = NO;
//       // self.smallvc.backgroundColor = [UIColor orangeColor];
//        self.smallvc.delegate  = self;
//    
//        [self addSubview:self.smallvc];
        
        ///////////////////
        
        // 添加tap手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle)];
        [_sv addGestureRecognizer:tap];
        
        // 标题
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_sv.frame)-30, _sv.bounds.size.width, 30)];
        _titleLbl.font = [UIFont systemFontOfSize:15];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self addSubview:_titleLbl];
        
        // 实例化PageControl
        _pgCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width /2-40, _size.height - 23, 80, 23)];
        _pgCtrl.pageIndicatorTintColor = [[UIColor cyanColor]colorWithAlphaComponent:0.5];
        _pgCtrl.enabled = NO;
        [self addSubview:_pgCtrl];
    }
    return self;
}

// 刷新模型
- (void)reloadYGBanner:(NSArray *)models
{
    if (models.count == 0) {
        NSLog(@"YGBannerModel模型数组不能为空");
        return;
    }
    
    _models = models;
    
    // 开启定时器
    [self startTimer];
    
    YGBannerModel *model = _models[_currIndex];
    
    _titleLbl.text = [NSString stringWithFormat:@"    %@", model.title];
    
    // 点的个数为数组的count
    _pgCtrl.numberOfPages = _models.count;
    
    [self instanceImageView];
}

// tap手势
- (void)tapHandle
{
    if (self.block) {
        
        self.block(_currIndex);
    }
}

/**
 *  实例化三个图片
 */
- (void)instanceImageView
{
    for (int i = 0; i < 3; i++) {
        
        UIView *tmpV = [_sv viewWithTag:5555+i];
        [tmpV removeFromSuperview];
    }
    
    // 只有三屏
    for (int i = 0; i < 3; i++) {
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(_size.width * i, 0, _size.width, _size.height)];
   //++++++++++++++++++++++++++++++++++
        imageV.tag = 5555+i;
        
        [_sv addSubview:imageV];
        
        // 最后一张图
        if (i == 0) {
            
            YGBannerModel *model = [_models lastObject];
            
            [imageV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
            _leftView = imageV;
            
        } else if (i == 1) {
            
            // 中间的图片，第一张图
            YGBannerModel *model = [_models firstObject];
            
            [imageV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
            
            _centerView = imageV;
            
        } else {
            
            // 右边的图片，第二张
            YGBannerModel *model = _models[0];
            
            [imageV sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
            
            _rightView = imageV;
        }
    }
    
    // 滚动到中间这张图
    [_sv setContentOffset:CGPointMake(_size.width, 0) animated:NO];
}

/**
 *  开启定时器
 */
- (void)startTimer
{
    if (_timer) {
        
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
}

/**
 *  自动滚屏
 */
- (void)autoScroll
{
    // 滚动到下一屏
    [_sv setContentOffset:CGPointMake(_size.width * 2, 0) animated:YES];
    
    // 重新设置图片
    [self reloadImageView];
}

/**
 重新设置图片
 */
- (void)reloadImageView
{
    // 获取x的偏移量
    CGFloat offsetX = _sv.contentOffset.x;
    
    // 向左滑动
    if (offsetX > _size.width) {
        
        _currIndex = (_currIndex + 1) % _models.count;
        
    } else if (offsetX < _size.width) {
        // 向右滑动
        
        _currIndex = (_currIndex - 1 + _models.count) % _models.count;
    }
    
    NSInteger leftIndex = (_currIndex - 1 + _models.count) % _models.count;
    NSInteger rightIndex = (_currIndex + 1) % _models.count;
    
    // 重新设置图片
    YGBannerModel *model = _models[leftIndex];
    [_leftView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    
    model = _models[_currIndex];
    [_centerView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    
    model = _models[rightIndex];
    [_rightView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
}

- (void)positionView
{
    [self reloadImageView];
    
    _pgCtrl.currentPage = _currIndex;
    
    YGBannerModel *model = _models[_currIndex];
    
    _titleLbl.text = [NSString stringWithFormat:@"    %@", model.title];
    
    // 滚动到中间
    [_sv setContentOffset:CGPointMake(_size.width, 0) animated:NO];
}

#pragma mark - UIScrollViewDelegate

// 拖动时，停止减速会被调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self positionView];
    
    [self startTimer];
}

// 当设置setContentOffset且为YES时被调用，手势拖动不会调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self positionView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
    _timer = nil;
}



@end
