//
//  LWCDataViewController.h
//  QrCodeDemo
//
//  Created by 李伟超 on 14-8-26.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface LWCDataViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic, copy) NSString *dataString;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end
