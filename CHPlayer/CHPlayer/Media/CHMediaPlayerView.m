//
//  CHMediaPlayerView.m
//  CHPlayer
//
//  Created by luke.chen on 2017/8/7.
//  Copyright © 2017年 luke.chen. All rights reserved.
//

#import "CHMediaPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "CHMediaControlView.h"

@interface CHMediaPlayerView()

@property(nonatomic,strong) AVPlayer *player;
@property(nonatomic,strong) AVPlayerItem *playerItem;
@property(nonatomic,strong) AVPlayerLayer *playerLayer;


@property(nonatomic,unsafe_unretained) CGFloat playTime;            //当前的播放进度
@property(nonatomic,unsafe_unretained) CGFloat totalDuration;       //当前播放的总进度

@property(nonatomic,unsafe_unretained) MediaType mediaType;

@property(nonatomic,unsafe_unretained) id timeObserver;

@property(nonatomic,strong) CHMediaControlView * mediaControlView;

@end

@implementation CHMediaPlayerView

- (instancetype)initWithFrame:(CGRect)frame withMediaType:(MediaType) mediaType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mediaType=mediaType;
        
        [self loadSubview];
        [self layout];
      
    }
    return self;
}

//-(void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    [self layout];
//}

-(void)loadSubview
{
    
    switch (self.mediaType) {
        case AudioType:
            [self addSubview:self.mediaControlView];
            break;
        case VideoType:
            [self.layer addSublayer:self.playerLayer];
            [self addSubview:self.mediaControlView];
        default:
            break;
    }
}

-(void)layout
{
    self.playerLayer.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.mediaControlView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}


/**************************************************************************************
 1.Media Control
 **************************************************************************************/

#pragma mark - Media Control
/**
 加载资源
 
 @param mediaModel 媒体对象
 */
-(void)loadMeidaModel:(CHMediaModel *) mediaModel
{
    [self removePlayNotificationAndPlayeritemObserverAndPlayTimeObserver];
    self.playerItem =[[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[mediaModel url]]];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self addPlayNotificationAndPlayeritemObserverAndPlayTimeObserver];
}


/**
 播放
 */
-(void)play
{
    
}


/**
 暂停
 */
-(void)pause
{
    
}


/**
 清理
 */
-(void)clearn
{
    
}


/**
 设置播放进度
 
 @param toTime 时间
 */
-(void)seekToPlayTime:(CGFloat) toTime
{
    
}

-(void)currentTime:(CGFloat) currentTime totalDuration:(CGFloat) totalDuration percent:(CGFloat) percent
{
    [self.mediaControlView currentTime:currentTime totalDuration:totalDuration percent:percent];
}

-(void)cacheTime:(CGFloat) cacheTime totalDuration:(CGFloat) totalDuration percent:(CGFloat) percent;
{
    [self.mediaControlView cacheTime:cacheTime totalDuration:totalDuration percent:percent];
}

#pragma mark - Notification Obverser Method
#pragma mark - addPlayNotificationAndPlayeritemObserverAndPlayTimeObserver

-(void) addPlayNotificationAndPlayeritemObserverAndPlayTimeObserver;
{
    if (self.playerItem) {
        //设置通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        
        //设置KVO
        [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
        
        //设置TimeObserver
        __weak typeof(self) weakSelf = self;
        self.timeObserver=[self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
            AVPlayerItem *currentItem = weakSelf.playerItem;
            NSArray *loadedRanges = currentItem.seekableTimeRanges;
            if (loadedRanges.count > 0 && currentItem.duration.timescale != 0) {
                NSInteger currentTime = (NSInteger)CMTimeGetSeconds([currentItem currentTime]);
                CGFloat totalTime     = (CGFloat)currentItem.duration.value / currentItem.duration.timescale;
                CGFloat value         = CMTimeGetSeconds([currentItem currentTime]) / totalTime;
                [weakSelf currentTime:currentTime totalDuration:totalTime percent:value];
            }
        }];
    }
}

-(void)removePlayNotificationAndPlayeritemObserverAndPlayTimeObserver
{
    if (self.playerItem) {
        //移除通知
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        
        //移除KVO
        [_playerItem removeObserver:self forKeyPath:@"status" context:nil];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
        
        //移除TimeObserver
        if (self.timeObserver) {
            [self.player removeTimeObserver:self.timeObserver];
            self.timeObserver=nil;
        }
    }
}


- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue]; // 获取更改后的状态
        if (status == AVPlayerStatusReadyToPlay) {
            
            CMTime duration = item.duration;
//            [self setCurrentTime:-1 totalDuration:CMTimeGetSeconds(duration) percent:-1];
//            if (self.isAutoPlaying) {
//                [self.player play];
//                self.currentPlayType=PLAYING;
//            }
            
             [self.player play];
            
        } else if (status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        } else {
            NSLog(@"AVPlayerStatusUnknown");
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 计算缓冲进度
        NSTimeInterval timeInterval=[self availableDuration];
        CMTime duration=self.playerItem.duration;
        CGFloat totalDuration=CMTimeGetSeconds(duration);
        
        CGFloat value=timeInterval/totalDuration;
        
        if (!isnan(value)) {
            [self cacheTime:timeInterval totalDuration:totalDuration percent:value];
        }
    }
}




#pragma mark -Get and Set

-(AVPlayer *)player
{
    if (_player==nil) {
        _player=[[AVPlayer alloc] init];
    }
    return _player;
}

-(AVPlayerLayer *) playerLayer
{
    
    if (_playerLayer==nil) {
        _playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.backgroundColor=[UIColor blackColor].CGColor;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _playerLayer;
}

-(CHMediaControlView *)mediaControlView
{
    if (_mediaControlView==nil) {
        _mediaControlView=[[CHMediaControlView alloc] initWithFrame:CGRectZero withMediaType:self.mediaType];
    }
    return _mediaControlView;
}

@end
