//
//  BCTChatListCell.h
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCTConversation;

@interface BCTChatListCell : UITableViewCell

@property (nonatomic, weak) BCTConversation*   conversation;

@property (nonatomic, strong) NSString*     peerPhoneNumber;

@end
