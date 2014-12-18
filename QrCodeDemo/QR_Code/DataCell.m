//
//  DataCell.m
//  QrCodeDemo
//
//  Created by 李伟超 on 14-8-29.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "DataCell.h"
#import "TransitData.h"

@implementation DataCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)SetData:(TransitData *)data {
    self.lableName.text = data.Name;
    self.lableContent.text = data.Content;
    self.imageView.image = [UIImage imageNamed:data.ImageString];
    self.cellClickType = data.cellClickType;
    
    return self;
}

@end
