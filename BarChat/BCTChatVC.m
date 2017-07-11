//
//  BCTChatVC.m
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTChatVC.h"
#import "BCTMacros.h"
#import "BCTMessage.h"
#import "BCTChatCell.h"
#import "BCTVCManager.h"

@interface BCTChatVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView*      chatTableView;

@property (nonatomic, strong) NSMutableArray<BCTMessage*>* messages;

@end

@implementation BCTChatVC
{
    NSString*   _reuseIdentifier;
}
- (instancetype)init {
    if (self = [super init]) {
        _chatTableView = [[UITableView alloc] initWithFrame:kBCTScreenBounds style:UITableViewStylePlain];
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.contentInset = UIEdgeInsetsMake(kBCTContentInsetTop, 0, kBCTNorm(50.f), 0);
        
        _reuseIdentifier = @"BCTChatCell";
        [_chatTableView registerClass:[BCTChatCell class] forCellReuseIdentifier:_reuseIdentifier];
        
        _messages = [NSMutableArray array];
    BCTMessage* message = [BCTMessage messageWithJSON:@{@"ID":@0, @"from":@"15689932457", @"to":@"18563816406", @"content":@"hihihi", @"type":@0, @"displayName":@"Qoo"}];
        [_messages addObject:message];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:_chatTableView];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCTChatCell* cell = [tableView dequeueReusableCellWithIdentifier:_reuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[BCTChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_reuseIdentifier];
    }
    
    BCTMessage* message = [self.messages objectAtIndex:indexPath.row];
    cell.message = message;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCTMessage* message = [self.messages objectAtIndex:indexPath.row];
    CGFloat bubbleFinalHeight = message.bubbleHeight + kBCTNorm(20.f);
    return MAX(kBCTNorm(50.f), bubbleFinalHeight);
}


#pragma mark custom

- (void)setPeerPhoneNumber:(NSString *)peerPhoneNumber {
    _peerPhoneNumber = peerPhoneNumber;
    [self scrollToBottom];
}

- (void)scrollToBottom {
    [self.chatTableView reloadData];
    [self.chatTableView setNeedsLayout];
    [self.chatTableView layoutIfNeeded];
    [self.chatTableView reloadData];
    if (self.messages.count > 0) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

}

@end
