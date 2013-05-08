//
//  Common.h
//  Test2
//
//  Created by Chen WeiTing on 13/4/29.
//  Copyright (c) 2013年 Chen WeiTing. All rights reserved.
//

#ifndef Test2_Common_h
#define Test2_Common_h


//#define DEBUG_MODE

#ifdef DEBUG_MODE
#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DebugLog( s, ... )
#endif


#define RadiansToDegrees(radians)(radians * 180.0/M_PI)
#define DegreesToRadians(degrees)(degrees * M_PI / 180.0)

#define DEBUG_HHMM TRUE
#define DEBUG_HH 23
#define DEBUG_MM 35
#define DISPLAY_RANGE 10

#endif
