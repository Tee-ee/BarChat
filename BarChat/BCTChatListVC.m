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
#import "BCTMessage.h"
#import "BCTIOManager.h"

@interface BCTChatListVC ()

@property (nonatomic, strong) NSMutableArray<BCTMessage*>*   conversations;

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
    
    BCTMessage* message = [BCTMessage messageWithJSON:@{@"ID":@0, @"from":@"15689932457", @"to":@"18563816406", @"content":@"hi", @"type":@0, @"displayName":@"Qoo"}];
    [self.conversations addObject:message];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refresh];
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
    
    BCTMessage* message = [self.conversations objectAtIndex:indexPath.row];
    cell.message = message;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kBCTNorm(65.f);
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [[BCTVCManager sharedManager] pushToChatVCWithPeerPhoneNumber:@""];
}

#pragma mark customMethods

- (void)refresh {
    [self.tableView reloadData];
}

@end
