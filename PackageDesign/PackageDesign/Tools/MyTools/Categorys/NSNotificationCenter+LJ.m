//
//  NSNotificationCenter+LJ.m
//  LJTrack
//
//  Created by LiJie on 16/6/15.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "NSNotificationCenter+LJ.h"
#import <objc/runtime.h>

@interface NSNotificationCenter ()

@property(nonatomic, strong)NSMutableDictionary* handlerDictionary;

@end

@implementation NSNotificationCenter (LJ)

static char notiKey;

-(void)setHandlerDictionary:(NSMutableDictionary *)handlerDictionary
{
    objc_setAssociatedObject(self, &notiKey, handlerDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableDictionary*)handlerDictionary
{
    return  objc_getAssociatedObject(self, &notiKey);
}

-(void)addObserverName:(NSString*)name subName:(NSString*)subName object:(id)obj handler:(StatusBlock)handler
{
    if (!handler) {
        return;
    }
    if (!self.handlerDictionary) {
        self.handlerDictionary=[NSMutableDictionary dictionary];
    }
    NSDictionary* handlerDic = [self.handlerDictionary objectForKey:name];
    if (!handlerDic) {
        handlerDic = @{};
    }
    NSMutableDictionary* handlers = [NSMutableDictionary dictionaryWithDictionary:handlerDic];
    if (!subName) {
        subName = @"anonymity";
    }
    [handlers setObject:handler forKey:subName];
    
    [self.handlerDictionary setObject:handlers forKey:name];
    [self removeObserver:self name:name object:obj];
    [self addObserver:self selector:@selector(receiveObserverNoti:) name:name object:obj];
}

-(void)receiveObserverNoti:(NSNotification*)noti
{
    NSDictionary* handlersDic = [self.handlerDictionary objectForKey:noti.name];
    NSArray* allKeys = handlersDic.allKeys;
    for (NSString* key in allKeys) {
        StatusBlock tempBlock = [handlersDic valueForKey:key];
        if (tempBlock) {
            tempBlock(noti, nil);
        }
    }
}

-(void)removeHandlerObserverWithName:(NSString *)name subName:(NSString*)subName object:(id)obj
{
    if (subName) {
        NSDictionary* handlersDic = [self.handlerDictionary objectForKey:name];
        NSArray* allKeys = handlersDic.allKeys;
        for (NSString* key in allKeys) {
            if ([key isEqualToString:subName]) {
                NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithDictionary:handlersDic];
                [tempDic removeObjectForKey:key];
                
                if (allKeys.count == 1) {
                    [self removeObserver:self name:name object:obj];
                    [self.handlerDictionary removeObjectForKey:name];
                }else{
                    [self.handlerDictionary setObject:tempDic forKey:name];
                }
                return;
            }
        }
    }else{
        [self removeObserver:self name:name object:obj];
        [self.handlerDictionary removeObjectForKey:name];
    }
}

@end





