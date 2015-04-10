//
//  QrCodeGenerateViewController.h
//  二维码扫描
//
//  Created by 李伟超 on 15/4/7.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import "QrBaseViewController.h"
#import "QRCodeGenerator.h"

@interface QrCodeGenerateViewController : QrBaseViewController {

}

@property (nonatomic, retain) NSString      *content;
@property (nonatomic, retain) UIImageView   *imageView;

@end
