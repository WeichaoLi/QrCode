//
//  CodeType.h
//  QrCodeDemo
//
//  Created by 李伟超 on 14-8-29.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeaderView.h"

typedef enum _HeaderViewDataType {
    HeaderViewTypeTEL = 0,  // telephone, TEL:1111111111
    HeaderViewTypeSMS,      // message,   SMSTO:
    HeaderViewTypeEmail,    // email,  'mailto:' or 'MATMSG:'
    HeaderViewTypeWlan,     // WIFI    WIFI:
    HeaderViewTypeLink,     // Link    'http:' or 'https:'
    HeaderViewTypeVcard,    // Vcard   BEGIN:VCARD ... END:VCARD  OR  MECARD
    HeaderViewTypeDefault,  // text or unkown type.
}HeaderViewDataType;

@interface CodeType : NSObject {
    NSString *datastring;
}

@property (assign) HeaderViewDataType headerDataType;
@property (retain, nonatomic) NSMutableArray *DataArray;
@property (retain, nonatomic) NSMutableDictionary *standardData;

- (id)initWithDataString:(NSString *)dataString; //初始化
- (void)setDataType;   //判断二维码的类型
- (HeaderView *)setHeaderView;  //设置headerview
- (NSString *)stringFromDate:(NSDate *)date;  //date 转成string

- (void)analyseTheData;
- (void)analyseEmailData;  //解析email
- (void)analyseCardData:(NSString *)separateString;   //解析CARD
- (void)analyseWlanData;   //解析WIFI
- (void)analyseSMSData;  //短信

@end
