//
//  CHMediaControlView.m
//  CHPlayer
//
//  Created by luke.chen on 2017/8/8.
//  Copyright © 2017年 luke.chen. All rights reserved.
//

#import "CHMediaControlView.h"
#import "CHProcessView.h"

@interface CHMediaControlView()

@property(nonatomic,strong) UIButton * playAndPauseBtn;
@property(nonatomic,strong) UIButton * fullScreenBtn;
@property(nonatomic,strong) CHProcessView * processView;

@property(nonatomic,unsafe_unretained) MediaType mediaType;

@end

@implementation CHMediaControlView

- (instancetype)initWithFrame:(CGRect)frame withMediaType:(MediaType) mediaType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mediaType=mediaType;
        [self loadSubviews];
        [self layout];
    }
    return self;
}

#pragma mark - loadSubview and Layout

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layout];
}

-(void)loadSubviews
{
    switch (self.mediaType) {
        case VideoType:
        {
            [self addSubview:self.processView];
            [self addSubview:self.playAndPauseBtn];
            [self addSubview:self.fullScreenBtn];
        }
            
            break;
        case AudioType:
        {
            [self addSubview:self.processView];
            [self addSubview:self.playAndPauseBtn];
        }
            
        default:
            break;
    }
}

-(void)layout
{
    switch (self.mediaType) {
        case VideoType:
        {
            self.playAndPauseBtn.frame=CGRectMake((self.frame.size.width-44)/2, (self.frame.size.height-44)/2, 44, 44);
            self.fullScreenBtn.frame=CGRectMake(self.frame.size.width-35, self.frame.size.height-30, 30, 30);
            self.processView.frame=CGRectMake(5, self.frame.size.height-30, self.frame.size.width-5-44, 30);
        }
            break;
        case AudioType:
        {
            self.playAndPauseBtn.frame=CGRectMake((self.frame.size.width-44)/2, (self.frame.size.height-44)/2, 44, 44);
            self.processView.frame=CGRectMake(5, self.frame.size.height-30, self.frame.size.width-5, 30);
        }
        default:
            break;
    }

}


#pragma mark - Custom Method
-(void)clickPlayPauseBtn:(UIButton *)sender
{
    sender.selected=!sender.selected;
}

-(void)clickFullScreenBtn:(UIButton *)sender
{
    sender.selected=!sender.selected;
}

-(void)currentTime:(CGFloat) currentTime totalDuration:(CGFloat) totalDuration percent:(CGFloat) percent
{
    [self.processView currentTime:currentTime totalDuration:totalDuration percent:percent];
}

-(void)cacheTime:(CGFloat) cacheTime totalDuration:(CGFloat) totalDuration percent:(CGFloat) percent
{
    [self.processView cacheTime:cacheTime totalDuration:totalDuration percent:percent];
}

#pragma mark - Get and Set
-(UIButton *)playAndPauseBtn
{
    if (_playAndPauseBtn==nil) {
        _playAndPauseBtn=[[UIButton alloc] init];
        [_playAndPauseBtn setBackgroundImage:[UIImage imageNamed:@"player_play_btn.png"] forState:UIControlStateNormal];
        [_playAndPauseBtn setBackgroundImage:[UIImage imageNamed:@"player_pause_btn.png"] forState:UIControlStateSelected];
        [_playAndPauseBtn addTarget:self action:@selector(clickPlayPauseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _playAndPauseBtn;
}

-(UIButton *) fullScreenBtn
{
    if (_fullScreenBtn==nil) {
        _fullScreenBtn=[[UIButton alloc] init];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"player_full_open_btn.png"] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage imageNamed:@"player_full_quit_btn.png"] forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(clickFullScreenBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}

-(CHProcessView *)processView
{
    if (_processView==nil) {
        _processView=[[CHProcessView alloc] init];
    }
    return _processView;
}

@end
