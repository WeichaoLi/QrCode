//
//  LWCAppDelegate.h
//  QrCodeDemo
//
//  Created by 李伟超 on 14-8-22.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LWCViewController;

@interface LWCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong ,nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) LWCViewController *viewController;

@end
