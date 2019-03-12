//
//  RunTimeTestVc.m
//  tianyaTest
//
//  Created by baiqiang on 2018/12/24.
//  Copyright © 2018年 baiqiang. All rights reserved.
//

#import "RunTimeTestVc.h"

#import "TestObject.h"
#import "UITableView+Custom.h"
#import "TouchView.h"

#import <objc/runtime.h>

@interface RunTimeTestVc()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSArray<NSString *> * sourceArr;
@end


@implementation RunTimeTestVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id cls = [TestObject class];
    void * obj = &cls;
    [(__bridge id)obj speak];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.sourceArr = @[@"impForBlock",
                       @"addIvarBeforeRegister",
                       @"categoryAssociate"];
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView registerCell:[UITableViewCell class] isNib:NO];
    [self.view addSubview:tableView];
    
    TouchView * subView = [[TouchView alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    subView.backgroundColor = [UIColor cyanColor];
    tableView.tableFooterView = subView;
    
}

- (void)foo {
    NSLog(@"IMP: -[NSObject (Sark) foo]");
}

typedef struct  cus_objc_class {
    void *isa;
} * CusClass;

- (void)testMethod {
    
    BOOL res1 = [(id)[NSObject class] isKindOfClass:[NSObject class]];
    BOOL res2 = [(id)[NSObject class] isMemberOfClass:[NSObject class]];
    
    void *x = (__bridge void *) [TestObject class];
    
    CusClass y = (CusClass) x;
    BOOL res3 = [(id)[TestObject class] isKindOfClass:((__bridge Class)(y->isa))];
    
    BOOL res4 = [(id)[TestObject class] isMemberOfClass:((__bridge Class)(y->isa))];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"主视图触摸");
}
#pragma mark - struct about of runtime

/*
 
 ========== Method ===========
 typedef struct method_t *Method;
 struct method_t {
    SEL name;
    const char *types;
    IMP imp;
 }
 
 ========== Property ===========
 typedef struct property_t *objc_propety_t;
 struct propety_t {
    const char *name;
    const char *attributes;
 }
 
 ========== objc_object ===========
 struct objc_object {
 private:
    isa_t isa;
 }
 
 ========== objc_class ===========
 struct objc_class : objc_object {
    // Class ISA;
    Class superclass;
    cache_t cache; c
    lass_data_bits_t bits;
 
    class_rw_t *data() {
        return bits.data();
    }
    void setData(class_rw_t *newData) {
        bits.setData(newData);
    }
    // .....
 }
 
 ========== class_rw_t ===========
 struct class_rw_t {
 
    uint32_t flags; uint32_t version;
 
    const class_ro_t *ro;
 
    method_array_t methods;
    property_array_t properties;
    protocol_array_t protocols;
 
    Class firstSubclass; Class nextSiblingClass;
 
    char *demangledName;
 
 };
 
 ========== protocol_t ===========
 struct protocol_t : objc_object {
    const char *mangledName;
    struct protocol_list_t *protocols;
    method_list_t *instanceMethods;
    method_list_t *classMethods;
    method_list_t *optionalInstanceMethods;
    method_list_t *optionalClassMethods;
    property_list_t *instanceProperties;
    uint32_t size; // sizeof(protocol_t)
    uint32_t flags;
    // Fields below this point are not always present on disk.
    const char **_extendedMethodTypes;
    const char *_demangledName;
    property_list_t *_classProperties;
 
 };
 
*/


#pragma mark - runtime test method

- (void)impForBlock {
    IMP function = imp_implementationWithBlock(^(id self, NSString * text){
        NSLog(@"this is block: %@", text);
    });
    const char * types = sel_getName(@selector(testMethod:));
    class_replaceMethod([TestObject class], @selector(testMethod:), function, types);
    
    TestObject * objc = [[TestObject alloc] init];
    [objc testMethod:@"OC"];
}

- (void)addIvarBeforeRegister {
    NSLog(@"%s",__func__);
    //如类存在或继承不合适会返回nil
    
    Class testClass = objc_allocateClassPair([NSObject class], "AccountObject", 0);
    
    if (!testClass) { return;}
    
    //添加实例变量必须在register之前，因为此时空间大小还没确定
    BOOL isAdded = class_addIvar(testClass, "userName", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString*));
    objc_registerClassPair(testClass);
    
    if (isAdded) {
        id object = [[testClass alloc] init];
        [object setValue:@"我是谁" forKey:@"userName"];
        NSLog(@"%@",[object valueForKey:@"userName"]);
    }
    
}

- (void)categoryAssociate {
    NSObject * objc = [[NSObject alloc] init];
    char * key;
    NSString * value = @"12";
    objc_setAssociatedObject(objc, &key, value, OBJC_ASSOCIATION_COPY);
    
    id getValue = objc_getAssociatedObject(objc, &key);
    NSLog(@"%@",getValue);
}

- (void)messageForward {
    NSLog(@"请查看TestObject.m文件");
}

- (void)methodSwizzling {
    // 核心方法method_exchangeImplementations(fromMethod, toMethod)
    // 本质为将两个method中的imp指向做交换
    NSLog(@"请参考NSObjec+Custom.m中exchangeMethod:(SEL)target with:(SEL)repalce方法");
}

- (void)attributeOrderExample {
    /*
     __attribute__((value))
     类修饰符 代表类为最终类无法被继承
     objc_subclassing_restricted
     
     子类必须调用父类方法
     objc_requires_super
     
     将Class或protocol另指定名字，不受命名规范制约
     objc_runtime_name
     
     消除未使用变量时的警告(unused)
     NSObject *object __attribute__((unused)) = [[NSObject alloc] init];
     
     main函数之前(constructor)调用和之后(destructor)调用,可以使用constructor(Int)来指定优先级
     {
     __attribute__((constructor)) static void beforeMain() { NSLog(@"before main"); }
     
     __attribute__((destructor)) static void afterMain() { NSLog(@"after main"); }
     
     int main(int argc, const char * argv[]) { @autoreleasepool { NSLog(@"execute main"); } return 0; }
     }
     执行结果:
     debug-objc[23391:1143291] before main
     debug-objc[23391:1143291] execute main
     debug-objc[23391:1143291] after main
     */
}
#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView loadCell:[UITableViewCell class] indexPath:indexPath];
    cell.textLabel.text = self.sourceArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSelector:NSSelectorFromString(self.sourceArr[indexPath.row])];
}

@end
