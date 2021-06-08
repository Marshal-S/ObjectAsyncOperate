//
//  ViewController.m
//  ObjectAsyncOperate
//
//  Created by Marshal on 2021/6/8.
//  测试多线程多次操作对象导致的崩溃问题
    
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *longName;
@property (nonatomic, strong) NSString *smallName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initControl];
}

- (void)initControl {
    UIControl *control = [[UIControl alloc] initWithFrame:self.view.frame];
    [control addTarget:self action:@selector(updateValues) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
}

- (void)updateValues {
    for (NSInteger i = 0; i < 10000; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //多线程给小对象赋值
            //由于taggedpointer的原因，小对象不会导致崩溃
            self.smallName = [NSString stringWithFormat:@"%ld", i % 100];
        });
    }
    for (NSInteger i = 0; i < 10000; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //多线程给大对象赋值，由于属性操作不是安全操作，atomic为原子操作意思，仅仅保证读写的原子性，对于多线程同时操作读写，仍然会由于多次release导致崩溃问题
            self.longName = [NSString stringWithFormat:@"askdfasfsadfasd%ld%ld%ldasdfsdfasdfaskdjfhskd", i, i, i];
        });
    }
}



@end
