//
//  TransitData.m
//  QrCodeDemo
//
//  Created by 李伟超 on 14-8-29.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "TransitData.h"
#import "NSString+Separate.h"

@implementation TransitData

- (id)initWithName:(NSString *)name Content:(NSString *)content ImageString:(NSString *)imagestring {
    if (self = [super init]) {
        _Name = name;
        _Content = content;
        _ImageString = imagestring;
    }
    return self;
}

//- (id)initWithName:(NSString *)name Content:(NSString *)content ImageString:(NSString *)imagestring celClickType:(NSInteger)clicktype {
//    if (self = [super init]) {
//        _Name = name;
//        _Content = content;
//        _ImageString = imagestring;
//        _cellClickType = clicktype;
//    }
//    return self;
//}

@end
