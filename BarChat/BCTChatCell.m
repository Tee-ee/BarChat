//
//  BCTChatCell.m
//  BarChat
//
//  Created by Vince on 7/11/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTChatCell.h"
#import "BCTMessage.h"
#import "BCTUserIcon.h"
#import "BCTMacros.h"
#import "BCTVCManager.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface BCTChatCell()

@property (nonatomic, strong) BCTUserIcon*  userIcon;

@property (nonatomic, strong) UIButton*     messageBubble;

@property (nonatomic, strong) UIView*       canvas;

@end

@implementation BCTChatCell
{
    CGFloat     _originalCenterX;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _canvas = [[UIView alloc] initWithFrame:self.frame];
        [self addSubview:_canvas];
        
        [_canvas mas_makeConstraints:^(MASConstraintMaker* make){
            make.left.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(self);
            make.width.equalTo(self);
        }];
        
        _messageBubble = [[UIButton alloc] init];
        _messageBubble.titleLabel.numberOfLines = 0;
        _messageBubble.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageBubble.titleLabel.font = [UIFont fontWithName:@".SFUIText" size:kBCTNorm(12.5f)];
        [_canvas addSubview:_messageBubble];
        
        [_messageBubble mas_makeConstraints:^(MASConstraintMaker* make){
            make.bottom.equalTo(self.canvas);
            make.width.greaterThanOrEqualTo(kBCTNorm(50.f));
            make.width.lessThanOrEqualTo(kBCTNorm(175.f));
            make.height.greaterThanOrEqualTo(kBCTNorm(30.f));
        }];
        
        _userIcon = [[BCTUserIcon alloc] initWithFrame:CGRectMake(0, 0, kBCTNorm(40.f), kBCTNorm(40.f))];
        
        [self addSubview:_userIcon];
        [_userIcon mas_makeConstraints:^(MASConstraintMaker* make){
            make.bottom.equalTo(self.canvas);
            make.width.equalTo(kBCTNorm(40.f));
            make.height.equalTo(kBCTNorm(40.f));
            make.left.equalTo(self.canvas).with.offset(kBCTNorm(10.f));
        }];
        
        _userIcon.hidden = YES;
    }
    return self;
}

- (void)setMessage:(BCTMessage *)message {
    _message = message;
    
    BOOL isMessageToMe = [message.to isEqualToString:[BCTVCManager sharedManager].userPhoneNumber];
    
    if (isMessageToMe) {
        self.userIcon.hidden = NO;
        [self.messageBubble setBackgroundImage:[UIImage imageNamed:@"message_bubble_gray"] forState:UIControlStateNormal];
        [self.messageBubble mas_updateConstraints:^(MASConstraintMaker* make){
            make.left.equalTo(self.canvas).with.offset(kBCTNorm(10.f));
        }];
    }
    else {
        self.userIcon.hidden = YES;
        [self.messageBubble setBackgroundImage:[UIImage imageNamed:@"message_bubble_green"] forState:UIControlStateNormal];
        [self.messageBubble mas_updateConstraints:^(MASConstraintMaker* make){
            make.right.equalTo(self.canvas).with.offset(kBCTNorm(-10.f));
        }];
    }
    
    [self layoutIfNeeded];
    
    CGFloat height = message.bubbleHeight;
    
    if (message.bubbleHeight == 0) {
        height = _messageBubble.titleLabel.frame.size.height + kBCTNorm(20.f);
        message.bubbleHeight = height;
    }
    
    [self.messageBubble updateConstraints:^(MASConstraintMaker* make){
        make.height.equalTo(height);
    }];
    
    [self layoutIfNeeded];
    
    if (!message.isAnimated) {
        _originalCenterX = self.canvas.center.x;
        self.canvas.center = CGPointMake(isMessageToMe? _originalCenterX-kBCTNorm(30.f):_originalCenterX+kBCTNorm(30.f), self.canvas.center.y);
        [UIView animateWithDuration:0.3f animations:^{
            self.canvas.center = CGPointMake(_originalCenterX, self.canvas.center.y);
        } completion:^(BOOL finished){
            message.isAnimated = YES;
        }];
    }
}

@end
