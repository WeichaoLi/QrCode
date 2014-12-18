//
//  DataCell.h
//  QrCodeDemo
//
//  Created by 李伟超 on 14-8-29.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TransitData;

typedef NS_ENUM(NSInteger,CellClickType) {
    CellClickTypeNone = 100,  //cann't click
    CellClickTypeEmail,       //send email
    CellClickTypeOpenLink,    //open link
    CellClickTypeAddressBook, //card add to address book
    CellClickTypeCheckInfo,   //check the data information
};

@interface DataCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lableName;
@property (weak, nonatomic) IBOutlet UILabel *lableContent;
@property (weak, nonatomic) IBOutlet UIImageView *behindImage;
@property (assign) CellClickType cellClickType;

- (id)SetData:(TransitData *)data;

@end
