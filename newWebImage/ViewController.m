//
//  ViewController.m
//  newWebImage
//
//  Created by 庄黛淳华 on 2017/6/6.
//  Copyright © 2017年 庄黛淳华. All rights reserved.
//

#import "ViewController.h"
#import "newWebImage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	UIImageView *imv= [[UIImageView alloc]initWithFrame:(CGRect){{100, 100}, 0, 0}];
	NSURL *url = [NSURL URLWithString:@"http://wx4.sinaimg.cn/crop.0.101.600.450.240/005M94J9ly1fgbdaae0pvj30go0s6dhc.jpg"];
	[imv newLoadURL:url];
	[self.view addSubview:imv];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
