//
//  WCPluginMethodSwizzling.m
//  WeChatHelper
//
//  Created by wadahana on 04/05/2017.
//  Copyright © 2017 . All rights reserved.
//

#import <objc/objc.h>
#import <objc/runtime.h>

#import <Foundation/Foundation.h>

static NSMutableDictionary *sPropKeys;

static NSString *__trim(NSString *string);

static const char * __getMethodTypeEncoding(NSString * className, NSString * selectorName);

static void __overrideMethod(Class cls, NSString *selectorName, IMP implement, BOOL isClassMethod, const char *typeDescription);


void WCPluginExchangeInstanceMethod(Class aClass, SEL oldSEL, SEL newSEL) {
    Method oldMethod = class_getInstanceMethod(aClass, oldSEL);
    assert(oldMethod);
    Method newMethod = class_getInstanceMethod(aClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
}

void WCPluginExchangeClassMethod(Class aClass, SEL oldSEL, SEL newSEL) {
    Method oldMethod = class_getClassMethod(aClass, oldSEL);
    assert(oldMethod);
    Method newMethod = class_getClassMethod(aClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
}


BOOL WCPluginReplaceClassMethod(NSString * className, NSString * selectorName, IMP metodImplement, NSString * methodSignature) {
    NSString * superClassName;
    
    if (!superClassName) {
        superClassName = @"NSObject";
    }
    className = __trim(className);
    superClassName = __trim(superClassName);
    
    Class cls = NSClassFromString(className);
    if (!cls) {
        Class superCls = NSClassFromString(superClassName);
        if (!superCls) {
            NSLog(@"can't find the super class %@", superClassName);
            return NO;
        }
        cls = objc_allocateClassPair(superCls, className.UTF8String, 0);
        objc_registerClassPair(cls);
    }
    Class metaClazz = objc_getMetaClass([className UTF8String]);
    if (class_respondsToSelector(metaClazz, NSSelectorFromString(selectorName))) {
        __overrideMethod(metaClazz, selectorName, metodImplement, YES, nil);
    } else {
        const char * encoding = NULL;
        if (!methodSignature) {
            encoding = __getMethodTypeEncoding(className, selectorName);
        } else {
            encoding = [methodSignature UTF8String];
        }
        if (!encoding) {
            return NO;
        }
        __overrideMethod(metaClazz, selectorName, metodImplement, YES, encoding);
    }
    return YES;
}

BOOL WCPluginReplaceInstanceMethod(NSString * className, NSString * selectorName, IMP metodImplement, NSString * methodSignature) {
    
    NSString * superClassName;
    
    if (!superClassName) {
        superClassName = @"NSObject";
    }
    className = __trim(className);
    superClassName = __trim(superClassName);
    
    Class cls = NSClassFromString(className);
    if (!cls) {
        Class superCls = NSClassFromString(superClassName);
        if (!superCls) {
            NSLog(@"can't find the super class %@", superClassName);
            return NO;
        }
        cls = objc_allocateClassPair(superCls, className.UTF8String, 0);
        objc_registerClassPair(cls);
    }
    
    if (class_respondsToSelector(cls, NSSelectorFromString(selectorName))) {
        __overrideMethod(cls, selectorName, metodImplement, NO, nil);
    } else {
        const char * encoding = NULL;
        if (!methodSignature) {
            encoding = __getMethodTypeEncoding(className, selectorName);
        } else {
            encoding = [methodSignature UTF8String];
        }
        if (!encoding) {
            return NO;
        }
        __overrideMethod(cls, selectorName, metodImplement, NO, encoding);
    }
    return YES;
}

static NSString *__trim(NSString *string) {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


static void __overrideMethod(Class cls, NSString *selectorName, IMP implement, BOOL isClassMethod, const char *typeDescription)
{
    SEL selector = NSSelectorFromString(selectorName);
    
    if (!typeDescription) {
        Method method = class_getInstanceMethod(cls, selector);
        typeDescription = (char *)method_getTypeEncoding(method);
    }
    
    IMP originalImp = class_respondsToSelector(cls, selector) ? class_getMethodImplementation(cls, selector) : NULL;
    
    if (class_respondsToSelector(cls, selector)) {
        NSString *originalSelectorName = [NSString stringWithFormat:@"ORIG%@", selectorName];
        SEL originalSelector = NSSelectorFromString(originalSelectorName);
        if(!class_respondsToSelector(cls, originalSelector)) {
            class_addMethod(cls, originalSelector, originalImp, typeDescription);
        }
        class_replaceMethod(cls, selector, implement, typeDescription);
    } else {
        BOOL result = class_addMethod(cls, selector, implement, typeDescription);
        NSLog(@"result : %d", result);
    }
    // Replace the original selector at last, preventing threading issus when
    // the selector get called during the execution of `overrideMethod`
    
    return;
}

static const char * __getMethodTypeEncoding(NSString * className, NSString * selectorName) {
    
    Class clazz = NSClassFromString(className);
    SEL selector = NSSelectorFromString(selectorName);
    Method method = class_getInstanceMethod(clazz, selector);
    char * encoding = (char *)method_getTypeEncoding(method);
    return encoding;
}

