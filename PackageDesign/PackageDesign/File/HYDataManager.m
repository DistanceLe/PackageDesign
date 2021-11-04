//
//  HYDataManager.m
//  CoolMesh
//
//  Created by lijie on 2019/3/26.
//  Copyright © 2019 lijie. All rights reserved.
//

#import "HYDataManager.h"

#import "AppDelegate.h"


@interface HYDataManager()


@property (strong, nonatomic) dispatch_queue_t assembleQueue;
@property (strong, nonatomic) dispatch_queue_t BLEQueue;


@end


@implementation HYDataManager


+(instancetype)shareManager{
    static HYDataManager* shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[HYDataManager alloc]init];
        shareManager.BLEQueue = dispatch_queue_create("com.lijie.BLE", DISPATCH_QUEUE_SERIAL);
        shareManager.assembleQueue = dispatch_queue_create("com.lijie.assemble", DISPATCH_QUEUE_SERIAL);
    });
    return shareManager;
}

-(CGFloat)safeTop{
    if (@available(iOS 11.0, *)) {
        _safeTop = [kDataManager getRootWindws].safeAreaInsets.top;
        return _safeTop;
    } else {
        _safeTop = 20;
        return _safeTop;
    }
}
-(CGFloat)safeBottom{
    if (@available(iOS 11.0, *)) {
        _safeBottom = [kDataManager getRootWindws].safeAreaInsets.bottom;
        return _safeBottom;
    } else {
        _safeBottom = 0;
        return _safeBottom;
    }
}
-(CGFloat)safeLeft{
    if (@available(iOS 11.0, *)) {
        _safeLeft = [kDataManager getRootWindws].safeAreaInsets.left;
        return _safeLeft;
    } else {
        _safeLeft = 0;
        return _safeLeft;
    }
}
-(CGFloat)safeRight{
    if (@available(iOS 11.0, *)) {
        _safeRight = [kDataManager getRootWindws].safeAreaInsets.right;
        return _safeRight;
    } else {
        _safeRight = 0;
        return _safeRight;
    }
}
-(CGFloat)safeWidth{
    return IPHONE_WIDTH - kDataManager.safeLeft-kDataManager.safeRight;
}
-(CGFloat)safeHeight{
    return IPHONE_HEIGHT - kDataManager.safeTop-kDataManager.safeBottom;
}


-(void)doOnBLEThread:(void(^)(void))operate{
    
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(self.BLEQueue)) == 0) {
        operate();
    } else {
        dispatch_async(self.BLEQueue, operate);
    }
}
-(void)doOnAssembleThread:(void(^)(void))operate{
    
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(self.assembleQueue)) == 0) {
        operate();
    } else {
        dispatch_async(self.assembleQueue, operate);
    }
}
/**  在主线程里面 操作 */
-(void)doOnMainThread:(void(^)(void))operate{
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        operate();
    } else {
        dispatch_async(dispatch_get_main_queue(), operate);
    }
}
/**  在异步线程里执行 */
-(void)doOnAsyncThread:(void(^)(void))operate{
    dispatch_async(dispatch_get_global_queue(0, 0), operate);
}




-(UIWindow*)getRootWindws{
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return delegate.window;
}

@end














