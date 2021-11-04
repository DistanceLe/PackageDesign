//
//  DebugAndRelease.h
//  7dmallStore
//
//  Created by LiJie on 15/12/30.
//  Copyright © 2015年 celink. All rights reserved.
//

#ifndef DebugAndRelease_h
#define DebugAndRelease_h

#ifdef DEBUG



#define DLog( s, ... ) NSLog( @"<%@: (%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#define PLog(format, ...) printf("< %s:(%d) >%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )


#else
//不需要输出的
//#define NSLog(...)
#define DLog( s, ... )
#define PLog(format, ...)


#endif


#endif /* DebugAndRelease_h */
