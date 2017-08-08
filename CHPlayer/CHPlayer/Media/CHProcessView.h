//
//  CHProcessView.h
//  CHPlayer
//
//  Created by luke.chen on 2017/8/7.
//  Copyright © 2017年 luke.chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHProcessView : UIView
{
    CGFloat cacheTotalDuration;
    CGFloat cacheCurrentTime;
    
    CGFloat cachePercent;
    CGFloat currentTiemPercent;
}

@property(nonatomic,strong) UIView * progressView;          //播放进度
@property(nonatomic,strong) UIView * progressCacheView;     //缓存进度
@property(nonatomic,strong) UIView * progressShdowView;     //进度阴影
@property(nonatomic,strong) UIImageView * progressBar;      //进度按钮

@property(nonatomic,strong) UILabel * progressLabel;

@property(nonatomic, strong)UIPanGestureRecognizer *barPan;
@property(nonatomic,unsafe_unretained) BOOL isDragged;

@property(nonatomic,unsafe_unretained) id delegate;


-(void)currentTime:(CGFloat) currentTime totalDuration:(CGFloat) totalDuration percent:(CGFloat) percent;

-(void)cacheTime:(CGFloat) cacheTime totalDuration:(CGFloat) totalDuration percent:(CGFloat) percent;

-(void) setCachePercent:(CGFloat) percent;

-(void) clearn;

@end
