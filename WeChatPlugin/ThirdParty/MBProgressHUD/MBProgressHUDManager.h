//
//  MBProgressHUDManager.h
//  MBProgressHUDManager
//
//  Created by YU-HENG WU on 2013/11/23.
//  Copyright (c) 2013年 xjimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

typedef void (^MBProgressHUDManagerCompletionBlock)();

@interface MBProgressHUDManager : NSObject <MBProgressHUDDelegate>

@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, weak) UIView *baseView;
@property (copy) MBProgressHUDCompletionBlock completionBlock;

- (id)initWithView:(UIView *)view;

- (void)showMessage:(NSString *)message;
- (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion;

- (void)showMessage2:(NSString *)message duration:(NSTimeInterval)duration;
- (void)showMessage2:(NSString *)message duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion;

- (void)showIndeterminateWithMessage:(NSString *)message;
- (void)showIndeterminateWithMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)showIndeterminateWithMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion;

- (void)showSuccessWithMessage:(NSString *)message;
- (void)showSuccessWithMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)showSuccessWithMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion;

- (void)showErrorWithMessage:(NSString *)message;
- (void)showErrorWithMessage:(NSString *)message duration:(NSTimeInterval)duration;
- (void)showErrorWithMessage:(NSString *)message duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion;

- (void)showMessage:(NSString *)message customView:(UIView *)customView;
- (void)showMessage:(NSString *)message customView:(UIView *)customView duration:(NSTimeInterval)duration;
- (void)showMessage:(NSString *)message customView:(UIView *)customView duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion;

- (void)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode;
- (void)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode duration:(NSTimeInterval)duration;
- (void)showMessage:(NSString *)message mode:(MBProgressHUDMode)mode duration:(NSTimeInterval)duration complection:(MBProgressHUDCompletionBlock)completion;

- (void)showProgress:(float)progress;

- (void)hide;
- (void)hideWithAfterDuration:(NSTimeInterval)duration completion:(MBProgressHUDCompletionBlock)completion;

@end

