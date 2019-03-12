//
//  IOSLockVc.m
//  tianyaTest
//
//  Created by baiqiang on 2019/1/24.
//  Copyright © 2019年 baiqiang. All rights reserved.
//

#import "IOSLockVc.h"

#import <pthread.h>
#import <libkern/OSAtomic.h>
#import <QuartzCore/QuartzCore.h>
#import <os/lock.h>

#define Lock_Semaphore(semaphore) dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
#define Unlock_Semaphore(semaphore) dispatch_semaphore_signal(self.lock)

@interface IOSLockVc ()

@property (nonatomic, strong) dispatch_semaphore_t lock;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) void(^blockTest)(IOSLockVc *vc);         ///<  测试
@end

@implementation IOSLockVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    int buttonCount = 5;
    for (int i = 0; i < buttonCount; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 200, 50);
        button.center = CGPointMake(self.view.frame.size.width / 2, i * 60 + 160);
        button.tag = pow(10, i + 3);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"run (%d) count",(int)button.tag] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    self.count = 100;
    self.lock = dispatch_semaphore_create(1);
    
    for (NSInteger i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Lock_Semaphore(self.lock);
            while (self.count > 0) {
                    NSLog(@"taskEnter%ld,   >>>%ld",i,(long)self.count);
                    self.count -= 1;
                    NSLog(@"taskUse%ld, <<<  %ld",i,(long)self.count);
            }
            Unlock_Semaphore(self.lock);
        });
    }
    
}

- (void)tap:(UIButton *)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test:(int)sender.tag];
    });
}
- (void)dealloc {
    NSLog(@"%@ 被释放",self);
}

- (void)test:(int)count {
    NSTimeInterval begin, end;
    NSString * msg = @"时间对比\n";
    NSString * result = @"";
    {
        OSSpinLock lock = OS_SPINLOCK_INIT;
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            OSSpinLockLock(&lock);
            OSSpinLockUnlock(&lock);
        }
        end = CACurrentMediaTime();
        result = [NSString stringWithFormat:@"OSSpinLock:               %8.2f ms\n", (end - begin) * 1000];
        msg = [msg stringByAppendingString:result];
        printf("OSSpinLock:               %8.2f ms\n", (end - begin) * 1000);
    }
    {
        os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            os_unfair_lock_lock(&lock);
            os_unfair_lock_unlock(&lock);
        }
        end = CACurrentMediaTime();
        result = [NSString stringWithFormat:@"os_unfair_lock:           %8.2f ms\n", (end - begin) * 1000];
        msg = [msg stringByAppendingString:result];
        printf("os_unfair_lock:           %8.2f ms\n", (end - begin) * 1000);
    }
    
    {
        dispatch_semaphore_t lock =  dispatch_semaphore_create(1);
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_signal(lock);
        }
        end = CACurrentMediaTime();
        result = [NSString stringWithFormat:@"dispatch_semaphore:       %8.2f ms\n", (end - begin) * 1000];
        msg = [msg stringByAppendingString:result];
        printf("dispatch_semaphore:       %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        pthread_mutex_t lock;
        pthread_mutex_init(&lock, NULL);
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            pthread_mutex_lock(&lock);
            pthread_mutex_unlock(&lock);
        }
        end = CACurrentMediaTime();
        pthread_mutex_destroy(&lock);
        result = [NSString stringWithFormat:@"pthread_mutex:            %8.2f ms\n", (end - begin) * 1000];
        msg = [msg stringByAppendingString:result];
        printf("pthread_mutex:            %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        NSCondition *lock = [NSCondition new];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        result = [NSString stringWithFormat:@"NSCondition:              %8.2f ms\n", (end - begin) * 1000];
        msg = [msg stringByAppendingString:result];
        printf("NSCondition:              %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        NSLock *lock = [NSLock new];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        result = [NSString stringWithFormat:@"NSLock:                   %8.2f ms\n", (end - begin) * 1000];
        msg = [msg stringByAppendingString:result];
        printf("NSLock:                   %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        pthread_mutex_t lock;
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&lock, &attr);
        pthread_mutexattr_destroy(&attr);
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            pthread_mutex_lock(&lock);
            pthread_mutex_unlock(&lock);
        }
        end = CACurrentMediaTime();
        pthread_mutex_destroy(&lock);
        result = [NSString stringWithFormat:@"pthread_mutex(recursive): %8.2f ms\n", (end - begin) * 1000];
        msg = [msg stringByAppendingString:result];
        printf("pthread_mutex(recursive): %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        NSRecursiveLock *lock = [NSRecursiveLock new];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        result = [NSString stringWithFormat:@"\nNSRecursiveLock:          %8.2f ms\n", (end - begin) * 1000];
        msg = [msg stringByAppendingString:result];
        printf("NSRecursiveLock:          %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        NSConditionLock *lock = [[NSConditionLock alloc] initWithCondition:1];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [lock lock];
            [lock unlock];
        }
        end = CACurrentMediaTime();
        result = [NSString stringWithFormat:@"NSConditionLock:          %8.2f ms\n", (end - begin) * 1000];
        msg = [msg stringByAppendingString:result];
        printf("NSConditionLock:          %8.2f ms\n", (end - begin) * 1000);
    }
    
    
    {
        NSObject *lock = [NSObject new];
        begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            @synchronized(lock) {}
        }
        end = CACurrentMediaTime();
        result = [NSString stringWithFormat:@"synchronized:            %8.2f ms", (end - begin) * 1000];
        msg = [msg stringByAppendingString:result];
        printf("@synchronized:            %8.2f ms\n", (end - begin) * 1000);
    }
    printf("---- fin (%d) ----\n\n",count);
    [BQMsgView showInfo:msg completeBlock:nil];
    [BQMsgView showInfo:msg];
}

@end
