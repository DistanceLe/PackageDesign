//
//  HYDataManager.h
//  CoolMesh
//
//  Created by lijie on 2019/3/26.
//  Copyright © 2019 lijie. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kDataManager    [HYDataManager shareManager]


NS_ASSUME_NONNULL_BEGIN

@interface HYDataManager : NSObject

@property(nonatomic, assign)CGFloat safeTop;
@property(nonatomic, assign)CGFloat safeBottom;
@property(nonatomic, assign)CGFloat safeLeft;
@property(nonatomic, assign)CGFloat safeRight;

@property(nonatomic, assign)CGFloat safeWidth;
@property(nonatomic, assign)CGFloat safeHeight;

+(instancetype)shareManager;

-(void)doOnAssembleThread:(void(^)(void))operate;
-(void)doOnBLEThread:(void(^)(void))operate;
/**  在主线程里面 操作 */
-(void)doOnMainThread:(void(^)(void))operate;
/**  在异步线程里执行 */
-(void)doOnAsyncThread:(void(^)(void))operate;




-(UIWindow*)getRootWindws;

@end

NS_ASSUME_NONNULL_END
