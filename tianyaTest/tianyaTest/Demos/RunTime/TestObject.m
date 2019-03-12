//
//  TestObject.m
//  tianyaTest
//
//  Created by baiqiang on 2018/12/24.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import "TestObject.h"

#import <objc/runtime.h>

OTherObject * objc = nil;

@implementation TestObject
- (void)speak {
    NSLog(@"my name's %@", self.name);
    
}
- (void)testMethod:(NSString *)text {
    NSLog(@"%s: %@",__func__,text);
}

/// 返回YES或者NO都不影响消息转发的结果,在内部会有自行的判断,可在这里动态添加方法

void dynamicMethodIMP(id self, SEL _cmd) {
    // implementation ....
}

/// 类方法走这里
+ (BOOL)resolveClassMethod:(SEL)sel {
    return [self respondsToSelector:sel];
}
/// 实例方法走这里
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    //动态添加方法
    if (![self respondsToSelector:sel]) {
        class_addMethod([self class], sel, (IMP) dynamicMethodIMP, "v@:");
        return YES;
    }
    return [self respondsToSelector:sel];
}

// 提供备源者，用以接收并执行方法
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (![self respondsToSelector:aSelector]) {
        //这里提供一个可执行此aSelector的对象
        return objc;
    } else {
        return self;
    }
}

// 提供好备源者后会调用方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
   return [objc methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    if ([objc respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:objc];
    } else {
        [super forwardInvocation:anInvocation];
        
    }
}

@end


@implementation OTherObject

- (void)testMethod:(NSString *)text {
    NSLog(@"%s: %@",__func__,text);
}

@end
