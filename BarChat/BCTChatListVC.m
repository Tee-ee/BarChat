//
//  BCTChatListVC.m
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTChatListVC.h"
#import "BCTMacros.h"
#import "BCTChatListCell.h"
#import "BCTVCManager.h"
#import "BCTConversation.h"
#import "BCTIOManager.h"
#import "BCTDateManager.h"

@interface BCTChatListVC ()

@property (nonatomic, strong) NSMutableArray<BCTConversation*>*   conversations;

@end

@implementation BCTChatListVC
{
    NSString* _reuseIdentifier;
}
- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        _reuseIdentifier = @"BCTChatListCell";
        _conversations = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.contentInset = UIEdgeInsetsMake(kBCTContentInsetTop, 0, kBCTMainBottomBarHeight, 0);
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[BCTChatListCell class] forCellReuseIdentifier:_reuseIdentifier];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, kBCTNorm(10.f), 0, 0);
//    [self fakeSomeData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCTChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:_reuseIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[BCTChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_reuseIdentifier];
    }
    
    BCTConversation* conversation = [self.conversations objectAtIndex:indexPath.row];
    cell.conversation = conversation;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kBCTNorm(65.f);
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BCTConversation* conversation = [self.conversations objectAtIndex:indexPath.row];
    NSString* peerPhoneNumber = conversation.phoneNumber;
    [[BCTVCManager sharedManager] pushToChatVCWithPeerPhoneNumber:peerPhoneNumber displayName:conversation.displayName];
}

#pragma mark customMethods

- (void)refresh {
    [self fetchConversation];
    [self.tableView reloadData];
}

- (void)fetchConversation {
    NSMutableArray* result = [NSMutableArray array];
    NSArray* conversations = [[BCTIOManager sharedManager] getConversations];
#warning sort conersations by date
    for (NSDictionary* conversationDict in conversations) {
        BCTConversation* conversation = [BCTConversation conversationWithDic:conversationDict];
        [result addObject:conversation];
    }
    
    self.conversations = result;
}


@end
