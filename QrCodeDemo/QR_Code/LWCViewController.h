//
//  LWCViewController.h
//  QrCodeDemo
//
//  Created by 李伟超 on 14-8-22.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface LWCViewController : UIViewController<ZBarReaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZBarReaderDelegate>

@property (strong,nonatomic) ZBarReaderView * readerView;

@end
