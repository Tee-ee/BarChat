//
//  BCTMacros.h
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#ifndef BCTMacros_h
#define BCTMacros_h

#define kBCTDebugMode   YES

#define kBCTScreenBounds [UIScreen mainScreen].bounds

#define kBCTScreenWidth kBCTScreenBounds.size.width

#define kBCTScreenHeight kBCTScreenBounds.size.height

#define kBCTNorm(x) x * kBCTScreenWidth / 320.f

#define kBCTLog() NSLog(@"%s : %d", __func__, __LINE__)

#define kBCTMainBottomBarHeight kBCTNorm(50.f)

#define kBCTContentInsetTop [BCTVCManager sharedManager].navigationVC.navigationBar.frame.size.height

#define kBCTPath(path)     [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject],path]

#endif /* BCTMacros_h */
