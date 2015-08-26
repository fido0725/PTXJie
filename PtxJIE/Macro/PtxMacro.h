//
//  PtxMacro.h
//  PtxJIE
//
//  Created by chenfeng on 15/8/19.
//  Copyright (c) 2015年 fido0725. All rights reserved.
//

#ifndef PtxJIE_PtxMacro_h
#define PtxJIE_PtxMacro_h

#if DEBUG
#define PtxDebugLog(frmt, ...)   {NSLog((frmt), ##__VA_ARGS__);}
#else
#define PtxDebugLog(frmt, ...)
#endif

#endif
