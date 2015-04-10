//
//  QrBaseViewController.m
//  二维码扫描
//
//  Created by 李伟超 on 15/4/10.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import "QrBaseViewController.h"

@interface QrBaseViewController ()

@end

@implementation QrBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

#ifdef __IPHONE_7_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        
        self.navigationController.navigationBar.translucent = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
