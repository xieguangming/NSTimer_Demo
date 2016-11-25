# NSTimer_Demo
一 介绍NSTimer的3种正确使用方法
*********************************************************************
1. 在子线程中进行NSTimer操作;
2. 仍然在主线程中进行NSTimer操作, 将NSTimer加到main runloop的特定mode;
3. GCD;

*********************************************************************


思路分析+Demo验证：
1. 首先我们想到的就是,直接使用
[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(addTime_test) userInfo:nil repeats:YES];

测试结果:(1).  每当0.01s进行一次repeat操作时,NSTimer是不准的，严重滞后，
        (2).  改成0.1秒repeat操作，则这种滞后要好一些。

误差原因: 在使用“scheduledTimerWithTimeInterval”方法时，NSTimer实例是被加到当前runloop中的，模式是NSDefaultRunLoopMode。而“当前runloop”就是应用程序的main runloop，此main runloop负责了所有的主线程事件，这其中包括了UI界面的各种事件。当主线程中进行复杂的运算，或者进行UI界面操作时，由于在main runloop中NSTimer是同步交付的被“阻塞”，而模式也有可能会改变。因此，就会导致NSTimer计时出现延误。


解决思路: （1）. 一种是在子线程中进行NSTimer的操作，再在主线程中修改UI界面显示操作结果;
         (2). 另一种是仍然在主线程中进行NSTimer操作，但是将NSTimer实例加到main runloop的特定mode（模式）中。避免被复杂运算操作或者UI界面刷新所干扰;

联系QQ: 260595314 有问题可以加Q  互相学习, 共同进步.








