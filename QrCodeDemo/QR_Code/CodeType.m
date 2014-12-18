//
//  CodeType.m
//  QrCodeDemo
//
//  Created by 李伟超 on 14-8-29.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "CodeType.h"
#import "HeaderView.h"
#import "TransitData.h"
#import "NSString+Separate.h"

@implementation CodeType {
    NSArray *array;
}

- (id)initWithDataString:(NSString *)dataString {
    if (self = [super init]) {
        datastring = dataString;
        [self setDataType];
        _DataArray = [NSMutableArray array];
        _standardData = [NSMutableDictionary dictionary];
        [self analyseTheData];
    }
    return self;
}

- (void)setDataType {
    if ([datastring rangeOfString:@":"].length) {
        NSString *result = [datastring substringToIndex:[datastring rangeOfString:@":"].location];
        if (![result caseInsensitiveCompare:@"TEL"]) {
            //电话
            _headerDataType = HeaderViewTypeTEL;
        }else if (![result caseInsensitiveCompare:@"WIFI"]){
            //Wi-Fi
            _headerDataType = HeaderViewTypeWlan;
        }else if (![result caseInsensitiveCompare:@"HTTP"] || ![result caseInsensitiveCompare:@"https"]) {
            //网址
            _headerDataType = HeaderViewTypeLink;
        }else if (![result caseInsensitiveCompare:@"SMSTO"]) {
            //短信
            _headerDataType = HeaderViewTypeSMS;
        }else if (![result caseInsensitiveCompare:@"mailto"] || ![result caseInsensitiveCompare:@"MATMSG"]) {
            //邮件
            _headerDataType = HeaderViewTypeEmail;
        }else if ([datastring rangeOfString:@"CARD"].length) {
            //名片
            _headerDataType = HeaderViewTypeVcard;
        }else {
            //文本
            _headerDataType = HeaderViewTypeDefault;
        }
    }else {
        _headerDataType = HeaderViewTypeDefault;
    }
}

- (HeaderView *)setHeaderView {
    UIImage *headerImage = nil;
    NSString *headerName = @"文本";
    switch (_headerDataType) {
        case HeaderViewTypeTEL:
            headerImage = [UIImage imageNamed:@"qr_phone.png"];
            headerName = @"电话";
            break;
        case HeaderViewTypeSMS:
            headerImage = [UIImage imageNamed:@"qr_sms.png"];
            headerName = @"短信";
            break;
        case HeaderViewTypeEmail:
            headerImage = [UIImage imageNamed:@"qr_email.png"];
            headerName = @"邮件";
            break;
        case HeaderViewTypeLink:
            headerImage = [UIImage imageNamed:@"qr_link.png"];
            headerName = @"网址";
            break;
        case HeaderViewTypeWlan:
            headerImage = [UIImage imageNamed:@"qr_wifi.png"];
            headerName = @"WIFI";
            break;
        case HeaderViewTypeVcard:
            headerImage = [UIImage imageNamed:@"qr_card.png"];
            headerName = @"通讯录";
            break;
        case HeaderViewTypeDefault:
            headerImage = [UIImage imageNamed:@"qr_text.png"];
            headerName = @"文本";
            break;
        default:
            break;
    }
    return [[HeaderView alloc] initWithLogoImage:headerImage CodeName:headerName ScanDate:[self stringFromDate:[NSDate date]]];
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

- (void)analyseTheData {
    switch (_headerDataType) {
        case HeaderViewTypeTEL:{
            //在case中申明变量，要加花括号
            array = [datastring componentsSeparatedByString:@":"];
            TransitData *data = [[TransitData alloc] initWithName:@"电话号码" Content:array[1] ImageString:nil];
            NSMutableArray *arr = [NSMutableArray arrayWithObject:data];
            [_DataArray addObject:arr];
            [_DataArray addObject:@"拨打电话"];
        }
            break;
        case HeaderViewTypeSMS:
            [self analyseSMSData];
        
            break;
        case HeaderViewTypeEmail:
            [self analyseEmailData];
            break;
        case HeaderViewTypeLink:{
            
            TransitData *data = [[TransitData alloc] initWithName:@"网址" Content:datastring ImageString:nil];
            array = [NSMutableArray arrayWithObject:data];
            [_DataArray addObject:array];
            [_DataArray addObject:@"打开网址"];
        }
            break;
        case HeaderViewTypeWlan:
            [self analyseWlanData];
            break;
        case HeaderViewTypeVcard:{
            
            if ([datastring componentsSeparatedByString:@"\n"].count >[datastring componentsSeparatedByString:@";"].count) {
                [self analyseCardData:@"\n"];
            }else if ( [datastring componentsSeparatedByString:@"\n"].count < [datastring componentsSeparatedByString:@";"].count) {
                [self analyseCardData:@";"];
            }else {
                TransitData *data = [[TransitData alloc] initWithName:@"ERROR" Content:@"信息解析错误" ImageString:nil];
                array = [NSMutableArray arrayWithObject:data];
                [_DataArray addObject:array];
            }
        }
            break;
        case HeaderViewTypeDefault:{
            TransitData *data = [[TransitData alloc] initWithName:@"文本内容" Content:datastring ImageString:nil];
            array = [NSMutableArray arrayWithObject:data];
            [_DataArray addObject:array];
        }
            break;
        default:
            break;
    }
    [_DataArray addObject:@"查看原始信息"];
}

- (void)analyseEmailData {
/*
    NSString *result = [datastring substringToIndex:[datastring rangeOfString:@":"].location];
    
    if (![result caseInsensitiveCompare:@"mailto"]) {
//        mailto:email@address.com?subject=这是主题&body=内容啊
        
        TransitData *mailto = [[TransitData alloc] initWithName:@"邮箱" Content:[datastring SeparateFromString:@":" ToString:@"?"] ImageString:nil];
        NSMutableArray *arr = [NSMutableArray arrayWithObject:mailto];
        TransitData *subject = [[TransitData alloc] initWithName:@"主题" Content:[datastring SeparateFromString:@"=" ToString:@"&"] ImageString:nil];
        [arr addObject:subject];
        TransitData *body = [[TransitData alloc] initWithName:@"内容" Content:[[datastring SeparateFromString:@"&" ToString:nil] SeparateFromString:@"=" ToString:nil] ImageString:nil];
        [arr addObject:body];
        [_DataArray addObject:arr];
        
    }else if (![result caseInsensitiveCompare:@"MATMSG"]) {
        
//        MATMSG:;     TO: test@address.com;    SUB:这是标题;    BODY:这是邮件内容;    ;;
        NSMutableArray *Content = [NSMutableArray array];
        NSArray *SepaAarry = [datastring componentsSeparatedByString:@";"];
        for (NSString *Info in SepaAarry) {
            NSArray *arr = [Info componentsSeparatedByString:@":"];
            TransitData *data;
            if (![arr[0] caseInsensitiveCompare:@"TO"]) {
                data = [[TransitData alloc] initWithName:@"邮箱" Content:arr[1] ImageString:nil];
            }
            if (![arr[0] caseInsensitiveCompare:@"SUB"]) {
                data = [[TransitData alloc] initWithName:@"主题" Content:arr[1] ImageString:nil];
            }
            if (![arr[0] caseInsensitiveCompare:@"BODY"]) {
                data = [[TransitData alloc] initWithName:@"内容" Content:arr[1] ImageString:nil];
            }
            data ? [Content addObject:data] : nil;
//            [Content addObject:data];
        }
        [_DataArray addObject:Content];
        
    }
*/
    

    NSString *result = [datastring substringToIndex:[datastring rangeOfString:@":"].location];
    NSArray *OrderVALUE;
    NSArray *OrderKEY;
    NSArray *OrderImage;
    if (![result caseInsensitiveCompare:@"mailto"]) {
    ////        mailto:email@address.com?subject=这是主题&body=内容啊
        
        datastring = [datastring stringByReplacingOccurrencesOfString:@"?subject" withString:@";subject"];
        datastring = [datastring stringByReplacingOccurrencesOfString:@"&subject" withString:@";subject"];
        datastring = [datastring stringByReplacingOccurrencesOfString:@"&body" withString:@";body"];
        
        OrderKEY = @[@"mailto:", @"cc=", @"bcc=", @"subject=", @"body="];
        OrderVALUE = @[@"邮箱", @"抄送", @"密送", @"主题", @"内容"];
        OrderImage = @[@"", @"", @"", @"", @""];
        
    }else if (![result caseInsensitiveCompare:@"MATMSG"]) {
    ////        MATMSG:;     TO: test@address.com;    SUB:这是标题;    BODY:这是邮件内容;    ;;
        
        OrderKEY = @[@"TO:", @"CC:", @"BCC:", @"SUB:", @"BODY:"];
        OrderVALUE = @[@"邮箱", @"抄送", @"密送", @"主题", @"内容"];
        OrderImage = @[@"", @"", @"", @"", @""];
    }
    NSString *separateString = @";";
    NSDictionary *Order = [NSDictionary dictionaryWithObjects:OrderVALUE forKeys:OrderKEY];
    NSDictionary *Order1 = [NSDictionary dictionaryWithObjects:OrderImage forKeys:OrderKEY];
    
    NSMutableArray *Content = [NSMutableArray array];
    for (NSString *KEY in OrderKEY) {
        if ([datastring rangeOfString:KEY].length) {
            TransitData *data = [[TransitData alloc] initWithName:[Order objectForKey:KEY] Content:[datastring SeparateFromString:KEY ToString:separateString] ImageString:[Order1 objectForKey:KEY]];
            data ? [Content addObject:data] : nil;
            
            [_standardData setObject:[datastring SeparateFromString:KEY ToString:separateString] forKey:[Order objectForKey:KEY]];
        }
    }
    
    [_DataArray addObject:Content];
    [_DataArray addObject:@"发送邮件"];
}

- (void)analyseCardData:(NSString *)separateString {
/*
//    BEGIN:VCARD
//    VERSION:3.0
//    N:张三宝
//    EMAIL:email@address.com
//    TEL:021-68008600
//    TEL;CELL:13001700186
//    ADR:上海市长宁区翔殷路188号云大楼616室
//    ORG:上海二维科技有限公司
//    TITLE:软件工程师
//    URL:http://www.erwei.com
//    NOTE:备注信息
//    END:VCARD
 
 OR
 
//    MECARD:TEL:4414212;URL:http://2621.com;EMAIL:2112211＃J#J;NOTE:21121212@qq.com;N:当时;ORG:非典时;TIL:反对;ADR:发达摄氏度;
*/
    
    NSString *result = [datastring substringToIndex:[datastring rangeOfString:@":"].location];
    
    NSArray *OrderVALUE;
    NSArray *OrderKEY;
    NSArray *OrderImage;
    if ([result isEqualToString:@"BEGIN"]) {
//        OrderKEY = @[@"N:", @"ORG:", @"TITLE:", @"TEL:", @"TEL;CELL:", @"EMAIL:", @"URL:", @"ADR:", @"NOTE:"];
//        OrderVALUE = @[@"姓名", @"单位", @"职位", @"电话", @"手机号", @"邮箱", @"网址", @"地址", @"备注"];
//        OrderImage = @[@"", @"", @"", @"action_call.png", @"action_call.png", @"action_mail.png", @"action_url.png", @"", @""];
        OrderKEY = @[@"N:", @"FN:", @"LN:", @"ORG:", @"TITLE:", @"TEL:", @"TEL;CELL:", @"EMAIL:", @"URL:", @"ADR:", @"NOTE:"];
        OrderVALUE = @[@"姓名", @"名字", @"姓氏", @"单位", @"职位", @"电话", @"手机号", @"邮箱", @"网址", @"地址", @"备注"];
        OrderImage = @[@"", @"", @"", @"", @"", @"action_call.png", @"action_call.png", @"action_mail.png", @"action_url.png", @"", @""];
        
    }else if ([result isEqualToString:@"MECARD"]) {

        datastring = [datastring stringByReplacingOccurrencesOfString:@"MECARD:" withString:@"MECARD:;"];
        
        OrderKEY = @[@"N:", @"ORG:", @"TIL:", @"TEL:", @"EMAIL:", @"URL:", @"ADR:", @"NOTE:"];
        OrderVALUE = @[@"姓名", @"单位", @"职位", @"电话", @"邮箱", @"网址", @"地址", @"备注"];
        OrderImage = @[@"", @"", @"", @"action_call.png", @"action_mail.png", @"action_url.png", @"", @""];
    }
    
    NSDictionary *Order = [NSDictionary dictionaryWithObjects:OrderVALUE forKeys:OrderKEY];
    NSDictionary *Order1 = [NSDictionary dictionaryWithObjects:OrderImage forKeys:OrderKEY];
    
    NSMutableArray *Content = [NSMutableArray array];
    
    for (NSString *KEY in OrderKEY) {
        if ([datastring rangeOfString:[NSString stringWithFormat:@"%@%@",separateString,KEY]].length) {
            TransitData *data = [[TransitData alloc] initWithName:[Order objectForKey:KEY] Content:[datastring SeparateFromString:[separateString stringByAppendingString:KEY] ToString:separateString] ImageString:[Order1 objectForKey:KEY]];
            data ? [Content addObject:data] : nil;
            
            [_standardData setObject:[datastring SeparateFromString:[separateString stringByAppendingString:KEY] ToString:separateString] forKey:[Order objectForKey:KEY]];
        }
    }
    [_DataArray addObject:Content];
    [_DataArray addObject:@"加入通讯录"];
}

- (void)analyseWlanData {
    
    NSArray *OrderVALUE;
    NSArray *OrderKEY;
    NSArray *OrderImage;
    
    OrderKEY = @[@"S:", @"T:", @"P:"];
    OrderVALUE = @[@"SSID", @"加密", @"密码"];
    OrderImage = @[@"", @"", @""];
    NSString *separateString = @";";
    
    NSDictionary *Order = [NSDictionary dictionaryWithObjects:OrderVALUE forKeys:OrderKEY];
    NSDictionary *Order1 = [NSDictionary dictionaryWithObjects:OrderImage forKeys:OrderKEY];
    
    NSMutableArray *Content = [NSMutableArray array];
    
    for (NSString *KEY in OrderKEY) {
        TransitData *data = [[TransitData alloc] initWithName:[Order objectForKey:KEY] Content:[datastring SeparateFromString:KEY ToString:separateString] ImageString:[Order1 objectForKey:KEY]];
        data ? [Content addObject:data] : nil;
    }
    [_DataArray addObject:Content];
}

- (void)analyseSMSData {
    
//    SMSTO:15270024074:Hi Nick,反对分地方
    
    array = [datastring componentsSeparatedByString:@":"];
    TransitData *data = [[TransitData alloc] initWithName:@"收信人" Content:array[1] ImageString:@"action_call.png"];
    NSMutableArray *arr = [NSMutableArray arrayWithObject:data];
    TransitData *data1 = [[TransitData alloc] initWithName:@"短信内容" Content:array[2] ImageString:nil];
    [arr addObject:data1];
    [_DataArray addObject:arr];
    [_DataArray addObject:@"发送短信"];
    
    [_standardData setObject:array[1] forKey:@"收信人"];
    [_standardData setObject:array[2] forKey:@"短信内容"];
}

@end
