//
//  CHProcessView.m
//  CHPlayer
//
//  Created by luke.chen on 2017/8/7.
//  Copyright © 2017年 luke.chen. All rights reserved.
//

#import "CHProcessView.h"

#define BAR_HEIGHT 2
#define PROGRESS_LABEL_HEIGHT 13
#define PROGRESS_BAR_HEIGHT 10

@implementation CHProcessView

- (void)dealloc
{
    self.progressView=nil;
    self.progressCacheView=nil;
    self.progressShdowView=nil;
    self.progressBar=nil;
    self.progressLabel=nil;
    self.progressView=nil;
    [self removeGestureRecognizer:self.barPan];
    self.barPan=nil;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubviews];
        
        self.barPan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(barPanAction:)];
        [self addGestureRecognizer:self.barPan];
    }
    return self;
}


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layout];
}


/**
 滑动手势响应
 
 @param pan 手势
 */
-(void)barPanAction:(UIPanGestureRecognizer *)pan
{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(barPanAction:)]) {
        [self.delegate performSelector:@selector(barPanAction:) withObject:pan];
    }
    
    if (cacheTotalDuration<=0) {
        return;
    }
    CGPoint touch =[pan locationInView:pan.view];
    if (touch.x <= 0) {
        touch.x = 0;
    }
    if (touch.x >= CGRectGetWidth(self.frame)) {
        touch.x = CGRectGetWidth(self.frame);
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.isDragged=YES;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.isDragged=YES;
            self.progressView.frame=CGRectMake(0, (self.frame.size.height-BAR_HEIGHT)/2, touch.x, BAR_HEIGHT);
            self.progressBar.center=CGPointMake(touch.x,self.frame.size.height/2);
            
            
            CGFloat percent=touch.x/self.frame.size.width;
            if (cacheTotalDuration!=0) {
                NSInteger curTime=cacheTotalDuration*percent;
                self.progressLabel.text=[NSString stringWithFormat:@"%@/%@",[self getTimeString:curTime],[self getTimeString:cacheTotalDuration]];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            self.isDragged=NO;
            
            
            CGFloat percent=touch.x/self.frame.size.width;
            int time = percent*cacheTotalDuration ;
            
            NSLog(@"设置时间到：%d",time);
            
            // 设置时间
            if (self.delegate&&[self.delegate respondsToSelector:@selector(setPlaySeekToTime:)]) {
                [self.delegate performSelector:@selector(setPlaySeekToTime:) withObject:[NSString stringWithFormat:@"%d",time]];
            }
        }
            break;
            
        default:
            break;
    }
    
    NSLog(@"touch %@",[NSValue valueWithCGPoint:touch]);
}


#pragma mark - Custom Method

/**
 格式化数据格式 用户显示
 
 @param timeCount 总时间
 @return 格式化字符串
 */
-(NSString *)getTimeString:(NSInteger) timeCount
{
    NSInteger minute=timeCount/60;
    
    NSInteger second=timeCount%60;
    NSString * minuteStr=[NSString stringWithFormat:@"%ld",(long)minute];
    NSString * secondStr=[NSString stringWithFormat:@"%ld",(long)second];
    if (minute<10) {
        minuteStr=[NSString stringWithFormat:@"0%@",minuteStr];
    }
    
    if (second<10) {
        secondStr=[NSString stringWithFormat:@"0%@",secondStr];
    }
    return [NSString stringWithFormat:@"%@:%@",minuteStr,secondStr];
}


/**
 设置时间进度
 
 @param currentTime 当前时间  -1 表示忽略的数据
 @param totalDuration 总时间
 @param percent 百分比         -1 表示忽略的数据
 */
-(void)currentTime:(CGFloat) currentTime totalDuration:(CGFloat) totalDuration percent:(CGFloat) percent
{
    
    if (self.isDragged) {
        return;
    }
    
    if (currentTime>totalDuration) {
        currentTime=totalDuration;
    }
    
    if (currentTime!=-1) {
        cacheCurrentTime=currentTime;
    }
    cacheTotalDuration=totalDuration;
    if (percent!=-1) {
        self.progressView.frame=CGRectMake(0, (self.frame.size.height-BAR_HEIGHT)/2, self.frame.size.width*percent, BAR_HEIGHT);
        self.progressBar.center=CGPointMake(self.frame.size.width*percent,self.frame.size.height/2);
        currentTiemPercent=percent;
    }
    
    self.progressLabel.text=[NSString stringWithFormat:@"%@/%@",[self getTimeString:cacheCurrentTime],[self getTimeString:totalDuration]];
    
}

-(void)cacheTime:(CGFloat) cacheTime totalDuration:(CGFloat) totalDuration percent:(CGFloat) percent
{
    self.progressCacheView.frame=CGRectMake(0, (self.frame.size.height-BAR_HEIGHT)/2, self.frame.size.width*percent, BAR_HEIGHT);
    cachePercent=percent;
}

/**
 设置缓存进度
 
 @param percent 百分比
 */
-(void) setCachePercent:(CGFloat) percent
{
    self.progressCacheView.frame=CGRectMake(0, (self.frame.size.height-BAR_HEIGHT)/2, self.frame.size.width*percent, BAR_HEIGHT);
    cachePercent=percent;
}


/**
 重置
 */
-(void) clearn
{
    self.progressView.frame=CGRectZero;
    self.progressCacheView.frame=CGRectZero;
    self.progressBar.frame=CGRectMake(-PROGRESS_BAR_HEIGHT/2, (self.frame.size.height-PROGRESS_BAR_HEIGHT)/2, PROGRESS_BAR_HEIGHT, PROGRESS_BAR_HEIGHT);
    self.progressBar.center=CGPointMake(self.frame.size.width*0,self.frame.size.height/2);
    
    cacheCurrentTime=0;
    currentTiemPercent=0;
    NSString * str=self.progressLabel.text;
    if (str) {
        NSArray * strAry=[str componentsSeparatedByString:@"/"];
        if (strAry.count>1) {
            self.progressLabel.text=[NSString stringWithFormat:@"00:00/%@",[strAry objectAtIndex:1]];
            return;
        }
    }
    self.progressLabel.text=@"00:00/00:00";
}

#pragma mark - LoadSubViews
- (void)loadSubviews{
    [self addSubview:self.progressShdowView];
    [self addSubview:self.progressCacheView];
    [self addSubview:self.progressView];
    [self addSubview:self.progressBar];
    
    [self addSubview:self.progressLabel];
    
    
}


#pragma mark - LayoutSubViews
- (void)layout{
    self.progressShdowView.frame=CGRectMake(0, (self.frame.size.height-BAR_HEIGHT)/2, self.frame.size.width, BAR_HEIGHT);
    self.progressLabel.frame=CGRectMake(0, -5, 200, PROGRESS_LABEL_HEIGHT);
    self.progressBar.frame=CGRectMake(-PROGRESS_BAR_HEIGHT/2, (self.frame.size.height-PROGRESS_BAR_HEIGHT)/2, PROGRESS_BAR_HEIGHT, PROGRESS_BAR_HEIGHT);
    //修正全屏后的BUG
    self.progressCacheView.frame=CGRectMake(0, (self.frame.size.height-BAR_HEIGHT)/2, self.frame.size.width*cachePercent, BAR_HEIGHT);
    self.progressView.frame=CGRectMake(0, (self.frame.size.height-BAR_HEIGHT)/2, self.frame.size.width*currentTiemPercent, BAR_HEIGHT);
    self.progressBar.center=CGPointMake(self.frame.size.width*currentTiemPercent,self.frame.size.height/2);
}

#pragma mark - Get and Set

-(UIView * )progressView
{
    if (_progressView==nil) {
        _progressView=[[UIView alloc] init];
        _progressView.backgroundColor=[UIColor orangeColor];
    }
    return  _progressView;
}


-(UIView * )progressCacheView
{
    if (_progressCacheView==nil) {
        _progressCacheView=[[UIView alloc] init];
        _progressCacheView.backgroundColor=[UIColor whiteColor];
    }
    return  _progressCacheView;
}


-(UIView * )progressShdowView
{
    if (_progressShdowView==nil) {
        _progressShdowView=[[UIView alloc] init];
        _progressShdowView.backgroundColor=[UIColor grayColor];
    }
    return  _progressShdowView;
}


-(UILabel * ) progressLabel
{
    if (_progressLabel==nil) {
        _progressLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _progressLabel.backgroundColor=[UIColor clearColor];
        _progressLabel.font=[UIFont systemFontOfSize:10];
        _progressLabel.textColor=[UIColor grayColor];
        _progressLabel.text=@"00:00/00:00";
        
    }
    return _progressLabel;
}

-(UIImageView *) progressBar
{
    if (_progressBar==nil) {
        _progressBar=[[UIImageView alloc] initWithFrame:CGRectMake(-PROGRESS_BAR_HEIGHT/2, (self.frame.size.height-PROGRESS_BAR_HEIGHT)/2, PROGRESS_BAR_HEIGHT, PROGRESS_BAR_HEIGHT)];
        _progressBar.image=[UIImage imageNamed:@"player_dot_btn.png"];
    }
    return _progressBar;
}

@end
