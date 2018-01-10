//
//  WCPluginContactSelectViewController.h
//  WeChatPlugin
//
//  Created by wadahana on 08/01/2018.
//  Copyright © 2018 wadahana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WeChatHeader.h>

@protocol WCPluginContactSelectViewControllerDelegate  <NSObject>

@required
- (void) onSelectCancel;
- (void) onSelectDone:(NSArray<NSString *>*)userLsit;

@optional
- (void) onSelectContact: (CContact *)contact;
- (BOOL) onShouldSelectContact: (CContact *)contact selectedList:(NSDictionary *)list;
@end

typedef enum  {
    kContactSelectTypeGroup = 1,
    kContactSelectTypeFriend = 2,
} ContactSelectType;

@interface WCPluginContactSelectViewController : UIViewController

@property (weak, nonatomic) id<WCPluginContactSelectViewControllerDelegate> delegate;

- (instancetype) initWithType:(ContactSelectType)type userList:(NSArray<NSString *> *)userList;

@end
