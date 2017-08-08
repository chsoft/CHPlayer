//
//  ViewController.m
//  CHPlayer
//
//  Created by luke.chen on 2017/7/21.
//  Copyright © 2017年 luke.chen. All rights reserved.
//

#import "ViewController.h"
#import "CHMediaPlayerView.h"
#import "CHMediaModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    CHMediaPlayerView * mediaPlayerView=[[CHMediaPlayerView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 200) withMediaType:VideoType];
    mediaPlayerView.backgroundColor=[UIColor grayColor];
    
    [self.view addSubview:mediaPlayerView];
    
    
    CHMediaModel * model=[[CHMediaModel alloc] init];
    model.url=@"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4";
    
    [mediaPlayerView loadMeidaModel:model];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
