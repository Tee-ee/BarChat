//
//  BCTChatListCell.m
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTChatListCell.h"
#import "BCTUserIcon.h"
#import "BCTMacros.h"
#import "BCTConversation.h"
#import "BCTDateManager.h"

@interface BCTChatListCell()

@property (nonatomic, strong) BCTUserIcon*  icon;

@property (nonatomic, strong) UILabel*      nameLabel;

@property (nonatomic, strong) UILabel*      contentLabel;

@property (nonatomic, strong) UILabel*      dateLabel;

@end

@implementation BCTChatListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _icon = [[BCTUserIcon alloc] initWithFrame:CGRectMake(kBCTNorm(10.f), kBCTNorm(10.f), kBCTNorm(45.f), kBCTNorm(45.f))];
        [self addSubview:_icon];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBCTNorm(65.f), kBCTNorm(12.5f), kBCTNorm(200.f), kBCTNorm(17.5f))];
        _nameLabel.font = [UIFont fontWithName:@".SFUIText" size:kBCTNorm(16.f)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor colorWithWhite:0.13f alpha:1.f];
        _nameLabel.text = @"_user_name_";
        _nameLabel.numberOfLines = 1;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_nameLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBCTNorm(65.f), kBCTNorm(35.f), kBCTNorm(200.f), kBCTNorm(15.f))];
        _contentLabel.font = [UIFont fontWithName:@".SFUIText" size:kBCTNorm(12.5f)];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.f];
        _contentLabel.text = @"_latest_message_";
        _contentLabel.numberOfLines = 1;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_contentLabel];

        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBCTNorm(240.f), kBCTNorm(10.f), kBCTNorm(70.f), kBCTNorm(15.f))];
        _dateLabel.font = [UIFont fontWithName:@".SFUIText" size:kBCTNorm(10.f)];
        _dateLabel.textColor = [UIColor colorWithWhite:0.6f alpha:1.f];
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.text = @"_date_";
        _dateLabel.numberOfLines = 1;
        [self addSubview:_dateLabel];
    
    }
    return self;
}

- (void)setConversation:(BCTConversation *)conversation {
    _conversation = conversation;
    _nameLabel.text = conversation.displayName;
    _contentLabel.text = conversation.content;
    _dateLabel.text = [[BCTDateManager sharedManager] dateStringWithTimeIntervalSince1970:conversation.date];
}

@end
