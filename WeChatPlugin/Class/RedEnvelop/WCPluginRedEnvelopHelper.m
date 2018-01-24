//
//  WCPluginRedEnvelopHelper.m
//  IPAPatch
//
//  Created by wadahana on 15/08/2017.
//  Copyright © 2017 . All rights reserved.
//

#import "WCPluginRedEnvelopHelper.h"
#import "WCPluginRedEnvelopParamQueue.h"
#import "WCPluginRedEnvelopTaskManager.h"
#import "WCPluginDataHelper.h"
#import "WCPluginUtils.h"
#import "WeChatHeader.h"


@interface WCPluginRedEnvelopHelper()

@property (nonatomic, strong) WCPluginRedEnvelopParamQueue * queue;

@end

static WCPluginRedEnvelopHelper * sInstance = nil;

@implementation WCPluginRedEnvelopHelper

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[WCPluginRedEnvelopHelper alloc] init];
    });
    return sInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.queue = [[WCPluginRedEnvelopParamQueue alloc] init];
    }
    return self;
}

#pragma mark - Inner Function

- (NSDictionary *)parseDictionaryFromString:(NSString *)content {
    Class clazz = NSClassFromString(@"WCBizUtil");
    NSDictionary * dict = [clazz performSelector:@selector(dictionaryWithDecodedComponets:separator:)
                                      withObject:content
                                      withObject:@"&"];
    return dict;
}

- (NSInteger)receiverRedEnvelopDelay {
    NSInteger delay = WCPluginGetRedEnvelopSerial();
    if (WCPluginGetRedEnvelopSerial()) {
        if ([[WCPluginRedEnvelopTaskManager shareInstance] serialQueueIsEmpty]) {
            return delay;
        } else {
            return 8;
        }
    }
    return delay;
}

#pragma mark - RedEnvelop Hooked Function

- (void) onRedEnvelopAsyncMessage: (id)msg wrap:(id)wrap {
//  int messageType = WCPluginIntGetter(wrap, @selector(m_uiMessageType));
    
    MMServiceCenter * serviceCenter = [NSClassFromString(@"MMServiceCenter") defaultCenter];
    id contactMgr = [serviceCenter getService:NSClassFromString(@"CContactMgr")];
    CContact * contactSelf = [contactMgr performSelector:@selector(getSelfContact)];
    NSString * selfName = [contactSelf performSelector:@selector(m_nsUsrName)];
    NSString * toUsrName = [wrap performSelector:@selector(m_nsToUsr)];
    NSString * fromUsrName = [wrap performSelector:@selector(m_nsFromUsr)];
    
    BOOL (^isSender)() = ^BOOL() {
        return [selfName isEqualToString:fromUsrName];
    };
    
    BOOL (^isGroupReceiver)() = ^BOOL() {
        return [fromUsrName rangeOfString:@"@chatroom"].location != NSNotFound;
    };
    
    BOOL (^isGroupSender)() = ^BOOL() {
        return isSender() && [toUsrName rangeOfString:@"chatroom"].location != NSNotFound;
    };
    
    BOOL (^isTheGroupInBackList)() = ^BOOL() {
        return WCPluginIsInBackList(fromUsrName);
    };
    
    BOOL (^shouldReceiveRedEnvelop)() = ^BOOL() {
        if (isTheGroupInBackList()) {
            return NO;
        }
        return isGroupReceiver() || (isGroupSender() && WCPluginGetRedEnvelopOpenSelf());
    };
    
    void (^queryRedEnvelopesReqeust)(NSString * url, NSDictionary * dict) = ^(NSString * url, NSDictionary * dict) {
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        params[@"agreeDuty"] = @"0";
        params[@"channelId"] = [dict objectForKey:@"channelid"];
        params[@"inWay"] = @"0";
        params[@"msgType"] = [dict objectForKey:@"msgtype"];
        params[@"nativeUrl"] = url;
        params[@"sendId"] = [dict objectForKey:@"sendid"];
        
        MMServiceCenter * serviceCenter = [NSClassFromString(@"MMServiceCenter") defaultCenter];
        id logicMgr = [serviceCenter getService:NSClassFromString(@"WCRedEnvelopesLogicMgr")];
        [logicMgr performSelector:@selector(ReceiverQueryRedEnvelopesRequest:) withObject:params];
    };
    
    void (^enqueueParam)(NSString * url, NSDictionary *dict) = ^(NSString * url, NSDictionary *dict) {
        WCPluginRedEnvelopParam *mgrParams = [[WCPluginRedEnvelopParam alloc] init];
        mgrParams.msgType = [dict objectForKey:@"msgtype"];
        mgrParams.sendId = [dict objectForKey:@"sendid"];
        mgrParams.channelId = [dict objectForKey:@"channelid"];
        mgrParams.nickName = [contactSelf performSelector:@selector(getContactDisplayName)];
        mgrParams.headImg = [contactSelf performSelector:@selector(m_nsHeadImgUrl)];
        mgrParams.nativeUrl = url;
        mgrParams.sessionUserName = isGroupSender() ? toUsrName : fromUsrName;
        mgrParams.sign = [dict objectForKey:@"sign"];
        mgrParams.isGroupSender = isGroupSender();
        [self.queue enqueue:mgrParams];
    };
    
    if (shouldReceiveRedEnvelop()) {
        id item = [wrap performSelector:@selector(m_oWCPayInfoItem)];
        NSString *nativeUrl = [item performSelector:@selector(m_c2cNativeUrl)];
        NSString * nativeParams = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
        NSDictionary * nativeUrlDict = [self parseDictionaryFromString:nativeParams];
        queryRedEnvelopesReqeust(nativeUrl, nativeUrlDict);
        
        enqueueParam(nativeUrl, nativeUrlDict);
    }
}

- (void) onRedEnvelopCommonResponse:(id)response request:(id)request {
    NSLog(@"TEST :: onRedEnvelopCommonResponse ->");
    NSString *(^parseRequestSign)() = ^NSString *() {
        id obj = [request performSelector:@selector(reqText)];
        NSData * buffer = [obj performSelector:@selector(buffer)];
        NSString * reqString = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
        NSDictionary * reqDict = [self parseDictionaryFromString:reqString];
        NSString *nativeUrl = [[reqDict objectForKey:@"nativeUrl"] stringByRemovingPercentEncoding];
        NSDictionary *nativeUrlDict = [self parseDictionaryFromString: nativeUrl];
        return [nativeUrlDict objectForKey:@"sign"];
    };

    NSDictionary *(^parseResponseDictionary)() = ^NSDictionary *() {
        NSError * err = nil;
        id obj = [response performSelector:@selector(retText)];
        NSData * buffer = [obj performSelector:@selector(buffer)];
        //NSString * respString = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
        NSDictionary * respDict = [NSJSONSerialization JSONObjectWithData:buffer options:NSJSONReadingMutableContainers error:&err];
        return respDict;
    };
    
    NSDictionary * respDict = parseResponseDictionary();
    
    WCPluginRedEnvelopParam * param = [self.queue dequeue];
    BOOL (^shouldReceiveRedEnvelop)() = ^BOOL() {
        if (!param) { // 手动抢红包
            return NO;
        }
        if ([respDict[@"receiveStatus"] integerValue] == 2) { // 自己已经抢过
            return NO;
        }
        if ([respDict[@"hbStatus"] integerValue] == 4) { // 红包被抢完
            return NO;
        }
        if (!respDict[@"timingIdentifier"]) {
            return NO;
        }
        if (param.isGroupSender) {
            return WCPluginGetRedEnvelopEnabled();  ////?
        } else {
            NSString * reqSign = parseRequestSign();
            return ([reqSign isEqualToString:param.sign] && WCPluginGetRedEnvelopEnabled());
        }
    };
    
    if (shouldReceiveRedEnvelop()) {
        NSInteger delay = [self receiverRedEnvelopDelay];
        param.timingIdentifier = respDict[@"timingIdentifier"];
        WCPluginRedEnvelopOperation * operation = [[WCPluginRedEnvelopOperation alloc] initWithRedEnvelopParam:param delay:delay];
        if (WCPluginGetRedEnvelopSerial()) {
            [[WCPluginRedEnvelopTaskManager shareInstance] addSerialTask:operation];
        } else {
            [[WCPluginRedEnvelopTaskManager shareInstance] addNormalTask:operation];
        }
    }
}


#pragma clang diagnostic pop

@end
