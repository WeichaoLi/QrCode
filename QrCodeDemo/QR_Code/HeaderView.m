//
//  HeaderView.m
//  QrCodeDemo
//
//  Created by 李伟超 on 14-8-28.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithLogoImage:(UIImage *)image CodeName:(NSString *)name ScanDate:(NSString *)date {
    if (self = [super init]) {
        _LogoView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 70, 70)];
        _LableName = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, 150, 30)];
        _LableDate = [[UILabel alloc] initWithFrame:CGRectMake(100, 65, 150, 30)];
        
        _LableName.textColor = [UIColor colorWithRed:0 green:0.5 blue:1 alpha:1];
        _LableName.font = [UIFont boldSystemFontOfSize:22];
        _LableDate.textColor = [UIColor grayColor];
        _LableDate.font = [UIFont systemFontOfSize:15];
        
        _LogoView.backgroundColor = [UIColor clearColor];
        _LableName.backgroundColor = [UIColor clearColor];
        _LableDate.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_LableDate];
        [self addSubview:_LogoView];
        [self addSubview:_LableName];
        
        _LogoView.image = image;
        _LableName.text = name;
        _LableDate.text = date;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
