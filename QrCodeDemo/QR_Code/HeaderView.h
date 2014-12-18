//
//  HeaderView.h
//  QrCodeDemo
//
//  Created by 李伟超 on 14-8-28.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property (retain) UIImageView *LogoView;
@property (retain) UILabel *LableName;
@property (retain) UILabel *LableDate;

- (id)initWithLogoImage:(UIImage*)image CodeName:(NSString *)name ScanDate:(NSString *)date;

@end
