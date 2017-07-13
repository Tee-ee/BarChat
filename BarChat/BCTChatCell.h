//
//  BCTChatCell.h
//  BarChat
//
//  Created by Vince on 7/11/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCTMessage;
@class BCTChatVC;
@interface BCTChatCell : UITableViewCell

@property (nonatomic, weak) BCTChatVC*  fatherVC;

@property (nonatomic, weak) BCTMessage* message;

@end
