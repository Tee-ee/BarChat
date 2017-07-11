//
//  BCTUserIcon.m
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTUserIcon.h"

@implementation BCTUserIcon
{
    CALayer*    _mask;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImage* userIcon = [UIImage imageNamed:@"BCT_User_Icon_Demo"];
        self.image = userIcon;
        
        _mask = [CALayer layer];
        _mask.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"user_icon_mask"] CGImage]);
        _mask.frame = self.bounds;
        self.layer.mask = _mask;
    }
    return self;
}

- (void)setUserPhoneNumber:(NSString *)userPhoneNumber {
    _userPhoneNumber = userPhoneNumber;
}

@end
