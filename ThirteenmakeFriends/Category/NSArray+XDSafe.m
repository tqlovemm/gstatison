//
//  NSArray+XDSafe.m
//  0919-demo
//
//  Created by Xudongdong on 2017/9/19.
//  Copyright © 2017年 Xudongdong. All rights reserved.
//

#import "NSArray+XDSafe.h"
#import <objc/runtime.h>

/**
 在iOS中NSNumber、NSArray、NSDictionary等这些类都是类簇，一个NSArray的实现可能由多个类组成。
 所以如果想对NSArray进行Swizzling，必须获取到其“真身”进行Swizzling，直接对NSArray进行操作是无效的。
 
 下面列举了NSArray和NSDictionary本类的类名，可以通过Runtime函数取出本类。
 NSArray                __NSArrayI
 NSMutableArray         __NSArrayM
 NSDictionary           __NSDictionaryI
 NSMutableDictionary	__NSDictionaryM
 */

@implementation NSArray (XDSafe)

// Swizzling核心代码
// 需要注意的是，好多同学反馈下面代码不起作用，造成这个问题的原因大多都是其调用了super load方法。在下面的load方法中，不应该调用父类的load方法。
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
        Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(xd_objectAtIndex:));
        method_exchangeImplementations(fromMethod, toMethod);
        
        Method fromMethod1 = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:));
        Method toMethod1 = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(xd_emptyObjectIndex:));
        method_exchangeImplementations(fromMethod1, toMethod1);
        
        Method fromMethod2 = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(objectAtIndex:));
        Method toMethod2 = class_getInstanceMethod(objc_getClass("__NSSingleObjectArrayI"), @selector(xd_singleObjectAtIndex:));
        method_exchangeImplementations(fromMethod2, toMethod2);
        
        //替换可变数组方法
        Method oldMutableObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
        Method newMutableObjectAtIndex =  class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(xd_mutableObjectAtIndex:));
        method_exchangeImplementations(oldMutableObjectAtIndex, newMutableObjectAtIndex);
    });
}

// 为了避免和系统的方法冲突，我一般都会在swizzling方法前面加前缀
- (id)xd_objectAtIndex:(NSUInteger)index {
    // 判断下标是否越界，如果越界就进入异常拦截
    if (self.count-1 < index) {
#ifdef DEBUG  // 调试阶段
        return [self xd_objectAtIndex:index];
#else // 发布阶段
        @try {
            return [self xd_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息。如果是线上，可以在这里将崩溃信息发送到服务器
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
#endif
        
    } // 如果没有问题，则正常进行方法调用
    else {
        return [self xd_objectAtIndex:index];
    }
}

- (id)xd_emptyObjectIndex:(NSInteger)index{
    @try {
        return [self xd_emptyObjectIndex:index];
    }
    @catch (NSException *exception) {
        // 在崩溃后会打印崩溃信息。如果是线上，可以在这里将崩溃信息发送到服务器
        NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
        NSLog(@"%@", [exception callStackSymbols]);
        return nil;
    }
    @finally {}
}

- (id)xd_singleObjectAtIndex:(NSInteger)index{
    // 判断下标是否越界，如果越界就进入异常拦截
    if (self.count-1 < index || !self.count) {
        @try {
            return [self xd_singleObjectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息。如果是线上，可以在这里将崩溃信息发送到服务器
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    } // 如果没有问题，则正常进行方法调用
    else {
        return [self xd_singleObjectAtIndex:index];
    }
}

- (id)xd_mutableObjectAtIndex:(NSUInteger)index
{
    if (index > self.count - 1 || !self.count) {
        @try {
            return [self xd_mutableObjectAtIndex:index];
        }
        @catch (NSException *exception) {
            NSLog(@"exception: %@", exception.reason);
            return nil;
        }
        
    }else {
        return [self xd_mutableObjectAtIndex:index];
    }
}

@end
