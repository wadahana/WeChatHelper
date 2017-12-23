//
//  UIView+WCPlugin.m
//  UOne
//
//  Created by WangXi on 6/15/15.
//  Copyright (c) 2015. All rights reserved.
//

#import "UIView+WCPlugin.h"

@implementation UIView (WCPlugin)

- (CGFloat)x
{
  return self.frame.origin.x;
}

- (CGFloat)y
{
  return self.frame.origin.y;
}

- (CGFloat)width
{
  return self.frame.size.width;
}

- (CGFloat)height
{
  return self.frame.size.height;
}

#pragma mark - View Move

- (void)moveToX:(CGFloat)x
{
  CGRect frame = self.frame;
  frame.origin.x = x;
  self.frame = frame;
}

- (void)moveToY:(CGFloat)y
{
  CGRect frame = self.frame;
  frame.origin.y = y;
  self.frame = frame;
}

- (void)moveToX:(CGFloat)x y:(CGFloat)y
{
  CGRect frame = self.frame;
  frame.origin.x = x;
  frame.origin.y = y;
  self.frame = frame;
}

#pragma mark

- (void)moveByOffsetX:(CGFloat)offsetX
{
  CGRect frame = self.frame;
  frame.origin.x += offsetX;
  self.frame = frame;
}

- (void)moveByOffsetY:(CGFloat)offsetY
{
  CGRect frame = self.frame;
  frame.origin.y += offsetY;
  self.frame = frame;
}

- (void)moveByOffsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY
{
  CGRect frame = self.frame;
  frame.origin.x += offsetX;
  frame.origin.y += offsetY;
  self.frame = frame;
}

#pragma mark - View Resize

- (void)resizeToWidth:(CGFloat)width
{
  CGRect frame = self.frame;
  frame.size.width = width;
  self.frame = frame;
}

- (void)resizeToHeight:(CGFloat)height
{
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}

- (void)resizeToWidth:(CGFloat)width height:(CGFloat)height
{
  CGRect frame = self.frame;
  frame.size.width = width;
  frame.size.height = height;
  self.frame = frame;
}

#pragma mark

- (void)resizeByOffsetWidth:(CGFloat)offsetWidth
{
  CGRect frame = self.frame;
  frame.size.width += offsetWidth;
  self.frame = frame;
}

- (void)resizeByOffsetHeight:(CGFloat)offsetHeight
{
  CGRect frame = self.frame;
  frame.size.height += offsetHeight;
  self.frame = frame;
}

- (void)resizeByOffsetWidth:(CGFloat)offsetWidth offsetHeight:(CGFloat)offsetHeight
{
  CGRect frame = self.frame;
  frame.size.width += offsetWidth;
  frame.size.height += offsetHeight;
  self.frame = frame;
}

#pragma mark

- (void)setCornerRadius:(CGFloat)cornerRadius
{
  self.layer.cornerRadius = cornerRadius;
  self.layer.masksToBounds = YES;
}

- (void)setBorderWithWidth:(CGFloat)width withColor:(UIColor *)color
{
  self.layer.borderWidth = width;
  self.layer.borderColor = color.CGColor;
  self.layer.masksToBounds = YES;
}

- (void)setBorderWithColor:(UIColor*)color {
  self.layer.borderColor = color.CGColor;
}

- (UIImage *)snapshot
{
  UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
  [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

@end
