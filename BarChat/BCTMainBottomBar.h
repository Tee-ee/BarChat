//
//  BCTMainBottomBar.h
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BCTMainBottomBarDelegate;

@interface BCTMainBottomBar : UIToolbar

@property (nonatomic, weak) id<BCTMainBottomBarDelegate> BCTDelegate;

@property (nonatomic, weak) NSString*   currentTitle;

@end

@protocol BCTMainBottomBarDelegate <NSObject>

@required

- (void)bottomBar:(BCTMainBottomBar*)bottomBar didSelectSection:(int)index;

@end
