//
//  QrCodeGenerateViewController.m
//  二维码扫描
//
//  Created by 李伟超 on 15/4/7.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import "QrCodeGenerateViewController.h"

#define width_scale self.view.frame.size.width/320
#define height_scale self.view.frame.size.height/568

@implementation QrCodeGenerateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imageView = [[UIImageView alloc] init];
    [_imageView setFrame:CGRectMake(10*width_scale, 10*height_scale, 300*width_scale, 300*height_scale)];
    _imageView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_imageView];
    [_imageView setImage:[QRCodeGenerator qrImageForString:@"dfjkdkfjk"
                                                imageSize:_imageView.frame.size.width
                                            withPointType:0
                                         withPositionType:0
                                                 withColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]]];
}

@end
