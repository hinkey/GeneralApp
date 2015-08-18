//
//  ImagePickerView.m
//  UniversalApp
//
//  Created by Cailiang on 14/11/11.
//  Copyright (c) 2014年 Cailiang. All rights reserved.
//

#import "CImagePickerView.h"
#import "Constants.h"
#import "UIButton+UAExtension.h"
#import "UIView+UAExtension.h"
#import "ProgressHUD.h"
#import "CImagePickerController.h"

#define IMAGEPICKER_H 240

@interface CImagePickerView () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIViewController *viewController;
}

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) UIView *mainBGView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, retain) UIButton *takeButton;
@property (nonatomic, retain) UIButton *photoButton;
@property (nonatomic, retain) UIButton *cancelButton;

@end

@implementation CImagePickerView

- (id)init
{
    self = [super init];
    if (self) {
        _title = @"请选择";
        self.mainView.frame = CGRectZero;
    }
    return self;
}

#pragma mark - Properties

- (UIView *)mainBGView
{
    if (_mainBGView) {
        return _mainBGView;
    }
    
    _mainBGView = [[UIView alloc]init];
    _mainBGView.backgroundColor = rgbaColor(0, 0, 0, 0.4);
    
    return _mainBGView;
}

- (UIView *)mainView
{
    if (_mainView) {
        return _mainView;
    }
    
    _mainView = [[UIView alloc]init];
    _mainView.userInteractionEnabled = YES;
    _mainView.backgroundColor = sysWhiteColor();
    _mainView.layer.cornerRadius = 6;
    _mainView.clipsToBounds = YES;
    [self.mainBGView addSubview:_mainView];
    
    // Title
    self.titleLabel.frame = rectMake(10, 5, screenWidth() - 100, 30);
    
    // Line
    UIImageView *topLine = [[UIImageView alloc]init];
    topLine.backgroundColor = sysLightGrayColor();
    topLine.frame = rectMake(0, 36, screenWidth() - 80, 0.3);
    [_mainView addSubview:topLine];
    
    CGFloat height = (IMAGEPICKER_H - 60 - 40)/2 - 10;
    self.takeButton.frame = rectMake((screenWidth() - 280)/3, height, 100, 100);
    self.photoButton.frame = rectMake((screenWidth() - 280)/3*2 + 100, height, 100, 100);
    
    // Line
    UIImageView *botLine = [[UIImageView alloc]init];
    botLine.backgroundColor = sysLightGrayColor();
    botLine.frame = rectMake(0, IMAGEPICKER_H - 46, screenWidth() - 80, 0.3);
    [_mainView addSubview:botLine];
    
    // Cancel
    [self cancelButton];
    
    return _mainView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel) {
        return _titleLabel;
    }
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = systemFont(16);
    titleLabel.textColor = sysBlackColor();
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.title;
    [self.mainView addSubview:titleLabel];
    
    _titleLabel = titleLabel;
    
    return _titleLabel;
}

- (UIButton *)takeButton
{
    if (_takeButton) {
        return _takeButton;
    }
    
    UIButton *takeButton = [UIButton customButton];
    takeButton.tag = 1;
    [takeButton setTitle:@"拍照"];
    [takeButton setTitleFont: systemFont(16)];
    [takeButton setTitleColor:sysBlackColor()];
    [takeButton setTitleColor:sysLightGrayColor() forState:UIControlStateHighlighted];
    [takeButton addTarget:self action:@selector(buttonAction:)];
    takeButton.layer.borderWidth = 0.5;
    takeButton.layer.cornerRadius = 10;
    takeButton.layer.borderColor = sysGrayColor().CGColor;
    [self.mainView addSubview:takeButton];
    
    _takeButton = takeButton;
    
    return _takeButton;
}

- (UIButton *)photoButton
{
    if (_photoButton) {
        return _photoButton;
    }
    
    // 相册
    UIButton *photoButton = [UIButton customButton];
    photoButton.tag = 2;
    [photoButton setTitle:@"相册"];
    [photoButton setTitleFont: systemFont(16)];
    [photoButton setTitleColor:sysBlackColor()];
    [photoButton setTitleColor:sysLightGrayColor() forState:UIControlStateHighlighted];
    [photoButton addTarget:self action:@selector(buttonAction:)];
    photoButton.layer.borderWidth = 0.5;
    photoButton.layer.cornerRadius = 10;
    photoButton.layer.borderColor = sysGrayColor().CGColor;
    [self.mainView addSubview:photoButton];
    
    _photoButton = photoButton;
    
    return _photoButton;
}

- (UIButton *)cancelButton
{
    if (_cancelButton) {
        return _cancelButton;
    }
    
    UIButton *cancelButton = [UIButton customButton];
    cancelButton.frame = rectMake(0, IMAGEPICKER_H - 45, screenWidth() - 80, 45);
    [cancelButton setTitle:@"取消"];
    [cancelButton setTitleFont: systemFont(16)];
    [cancelButton setTitleColor:sysBlackColor()];
    [cancelButton setTitleColor:sysLightGrayColor() forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(hide)];
    [self.mainView addSubview:cancelButton];
    
    _cancelButton = cancelButton;
    
    return _cancelButton;
}

- (void)showInView:(UIView *)view
{
    if ([view isKindOfClass:[UIView class]]) {
        [view addSubview:self.mainBGView];
        viewController = view.viewController;
        
        CGRect frame = rectMake(0, 0, view.frame.size.width, view.frame.size.height);
        self.frame = frame;
        self.mainBGView.frame = frame;
        self.mainView.frame = rectMake(40, self.frame.size.height,frame.size.width - 80, IMAGEPICKER_H);
        
        self.mainView.alpha = 0;
        self.mainBGView.alpha = 0;
        
        __weak CImagePickerView *weakself = self;
        [UIView animateWithDuration:0.25 animations:^{
            weakself.mainBGView.alpha = 1;
            weakself.mainView.alpha = 1;
            weakself.mainView.frame = rectMake(40, (frame.size.height - IMAGEPICKER_H)/2, frame.size.width - 80, IMAGEPICKER_H);
        }];
    }
}

- (void)hide
{
    __weak CImagePickerView *weakself = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakself.mainBGView.alpha = 0;
        weakself.mainView.alpha = 0;
        weakself.mainView.frame = rectMake(40, weakself.frame.size.height, weakself.frame.size.width - 80, IMAGEPICKER_H);
    } completion:^(BOOL finished) {
        if (finished) {
            [weakself.mainBGView removeFromSuperview];
        }
    }];
}

- (void)buttonAction:(UIButton *)button
{
    [self hide];
    
    if (button.tag == 1) {
        // 照相
        [self takePhoto];
        
    } else {
        // 相册
        [self localPhoto];
    }
}

- (void)takePhoto
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showLWithStatus:@"正在准备相机..."];
    });
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([CImagePickerController isSourceTypeAvailable:sourceType]) {
        CImagePickerController *picker = [[CImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [viewController presentViewController:picker animated:YES completion:^{
            [ProgressHUD dismiss];
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showLErrorWithStatus:@"无法打开照相机功能"];
        });
    }
}

- (void)localPhoto
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showLWithStatus:@"正在准备相册..."];
    });
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if ([CImagePickerController isSourceTypeAvailable:sourceType]) {
        CImagePickerController *picker = [[CImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [viewController presentViewController:picker animated:YES completion:^{
            [ProgressHUD dismiss];
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD showLErrorWithStatus:@"无法打开相册"];
        });
    }
}

// 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        self.image = [info objectForKey:UIImagePickerControllerEditedImage];
        self.image = [self scaleImage:self.image toScale:0.3];
        
        if (_delegate && [_delegate respondsToSelector:@selector(imagePickerViewCallback:)]) {
            [_delegate imagePickerViewCallback:self];
        }
        
        CImagePickerView __weak *wealself = self;
        [picker dismissViewControllerAnimated:YES completion:^{
            wealself.image = nil;
        }];
    }
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)theViewController animated:(BOOL)animated
{
    [[[theViewController navigationController]navigationBar]setBarStyle:UIBarStyleDefault];
}

@end
