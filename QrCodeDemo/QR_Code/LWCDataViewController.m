//
//  LWCDataViewController.m
//  QrCodeDemo
//
//  Created by 李伟超 on 14-8-26.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "LWCDataViewController.h"
#import "DataCell.h"
#import "CodeType.h"
#import "TransitData.h"
#import "CheckInfoViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@interface LWCDataViewController (){
    CodeType *type;
}

@end

@implementation LWCDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"扫描结果";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (IOS >= 7.0) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.backgroundView = nil;
    
    //设置不隐藏导航栏
    self.navigationController.navigationBarHidden = NO;
    
    //重新定制返回按钮
//    UIButton *backButton = [UIButton buttonWithType:101];
//    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    
    //将按钮加入 BarButtonItem (导航栏） 中
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backItem;

    type = [[CodeType alloc] initWithDataString:_dataString];
    
    //设置发送邮件的委托
}

//返回按钮 执行事件
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [type.DataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
    id object = [type.DataArray objectAtIndex:section];
    if ([object isKindOfClass:[NSString class]]) {
        return 1;
    }else if ([object isKindOfClass:[NSArray class]]) {

        return [object count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DataCell";
    DataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] lastObject];
    }
    
    id object = [type.DataArray objectAtIndex:indexPath.section];

    if ([object isKindOfClass:[NSArray class]]) {
        cell.lableContent.textAlignment = NSTextAlignmentLeft;
        cell.lableContent.font = [UIFont systemFontOfSize:14];
        
        TransitData *data = [object objectAtIndex:indexPath.row];
        cell.lableName.text = data.Name;
        cell.lableContent.text = data.Content;
        if (![data.ImageString isEqualToString:@""]) {
            [cell.behindImage setImage:[UIImage imageNamed:data.ImageString]];
        }
        
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:data.Content attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil]];
        CGRect lableSize = [attributedString boundingRectWithSize:CGSizeMake(170, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        cell.lableContent.frame = CGRectMake(cell.lableContent.frame.origin.x, cell.lableContent.frame.origin.y, cell.lableContent.frame.size.width, lableSize.size.height + 32);
        
    }else if ([object isKindOfClass:[NSString class]]) {
        cell.lableName.text = nil;
        cell.lableContent.text = object;
        
        cell.lableContent.textAlignment = NSTextAlignmentCenter;
        cell.lableContent.font = [UIFont systemFontOfSize:20];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [type.DataArray objectAtIndex:indexPath.section];
    
    if ([object isKindOfClass:[NSString class]]) {
        return 50;
    }else if ([object isKindOfClass:[NSArray class]]) {
        TransitData *data = [object objectAtIndex:indexPath.row];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:data.Content attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil]];
        CGRect lableSize = [attributedString boundingRectWithSize:CGSizeMake(170, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        return lableSize.size.height + 32;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 110;
    }else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [type setHeaderView];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataCell *cell = (DataCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == [type.DataArray count]-1) {
        
        CheckInfoViewController *view = [[CheckInfoViewController alloc] initWithNibName:@"CheckInfoViewController" bundle:nil];
        view.data = _dataString;
        [self.navigationController pushViewController:view animated:YES];
        
    }else if (indexPath.section == 0) {
        
        if (type.headerDataType == HeaderViewTypeVcard) {
            
            if ([cell.lableName.text isEqualToString:@"电话"] || [cell.lableName.text isEqualToString:@"手机号"]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",cell.lableContent.text]]];
            }else if ([cell.lableName.text isEqualToString:@"网址"]) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[cell.lableContent.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                
            }else if ([cell.lableName.text isEqualToString:@"邮箱"]) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",cell.lableContent.text]]];
                
            }
        }
        
    }else {
        switch (type.headerDataType) {
            case HeaderViewTypeTEL:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_dataString stringByReplacingOccurrencesOfString:@":" withString:@"://"]]];
                break;
            case HeaderViewTypeEmail:
                [self sendMailInApp];
                break;
            case HeaderViewTypeLink:
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_dataString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                break;
            case HeaderViewTypeVcard:
                [self AddPeople];
                break;
            case HeaderViewTypeSMS:
                [self sendMessage];
                break;
            case HeaderViewTypeWlan:
                
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - 加入通讯录

-(void)AddPeople
{
    //获取通讯录权限
    ABAddressBookRef ab = NULL;
    // ABAddressBookCreateWithOptions is iOS 6 and up.
    if (&ABAddressBookCreateWithOptions) {
        CFErrorRef error = nil;
        ab = ABAddressBookCreateWithOptions(NULL, &error);
        
        if (error) {
            NSLog(@"%@", error);
        }
    }
    if (ab == NULL) { //iOS6 以下 包括iOS6
        ab = ABAddressBookCreate();
    }
    if (ab) {
        // ABAddressBookRequestAccessWithCompletion is iOS 6 and up. 适配IOS6以上版本
        if (&ABAddressBookRequestAccessWithCompletion) {
            ABAddressBookRequestAccessWithCompletion(ab,
                                                     ^(bool granted, CFErrorRef error) {
                                                         if (granted) {
                                                             // constructInThread: will CFRelease ab.
                                                             
                                                         } else {
                                                             CFRelease(ab);
                                                             // Ignore the error
                                                         }
                                                     });
        }
    }
    
    //获取通讯录中的所有人
//    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(ab);
//    NSLog(@"%@" ,allPeople);
    
    
//    //创建一条联系人记录
    ABRecordRef tmpRecord = ABPersonCreate();
    CFErrorRef error;
    BOOL tmpSuccess = NO;
    
    //Nick name
//    CFStringRef tmpNickname = CFBridgingRetain([type.standardData objectForKey:@"姓名"]);
    tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonNicknameProperty, (__bridge CFTypeRef)([type.standardData objectForKey:@"姓名"]), &error);
//    CFRelease(tmpNickname);
    
    //First name
    tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)([type.standardData objectForKey:@"名字"]), &error);
    
    //Last name
    tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonLastNameProperty, (__bridge CFTypeRef)([type.standardData objectForKey:@"姓氏"]), &error);
    
    //phone number
    ABMutableMultiValueRef tmpMutableMultiPhones = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(tmpMutableMultiPhones, (__bridge CFTypeRef)([type.standardData objectForKey:@"电话"]), kABPersonPhoneMainLabel, NULL);
    ABMultiValueAddValueAndLabel(tmpMutableMultiPhones, (__bridge CFTypeRef)([type.standardData objectForKey:@"手机号"]), kABPersonPhoneMobileLabel, NULL);
    tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonPhoneProperty, tmpMutableMultiPhones, &error);
    CFRelease(tmpMutableMultiPhones);
    
    //Organization
    tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonOrganizationProperty, (__bridge CFTypeRef)([type.standardData objectForKey:@"单位"]), &error);
    
    //Job Title
    tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonJobTitleProperty, (__bridge CFTypeRef)([type.standardData objectForKey:@"职位"]), &error);
    
    //Email
    ABMutableMultiValueRef tmpMutableMultiEmail = ABMultiValueCreateMutable(kABPersonEmailProperty);
    ABMultiValueAddValueAndLabel(tmpMutableMultiEmail, (__bridge CFTypeRef)([type.standardData objectForKey:@"邮箱"]), kABOtherLabel, NULL);
    tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonEmailProperty, tmpMutableMultiEmail, &error);
    CFRelease(tmpMutableMultiEmail);
    
    //URL
    ABMutableMultiValueRef tmpMutableMultiURL = ABMultiValueCreateMutable(kABPersonURLProperty);
    ABMultiValueAddValueAndLabel(tmpMutableMultiURL, (__bridge CFTypeRef)([type.standardData objectForKey:@"网址"]), kABPersonHomePageLabel, NULL);
    tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonURLProperty, tmpMutableMultiURL, &error);
    CFRelease(tmpMutableMultiEmail);

    //address
    if ([type.standardData objectForKey:@"地址"]) {
        ABMutableMultiValueRef tmpMutableMultiADR = ABMultiValueCreateMutable(kABPersonAddressProperty);
        NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
        [addressDictionary setObject:[type.standardData objectForKey:@"地址"] forKey:(NSString *) kABPersonAddressStreetKey];
        ABMultiValueAddValueAndLabel(tmpMutableMultiADR, (__bridge CFTypeRef)(addressDictionary), kABHomeLabel, NULL);
        tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonAddressProperty, tmpMutableMultiADR, &error);
        CFRelease(tmpMutableMultiADR);
    }
    
    //Note
//    CFStringRef tmpNote = CFBridgingRetain([type.standardData objectForKey:@"备注"]);
    tmpSuccess = ABRecordSetValue(tmpRecord, kABPersonNoteProperty, (__bridge CFTypeRef)([type.standardData objectForKey:@"备注"]), &error);
        
    //保存记录
    tmpSuccess = ABAddressBookAddRecord(ab, tmpRecord, &error);
    CFRelease(tmpRecord);
    //保存数据库
    tmpSuccess = ABAddressBookSave(ab, &error);
    if (tmpSuccess) {
        [self alertWithMessage:@"添加成功"];
    }else {
        [self alertWithMessage:@"添加失败"];
    }
//    CFRelease(ab);
}

#pragma mark - 发送邮件

//激活邮件功能
- (void)sendMailInApp
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (!mailClass) {
        [self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能"];
        return;
    }
    if (![mailClass canSendMail]) {
        [self alertWithMessage:@"用户没有设置邮件账户"];
        return;
    }
    [self displayMailPicker];
}

- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: [type.standardData objectForKey:@"邮箱"]];
    [mailPicker setToRecipients: toRecipients];
    
    //设置主题
    [mailPicker setSubject:[type.standardData objectForKey:@"主题"]];
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:[type.standardData objectForKey:@"抄送"], nil];
    [mailPicker setCcRecipients:ccRecipients];
    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:[type.standardData objectForKey:@"密送"], nil];
    [mailPicker setBccRecipients:bccRecipients];
    
    // 添加一张图片
//    UIImage *addPic = [UIImage imageNamed: @"Icon@2x.png"];
//    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
//    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"Icon.png"];
    
    //添加一个pdf附件
//    NSString *file = [self fullBundlePathFromRelativePath:@"高质量C++编程指南.pdf"];
//    NSData *pdf = [NSData dataWithContentsOfFile:file];
//    [mailPicker addAttachmentData: pdf mimeType: @"" fileName: @"高质量C++编程指南.pdf"];
    
    NSString *emailBody = [type.standardData objectForKey:@"内容"];
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailPicker animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件成功保存";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
    [self alertWithMessage:msg];
}

#pragma mark - 发送短信

- (void)sendMessage {
    Class MessageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (!MessageClass) {
        [self alertWithMessage:@"当前系统版本不支持应用内发送短信功能"];
        return;
    }
    if (![MessageClass canSendText]) {
        [self alertWithMessage:@"用户没有设置邮件账户"];
        return;
    }
    [self displayMessagePicker];
}

- (void)displayMessagePicker {
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    
    [messageController setRecipients:[NSArray arrayWithObjects:[type.standardData objectForKey:@"收信人"], nil]];
    [messageController setSubject:[type.standardData objectForKey:@"主题"]];
    [messageController setBody:[type.standardData objectForKey:@"短信内容"]];
    
    [self presentViewController:messageController animated:YES completion:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MessageComposeResultSent:
            msg = @"发送成功";
            break;
        case MessageComposeResultFailed:
            msg = @"发送成功";
            break;
        case MessageComposeResultCancelled:
            msg = @"取消发送";
            break;
        default:
            msg = @"";
            break;
    }
    [self alertWithMessage:msg];
}

@end
