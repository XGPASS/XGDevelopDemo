//
//  XGSacnController.m
//  XGDevelopDemo
//
//  Created by 小广 on 2016/11/29.
//  Copyright © 2016年 小广. All rights reserved.
//

#import "XGSacnController.h"
#import <AVFoundation/AVFoundation.h>
#import "XGQRScanView.h"
#import "XGSoundHelper.h"
#import "UIImage+XJHResize.h"

@interface XGSacnController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVCaptureDevice * device;
@property (nonatomic, strong) AVCaptureDeviceInput * input;
@property (nonatomic, strong) AVCaptureMetadataOutput * output;
@property (nonatomic, strong) AVCaptureSession * session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, strong) UIButton *navBackButton; //返回按钮
@property (nonatomic, strong) UIButton *torchButton;  // 手电筒按钮
@property (nonatomic, strong) UIButton *scanButton; // 底部扫一扫按钮
@property (nonatomic, strong) UIButton *photoButton; // 相册按钮
@property (nonatomic, strong) UIImageView *scanFrameView; //相框

@property (nonatomic, strong) XGQRScanView *scanView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, assign) BOOL torchFlashed;//闪光灯是否打开
/** is url or not*/
@property (nonatomic, assign) BOOL isURL;
/** url */
@property (nonatomic, copy) NSString *resultString;

@property (nonatomic, copy) XGScanResultBlock block;

@end

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

@implementation XGSacnController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [_session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO];
    self.torchFlashed = NO;
    [self.session beginConfiguration];
    [self.device lockForConfiguration:nil];
    if (self.device.torchMode == AVCaptureTorchModeOn) {
        [self.device setTorchMode:AVCaptureTorchModeOff];
        [self.device setFlashMode:AVCaptureFlashModeOff];
    }
    [self.device unlockForConfiguration];
    [self.session commitConfiguration];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -

- (void)setupNav {
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self initScanComponent];
    [self setUpUIWithTransparentSize:CGSizeMake(255.0f, 255.0f)];
}

#pragma mark - Public
// 扫描结果的block
- (void)scanCompleteBlock:(XGScanResultBlock)block {
    self.block = block;
}

#pragma mark- Custom Accessors

- (void)initScanComponent {
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error;
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    
    if (error) {
        NSLog(@"-----硬件错误：%@------",[error localizedDescription]);
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        
    } else {
        // Output
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // Session
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        
        if ([_session canAddOutput:self.output]) {
            [_session addOutput:self.output];
        }
        
        _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode39Code];
        [_output setRectOfInterest:[self scanRectWithSize:CGSizeMake(240, 240)]];
        
        // Preview
        _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
        _preview.videoGravity =AVLayerVideoGravityResize;
        _preview.frame =self.view.layer.bounds;
        [self.view.layer insertSublayer:_preview atIndex:0];
        
        [_session startRunning];
    }
}

#pragma mark - Event Handler

- (void)goBackAction:(id)sender {
    [self goBack];
}

// 返回的处理，模态/nav
- (void)goBack {
    if ([self.navigationController.viewControllers count] > 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)torchAction:(id)sender {
    if (!self.torchFlashed) {
        //打开闪光灯
        if ([self.device hasTorch] && [self.device hasFlash]) {
            if (self.device.torchMode == AVCaptureTorchModeOff) {
                [self.session beginConfiguration];
                [self.device lockForConfiguration:nil];
                [self.device setTorchMode:AVCaptureTorchModeOn];
                [self.device setFlashMode:AVCaptureFlashModeOn];
                [self.device unlockForConfiguration];
                [self.session commitConfiguration];
                //[self.torchButton setSelected: YES];
                [self.torchButton setImage:[UIImage imageNamed:@"led_flash_on"] forState:UIControlStateNormal];
                self.torchFlashed = !self.torchFlashed;
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"您的设备无闪光灯"];
        }
    } else {
        //关闭闪光灯
        [self.session beginConfiguration];
        [self.device lockForConfiguration:nil];
        if (self.device.torchMode == AVCaptureTorchModeOn) {
            [self.device setTorchMode:AVCaptureTorchModeOff];
            [self.device setFlashMode:AVCaptureFlashModeOff];
            [self.torchButton setImage:[UIImage imageNamed:@"led_flash_off"] forState:UIControlStateNormal];
            self.torchFlashed = !self.torchFlashed;
        }
        [self.device unlockForConfiguration];
        [self.session commitConfiguration];
    }
}

//读取相册
- (void)albumButtonAction:(id)sender {
    
    [_session stopRunning];
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:^{}];
    
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue;
    
    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        [_session stopRunning];
        [XGSoundHelper playSoundFromFile:@"beep.wav" fromBundle:[NSBundle mainBundle] asAlert:YES];
        [self scanResultWithResult:stringValue];
    }
}


#pragma mark - Private

- (CGRect)scanRectWithSize:(CGSize)size {
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat scanWidth = size.width;
    CGFloat scanHeight = size.height;
    CGFloat scanOriginX = self.view.center.x - scanWidth/2;
    CGFloat scanOriginY = self.view.center.y - scanHeight/2;
    CGRect scanRect = CGRectMake(scanOriginY/screenHeight, scanOriginX/screenWidth, scanHeight/screenHeight, scanWidth/screenWidth);
    return scanRect;
}

- (void)scanResultWithResult:(NSString *)result {
    // 扫一扫的结果  显示跳转结果待定
    
    if (result.length > 0) {
        
        [self alertControllerMessage:result];
//        if (self.block) {
//            self.block(result);
//        }
//        [self goBack];
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
    [_session startRunning];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取选中的照片
    UIImage *pickImage = info[UIImagePickerControllerEditedImage];
    
    if (!pickImage) {
        pickImage = info[UIImagePickerControllerOriginalImage];
    }
    
    CIImage *image = [CIImage imageWithCGImage:[pickImage resizedImageToSize:CGSizeMake(320.0, 320.0)].CGImage];
    //初始化  将类型设置为二维码
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //设置数组，放置识别完之后的数据
        NSArray *features = [detector featuresInImage:image];
        //判断是否有数据（即是否是二维码）
        if (features.count >= 1) {
            //取第一个元素就是二维码所存放的文本信息
            CIQRCodeFeature *feature = features[0];
            NSString *scannedResult = feature.messageString;
            //通过对话框的形式呈现
            [self scanResultWithResult:scannedResult];
            //[self alertControllerMessage:scannedResult];
        } else {
            [self alertControllerMessage:@"这不是一个二维码"];
        }
    }];
}

//由于要写两次，所以就封装了一个方法
-(void)alertControllerMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//}


#pragma mark - 布局扫描页面
// 布局UI
- (void)setUpUIWithTransparentSize:(CGSize)size {
    if (self.maskView == nil) {
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, XGScreenWidth, XGScreenHeight)];
    }
    
    [self.maskView setBackgroundColor:[UIColor clearColor]];
    
    /// x的状态栏，比之前多了24
    CGFloat posY = kStatusBarHeight > 20.0f ? 44.0f : 30.0f;
    // 返回按钮
    if (self.navBackButton == nil) {
        self.navBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.navBackButton.frame = CGRectMake(15.0f, posY, 35.0f, 35.0f);
        [self.navBackButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        [self.navBackButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 手电筒按钮
    if (self.torchButton == nil) {
        self.torchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.torchButton.frame = CGRectMake(XGScreenWidth - 35.0f - 15.0f, posY, 35.0f, 35.0f);
        [self.torchButton setImage:[UIImage imageNamed:@"led_flash_off"] forState:UIControlStateNormal];
        [self.torchButton addTarget:self action:@selector(torchAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.scanFrameView == nil) {
        self.scanFrameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan"]];
        self.scanFrameView.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    }
    //[self.scanFrameView setFrame:CGRectMake(self.view.center.x - 120, self.view.center.y - 120, 240, 240)];
    
    CGFloat bottomMargin = kStatusBarHeight > 20.0f ? 44.0f : 20.0f;
    // 扫一扫按钮
    if (self.scanButton == nil) {
        self.scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat posX = (XGScreenWidth / 2.0)/2.0 - 30.0;
        self.scanButton.frame = CGRectMake(posX, XGScreenHeight - bottomMargin - 60.0, 60.0, 60.0);
        // CCFF00
        [self.scanButton setTitleColor:HEXCOLOR(0xCCFF00) forState:UIControlStateNormal];
        [self.scanButton setTitle:@"扫一扫" forState:UIControlStateNormal];
        self.scanButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.scanButton setTitleEdgeInsets:UIEdgeInsetsMake(30.0, -28.0, 0.0, 0.0)];
        [self.scanButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 12.0, 20.0, 0.0)];
        [self.scanButton setImage:[UIImage imageNamed:@"QR_scan_icon"] forState:UIControlStateNormal];
    }
    
    // 相册按钮
    if (self.photoButton == nil) {
        // AAAAAA
        self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat posX = (XGScreenWidth / 2.0)/2.0 - 30.0 + (XGScreenWidth/2.0);
        self.photoButton.frame = CGRectMake(posX, CGRectGetMinY(self.scanButton.frame), 60.0, 60.0);
        [self.photoButton setTitleColor:HEXCOLOR(0xAAAAAA) forState:UIControlStateNormal];
        [self.photoButton setTitleColor:HEXCOLOR(0xCCFF00) forState:UIControlStateHighlighted];
        self.photoButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.photoButton setTitle:@"相册" forState:UIControlStateNormal];
        [self.photoButton setTitleEdgeInsets:UIEdgeInsetsMake(30.0, -28.0, 0.0, 0.0)];
        [self.photoButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, 12.0, 20.0, 0.0)];
        [self.photoButton setImage:[UIImage imageNamed:@"QR_album"] forState:UIControlStateNormal];
        [self.photoButton setImage:[UIImage imageNamed:@"QR_album_press"] forState:UIControlStateHighlighted];
        [self.photoButton addTarget:self action:@selector(albumButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.scanView == nil) {
        self.scanView = [[XGQRScanView alloc] initWithFrame:CGRectMake(0.0, 0.0, XGScreenWidth, XGScreenHeight)];
    }
    self.scanView.transparentArea = size;
    self.scanView.backgroundColor = [UIColor clearColor];
    
    [self.maskView addSubview:self.scanView];
    self.scanView.center = self.maskView.center;
    self.scanFrameView.center = self.maskView.center;
    [self.maskView addSubview:self.navBackButton];
    [self.maskView addSubview:self.torchButton];
    [self.maskView addSubview:self.scanFrameView];
    [self.maskView addSubview:self.scanButton];
    [self.maskView addSubview:self.photoButton];
    [self.view addSubview:self.maskView];
}

@end
