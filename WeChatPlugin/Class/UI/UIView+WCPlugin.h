//
//  UIView+WCPlugin.h
//  UOne
//
//  Created by WangXi on 6/15/15.
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WCPlugin)

@property (nonatomic, readonly) CGFloat x;
@property (nonatomic, readonly) CGFloat y;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

- (void)moveToX:(CGFloat)x;
- (void)moveToY:(CGFloat)y;
- (void)moveToX:(CGFloat)x y:(CGFloat)y;

- (void)moveByOffsetX:(CGFloat)offsetX;
- (void)moveByOffsetY:(CGFloat)offsetY;
- (void)moveByOffsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY;

- (void)resizeToWidth:(CGFloat)width;
- (void)resizeToHeight:(CGFloat)height;
- (void)resizeToWidth:(CGFloat)width height:(CGFloat)height;

- (void)resizeByOffsetWidth:(CGFloat)offsetWidth;
- (void)resizeByOffsetHeight:(CGFloat)offsetHeight;
- (void)resizeByOffsetWidth:(CGFloat)offsetWidth offsetHeight:(CGFloat)offsetHeight;

//for layer
- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setBorderWithWidth:(CGFloat)width withColor:(UIColor *)color;

- (UIImage *)snapshot;

@end
