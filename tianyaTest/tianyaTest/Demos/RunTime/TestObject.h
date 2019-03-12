//
//  TestObject.h
//  tianyaTest
//
//  Created by baiqiang on 2018/12/24.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestObject : NSObject
@property (nonatomic, copy) NSString *name;
- (void)speak;
- (void)testMethod:(NSString *)text;
@end

@interface OTherObject : NSObject
- (void)testMethod:(NSString *)text;
@end

NS_ASSUME_NONNULL_END

