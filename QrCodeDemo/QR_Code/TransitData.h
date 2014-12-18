//
//  TransitData.h
//  QrCodeDemo
//
//  Created by 李伟超 on 14-8-29.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransitData : NSObject

@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *Content;
@property (copy, nonatomic) NSString *ImageString;
@property (assign) NSInteger cellClickType;

- (id)initWithName:(NSString *)name Content:(NSString *)content ImageString:(NSString *)imagestring;

//- (id)initWithName:(NSString *)name Content:(NSString *)content ImageString:(NSString *)imagestring celClickType:(NSInteger)clicktype;

@end
