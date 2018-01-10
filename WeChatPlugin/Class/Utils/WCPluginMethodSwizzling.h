//
//  WCPluginMethodSwizzling.h
//  WeChatHelper
//
//  Created by wadahana on 08/06/2017.
//  Copyright © 2017 . All rights reserved.
//



#ifndef WCPluginMethodSwizzling_h
#define WCPluginMethodSwizzling_h

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

void WCPluginExchangeMethod(Class aClass, SEL oldSEL, SEL newSEL);

void WCPluginExchangeMethodClass(Class aClass, SEL oldSEL, SEL newSEL);


BOOL WCPluginReplaceClassMethod(NSString * className, NSString * selectorName, IMP metodImplement, NSString * methodSignature);

BOOL WCPluginReplaceInstanceMethod(NSString * className, NSString * selectorName, IMP metodImplement, NSString * methodSignature);


inline static NSInvocation * WCPluginNewInvocation(id obj, SEL selector) {
    Class clazz = object_getClass(obj);
    NSMethodSignature * signature = [clazz instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = obj;
    invocation.selector = selector;
    return invocation;
}

inline static int WCPluginIntGetter(id obj, SEL selector) {
    int result;
    Class clazz = object_getClass(obj);
    NSMethodSignature * signature = [clazz instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = obj;
    invocation.selector = selector;
    [invocation invoke];
    [invocation getReturnValue:&result];
    return result;
}

inline static NSInteger WCPluginIntegerGetter(id obj, SEL selector) {
    NSInteger result;
    Class clazz = object_getClass(obj);
    NSMethodSignature * signature = [clazz instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = obj;
    invocation.selector = selector;
    [invocation invoke];
    [invocation getReturnValue:&result];
    return result;
}

inline static long long WCPluginLongLongGetter(id obj, SEL selector) {
    long long result;
    Class clazz = object_getClass(obj);
    NSMethodSignature * signature = [clazz instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = obj;
    invocation.selector = selector;
    [invocation invoke];
    [invocation getReturnValue:&result];
    return result;
}

inline static BOOL WCPluginBoolGetter(id obj, SEL selector) {
    BOOL result;
    Class clazz = object_getClass(obj);
    NSMethodSignature * signature = [clazz instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = obj;
    invocation.selector = selector;
    [invocation invoke];
    [invocation getReturnValue:&result];
    return result;
}

inline static void WCPluginIntSetter(id obj, SEL selector, int value) {
    Class clazz = object_getClass(obj);
    NSMethodSignature * signature = [clazz instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = obj;
    invocation.selector = selector;
    [invocation setArgument:&value atIndex:2];
    [invocation invoke];
    return;
}

inline static void WCPluginIntegerSetter(id obj, SEL selector, NSInteger value) {
    
    Class clazz = object_getClass(obj);
    NSMethodSignature * signature = [clazz instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = obj;
    invocation.selector = selector;
    [invocation setArgument:&value atIndex:2];
    [invocation invoke];
    return;
}

inline static void WCPluginLongLongSetter(id obj, SEL selector, long long value) {
    Class clazz = object_getClass(obj);
    NSMethodSignature * signature = [clazz instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = obj;
    invocation.selector = selector;
    [invocation setArgument:&value atIndex:2];
    [invocation invoke];
    return;
}

inline static void WCPluginBoolSetter(id obj, SEL selector, BOOL value) {
    Class clazz = object_getClass(obj);
    NSMethodSignature * signature = [clazz instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = obj;
    invocation.selector = selector;
    [invocation setArgument:&value atIndex:2];
    [invocation invoke];
    return;
}

#endif /* WCPluginMethodSwizzling_h */
