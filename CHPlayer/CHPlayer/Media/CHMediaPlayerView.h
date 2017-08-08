//
//  CHMediaPlayerView.h
//  CHPlayer
//
//  Created by luke.chen on 2017/8/7.
//  Copyright © 2017年 luke.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHMediaModel.h"

typedef enum {
    AudioType=0,    //音频类型
    VideoType       //视频类型
}MediaType;


@protocol CHMediaPlayerViewDelegate <NSObject>



@end

@interface CHMediaPlayerView : UIView


/**
 创建播放视图

 @param frame 大小
 @param mediaType 播放类型
 @return obj
 */
- (instancetype)initWithFrame:(CGRect)frame withMediaType:(MediaType) mediaType;


/**************************************************************************************
 1.Media Control
 **************************************************************************************/
/**
 加载资源

 @param mediaModel 媒体对象
 */
-(void)loadMeidaModel:(CHMediaModel *) mediaModel;


/**
 播放
 */
-(void)play;


/**
 暂停
 */
-(void)pause;


/**
 清理
 */
-(void)clearn;


/**
 设置播放进度

 @param toTime 时间
 */
-(void)seekToPlayTime:(CGFloat) toTime;


@end
