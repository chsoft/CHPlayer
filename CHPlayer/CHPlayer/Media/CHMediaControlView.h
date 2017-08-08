//
//  CHMediaControlView.h
//  CHPlayer
//
//  Created by luke.chen on 2017/8/8.
//  Copyright © 2017年 luke.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHMediaPlayerView.h"

@interface CHMediaControlView : UIView

- (instancetype)initWithFrame:(CGRect)frame withMediaType:(MediaType) mediaType;

-(void)currentTime:(CGFloat) currentTime totalDuration:(CGFloat) totalDuration percent:(CGFloat) percent;

-(void)cacheTime:(CGFloat) cacheTime totalDuration:(CGFloat) totalDuration percent:(CGFloat) percent;
@end
