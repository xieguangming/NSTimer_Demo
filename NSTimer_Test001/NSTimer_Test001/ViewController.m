//
//  ViewController.m
//  NSTimer详解
//
//  Created by 谢光明 on 16/11/25.
//  Copyright © 2016年 xiegm. All rights reserved.
//

/*******************************************************************
 本Demo参考 http://www.cnblogs.com/jgCho/p/4992580.html
 联系QQ: 260595314
*/

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong)NSTimer *nstimer;    //定时器

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(addTime_test) userInfo:nil repeats:YES];
     每当0.01s进行一次repeat操作时,NSTimer是不准的，严重滞后，而改成0.1秒repeat操作，则这种滞后要好一些。
     
     误差原因: 在使用“scheduledTimerWithTimeInterval”方法时，NSTimer实例是被加到当前runloop中的，模式是NSDefaultRunLoopMode。
     而“当前runloop”就是应用程序的main runloop，此main runloop负责了所有的主线程事件，这其中包括了UI界面的各种事件。当主线程中进行复杂的运算，或者进行UI界面操作时，
     由于在main runloop中NSTimer是同步交付的被“阻塞”，而模式也有可能会改变。因此，就会导致NSTimer计时出现延误。
     
     解决思路: 一种是在子线程中进行NSTimer的操作，再在主线程中修改UI界面显示操作结果;
             另一种是仍然在主线程中进行NSTimer操作，但是将NSTimer实例加到main runloop的特定mode（模式）中。避免被复杂运算操作或者UI界面刷新所干扰;
     */
    
    //[self SearchBT];      方法一
    //[self SearchBTs];     //方法一(2)
    
    
    //方法二
    NSThread   *thread = [[NSThread alloc] initWithTarget:self selector:@selector(newThread) object:nil];
    [thread start];
    
    
    /** 方法三
    dispatch_source_t _timers;
        uint64_t interval = 0.01 * NSEC_PER_SEC;
        dispatch_queue_t queue = dispatch_queue_create("my queue", 0);
         _timers = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
         dispatch_source_set_timer(_timers, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
         __weak ViewController *blockSelf = self;
         dispatch_source_set_event_handler(_timers, ^()
                                               {
                                                        NSLog(@"Timer %@", [NSThread currentThread]);
                                                        [blockSelf addTime];
                                                     });
        dispatch_resume(_timers);
   // 然后在主线程中修改UI界面：
    
     dispatch_async(dispatch_get_main_queue(), ^{
               //  self.label.text = [NSString stringWithFormat:@"%.2f", self.timeCount/100];
         NSLog(@"主线程刷新UI");
             });
     */
    
}

//方法二: 在子线程中将NSTimer以默认方式加到该线程的runloop中, 启动子线程
-(void)newThread{
    @autoreleasepool {
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    }
}

//方法一:将NSTimer加到main runloop的特定mode
-(void)SearchBT{
    if (!_nstimer) {
        _nstimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_nstimer forMode:NSDefaultRunLoopMode];
    }
    if (_nstimer && !_nstimer.valid) {
        [_nstimer fire];
    }
}

//方法一形式2:将NSTimer加到main runloop的特定mode
-(void)SearchBTs{
    if (self.nstimer) {
        [self.nstimer invalidate];
        self.nstimer = nil;
    }
    
    self.nstimer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.nstimer forMode:NSRunLoopCommonModes];

}

-(void)addTime{
    NSLog(@"hello");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
