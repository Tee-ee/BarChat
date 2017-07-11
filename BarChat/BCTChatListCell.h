//
//  BCTChatListCell.h
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCTMessage;

@interface BCTChatListCell : UITableViewCell

@property (nonatomic, weak) BCTMessage*   message;

@end
