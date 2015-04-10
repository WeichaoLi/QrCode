//
//  LWCViewController.m
//  QrCodeDemo
//
//  Created by 李伟超 on 14-8-22.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "LWCViewController.h"
#import "LWCDataViewController.h"
#import "QrCodeGenerateViewController.h"

#define VIEW_WIDTH self.view.frame.size.width
#define VIEW_HEIGHT self.view.frame.size.height
#define SCAN_AREA_WIDTH 320
#define SCAN_AREA_HEIGHT 375
#define TOP_HEIGHT 80

#define width_scale self.view.frame.size.width/320
#define height_scale self.view.frame.size.height/568

@interface LWCViewController () {
    UIImageView *imageView;
    UIActivityIndicatorView * activeityView;
    UIButton *backButton;
    UIButton *alubmButton;
    UIButton *LightButton;
}

@end

//static BOOL isyes = YES;

@implementation LWCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"二维码扫描";
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _readerView = [[ZBarReaderView alloc] init];
    _readerView.frame = CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT);
    _readerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _readerView.readerDelegate = self;
//    [_readerView.scanner setSymbology:ZBAR_CODE128 config:ZBAR_CFG_MAX_LEN to:0];
    //模拟器
    if (TARGET_IPHONE_SIMULATOR) {
        ZBarCameraSimulator *cameraSimulator
        = [[ZBarCameraSimulator alloc]initWithViewController:self];
        cameraSimulator.readerView = _readerView;
    }
    _readerView.tracksSymbols = NO;
    
//    _readerView.scanCrop = CGRectMake((SIDE_WIDTH - ScreenAdjust)/VIEW_WIDTH, (TOP_HEIGHT + addHeight)/VIEW_HEIGHT, (SCAN_AREA_WIDTH + 2*ScreenAdjust)/VIEW_WIDTH, (SCAN_AREA_HEIGHT + 3*ScreenAdjust)/VIEW_HEIGHT);
//    _readerView.scanCrop = CGRectMake(0.05, 0.2, 0.9, 0.6);
    
//    UIView *testview = [[UIView alloc] initWithFrame:CGRectMake(0.05*VIEW_WIDTH, 0.2*VIEW_HEIGHT, 0.9*VIEW_WIDTH, 0.6*VIEW_HEIGHT)];
//    testview.alpha = 0.3;
//    testview.backgroundColor = [UIColor redColor];
//    [_readerView addSubview:testview];
    
    //关闭闪光灯
    _readerView.torchMode = 0;
    [self.view addSubview:_readerView];
    [self setZBarBorder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [activeityView startAnimating];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self performSelector:@selector(startScanerView) withObject:nil afterDelay:0.5f];
}

- (void)startScanerView {
    [activeityView stopAnimating];
    [_readerView start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_readerView stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds {
    CGFloat x,y,width,height;
    x = rect.origin.x / readerViewBounds.size.width;
    y = rect.origin.y / readerViewBounds.size.height;
    width = rect.size.width / readerViewBounds.size.width;
    height = rect.size.height / readerViewBounds.size.height;
    return CGRectMake(x, y, width, height);
}*/

//设置区域的场景
- (void)setZBarBorder {
    //扫描区域的背景
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    imageView.frame = CGRectMake((VIEW_WIDTH - SCAN_AREA_WIDTH*width_scale)/2, TOP_HEIGHT*height_scale , SCAN_AREA_WIDTH*width_scale, SCAN_AREA_HEIGHT*height_scale);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    imageView.backgroundColor = [UIColor clearColor];
    [_readerView addSubview:imageView];
    
    //扫描区域的动画
    activeityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activeityView.frame = imageView.frame;
    activeityView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    activeityView.alpha = 0.6;
    activeityView.backgroundColor = [UIColor blackColor];
    [_readerView addSubview:activeityView];
    
    UIView *TopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, TOP_HEIGHT*height_scale)];
    TopView.alpha = 0.8;
    TopView.backgroundColor = [UIColor clearColor];
    [_readerView addSubview:TopView];
    
    UIView *BottomView = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height , VIEW_WIDTH, VIEW_HEIGHT - imageView.frame.origin.y - imageView.frame.size.height)];
    BottomView.alpha = 0.8;
    BottomView.backgroundColor = [UIColor clearColor];
    BottomView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:BottomView];
    
    //显示提示语
    UILabel *LableSuggest = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 60)];
    LableSuggest.backgroundColor = [UIColor clearColor];
    LableSuggest.numberOfLines = 0;
    LableSuggest.text = @"将二维码图案放置在下面方形区域内,\n距离摄像头10厘米左右最佳.";
    LableSuggest.textColor = [UIColor whiteColor];
    
    [TopView addSubview:LableSuggest];
    
    //返回按钮
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(14*width_scale, (BottomView.frame.size.height - 40*height_scale)/2, 132*width_scale, 40*height_scale)];
    [backButton addTarget:self action:@selector(backToPrevious) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"scan_cancle.png"] forState:UIControlStateNormal];
    backButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [BottomView addSubview:backButton];
    
    //开灯按钮
    LightButton = [[UIButton alloc] initWithFrame:CGRectMake(174*width_scale, (BottomView.frame.size.height - 40*height_scale)/2, 132*width_scale, 40*height_scale)];
    [LightButton addTarget:self action:@selector(SwithFlashlight:) forControlEvents:UIControlEventTouchUpInside];
    [LightButton setImage:[UIImage imageNamed:@"scan_flash_on.png"] forState:UIControlStateNormal];
    LightButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [BottomView addSubview:LightButton];
}

- (void)backToPrevious {
    QrCodeGenerateViewController  *codeGenerate = [[QrCodeGenerateViewController alloc] init];
    [self.navigationController pushViewController:codeGenerate animated:YES];
}

- (void)SelectFromAlubm {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    ZBarReaderController* read = [ZBarReaderController new];
    
    read.readerDelegate = self;
    
    CGImageRef cgImageRef = image.CGImage;
    
    id<NSFastEnumeration> results = [read scanImage:cgImageRef];
    
    if (results) {
        int quality = 0;
        ZBarSymbol *bestResult = nil;
        for(ZBarSymbol *sym in results) {
            int q = sym.quality;
            if(quality < q) {
                quality = q;
                bestResult = sym;
            }
        }
        
        LWCDataViewController *dataView = [[LWCDataViewController alloc] initWithNibName:@"LWCDataViewController" bundle:nil];
        if ([bestResult.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            dataView.dataString = [NSString stringWithCString:[bestResult.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }else {
            dataView.dataString = bestResult.data;
        }
//        dataView.dataString = bestResult.data;

        [self.navigationController pushViewController:dataView animated:YES];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您选择的二维码不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [picker popToRootViewControllerAnimated:YES];
    }
//    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)SwithFlashlight:(id)sender {
    if (_readerView.torchMode == 0) {
        [LightButton setImage:[UIImage imageNamed:@"scan_flash_off.png"] forState:UIControlStateNormal];
        _readerView.torchMode = 1;
    }else {
        [LightButton setImage:[UIImage imageNamed:@"scan_flash_on.png"] forState:UIControlStateNormal];
        _readerView.torchMode = 0;
    }
}

#pragma mark - ZBarReaderViewDelegate

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image {
    symbols.filterSymbols = YES;
    for (ZBarSymbol *symbol in symbols) {
        LWCDataViewController *dataView = [[LWCDataViewController alloc] initWithNibName:@"LWCDataViewController" bundle:nil];
        //处理部分中文乱码问题
        
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            dataView.dataString = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }else {
            dataView.dataString = symbol.data;
        }
        [self.navigationController pushViewController:dataView animated:YES];
        break;
    }
    [_readerView stop];
}

@end
