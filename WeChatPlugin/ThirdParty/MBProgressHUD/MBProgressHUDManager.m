//
//  MBProgressHUDManager.m
//  MBProgressHUDManager
//
//  Created by YU-HENG WU on 2013/11/23.
//  Copyright (c) 2013年 xjimi. All rights reserved.
//

#import "MBProgressHUDManager.h"
#import "MBProgressHUD+WSPXMBProgressHUDUtil.h"
@implementation MBProgressHUDManager

@synthesize HUD;
@synthesize baseView;

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (self)
    {
        self.baseView = view;
    }
    return self;
}

- (void)createHUD
{
    if (!self.HUD)
    {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.baseView];
        self.HUD.mode = MBProgressHUDModeText;
        self.HUD.delegate = self;
        [self.baseView addSubview:self.HUD];
    }
}

//Show Text

- (void)showMessage:(NSString *)message
{
    [self showMessage:message duration:-1];
}

- (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration
{
    [self showMessage:message duration:duration complection:nil];
}

- (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(void (^)())completion
{
    [self showMessage:message mode:MBProgressHUDModeText duration:duration complection:completion];
}

//Show UIActivityIndicatorView

- (void)showIndeterminateWithMessage:(NSString *)message
{
    [self showIndeterminateWithMessage:message duration:-1];
}

- (void)showIndeterminateWithMessage:(NSString *)message duration:(NSTimeInterval)duration
{
    [self showIndeterminateWithMessage:message duration:duration complection:nil];
}

- (void)showIndeterminateWithMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(void (^)())completion
{
    [self showMessage:message mode:MBProgressHUDModeIndeterminate duration:duration complection:completion];
}

//Show Success

- (void)showSuccessWithMessage:(NSString *)message
{
    [self showSuccessWithMessage:message duration:1];
}

- (void)showSuccessWithMessage:(NSString *)message duration:(NSTimeInterval)duration
{
    [self showSuccessWithMessage:message duration:duration complection:nil];
}

- (void)showSuccessWithMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(void (^)())completion
{
    UIImageView *customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    [self showMessage:message customView:customView duration:duration complection:completion];
}

//Show Error

- (void)showErrorWithMessage:(NSString *)message
{
    [self showErrorWithMessage:message duration:1];
}

- (void)showErrorWithMessage:(NSString *)message duration:(NSTimeInterval)duration
{
    [self showErrorWithMessage:message duration:duration complection:nil];
}

- (void)showErrorWithMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(void (^)())completion
{
    UIImageView *customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Error.png"]];
    [self showMessage:message customView:customView duration:duration complection:completion];
}

//Show CustomView

- (void)showMessage:(NSString *)message customView:(UIView *)customView
{
    [self showMessage:message customView:customView duration:-1 complection:nil];
}

- (void)showMessage:(NSString *)message customView:(UIView *)customView duration:(NSTimeInterval)duration
{
    [self showMessage:message customView:customView duration:duration complection:nil];
}

- (void)showMessage:(NSString *)message customView:(UIView *)customView duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion
{
    [self createHUD];
    self.HUD.customView = customView;
    [self showMessage:message mode:MBProgressHUDModeCustomView duration:duration complection:completion];
}

- (void)showMessage2:(NSString *)message duration:(NSTimeInterval)duration {
    [self showMessage2:message duration:duration complection:nil];
}

- (void)showMessage2:(NSString *)message duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion {
  [self createHUD];
  CGSize s = self.HUD.frame.size;
  UILabel* customView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,s.width,s.height)];
  customView.text = message;
  customView.lineBreakMode = NSLineBreakByWordWrapping;
  customView.numberOfLines = 0;
  customView.textColor = [UIColor whiteColor];
  [customView sizeToFit];
  self.HUD.customView = customView;
  [self showMessage:nil mode:MBProgressHUDModeCustomView duration:duration complection:completion];
}

//Show mode

- (void)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode
{
    [self showMessage:message mode:mode duration:-1 complection:nil];
}

- (void)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode duration:(NSTimeInterval)duration
{
    [self showMessage:message mode:mode duration:duration complection:nil];
}

- (void)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode duration:(NSTimeInterval)duration complection:(void (^)())completion
{
    [self createHUD];
    self.HUD.mode = mode;
    self.HUD.labelText = message;
    [self.HUD show:YES];
    if (completion)
    {
        [self hideWithAfterDuration:duration completion:completion];
    }
    else
    {
        self.completionBlock = NULL;
        if (duration >= 0) [self.HUD hide:YES afterDelay:duration];
    }
}

//Show Progress

- (void)showProgress:(float)progress
{
    if (self.HUD) self.HUD.progress = progress;
}

//hide

- (void)hide
{
    if (self.HUD) [self.HUD hide:YES];
}

- (void)hideWithAfterDuration:(NSTimeInterval)duration completion:(MBProgressHUDCompletionBlock)completion
{
    self.completionBlock = completion;
    if (!self.HUD)
    {
        if (self.completionBlock) {
            self.completionBlock();
            self.completionBlock = NULL;
        }
        return;
    }
    
    [self.HUD showAnimated:YES whileExecutingBlock:^{
        
        sleep(duration);
        
    } completionBlock:^{
        
    }];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    self.HUD.delegate = nil;
	[self.HUD removeFromSuperview];
	self.HUD = nil;
    
    if (self.completionBlock) {
        self.completionBlock();
    }
}

@end
