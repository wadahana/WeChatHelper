//
//  MBProgressHUD+WSPXMBProgressHUDUtil.m
//  UOne
//
//  Created by MrChens on 16/5/11.
//  Copyright © 2016年 chinanetcenter. All rights reserved.
//

#import "MBProgressHUD+WSPXMBProgressHUDUtil.h"

@implementation MBProgressHUD (WSPXMBProgressHUDUtil)
#ifdef kMBProgressHUDNODimBackgroundMode
-(void)setDimBackground:(BOOL)dimBackground {
  dimBackground = NO;
}
#endif
@end
