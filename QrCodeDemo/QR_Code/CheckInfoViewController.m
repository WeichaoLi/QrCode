//
//  CheckInfoViewController.m
//  QrCodeDemo
//
//  Created by 李伟超 on 14-9-1.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "CheckInfoViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>

@interface CheckInfoViewController ()

@end

@implementation CheckInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lableData.text = self.data;
    CGFloat tmp;
    if (IOS >= 7) {
        tmp = 64;
    }else {
        tmp = 0;
    }
    UILabel *lablename = [[UILabel alloc] initWithFrame:CGRectMake(0, tmp, 200, 30)];
    lablename.text = @"二维码原始内容:";
    [self.view addSubview:lablename];
    
    self.lableData = [[UILabel alloc] initWithFrame:CGRectMake(0, tmp + 40, 320, 30)];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.data attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil]];
    CGRect lableSize = [attributedString boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    self.lableData.frame = CGRectMake(self.lableData.frame.origin.x, self.lableData.frame.origin.y, self.lableData.frame.size.width, lableSize.size.height + 50);
    self.lableData.numberOfLines = 0;
//    self.lableData.textAlignment = NSTextAlignmentNatural;
    self.lableData.text = self.data;
    [self.view addSubview:self.lableData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
