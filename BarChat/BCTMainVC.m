//
//  BCTMainVC.m
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTMainVC.h"
#import "BCTMacros.h"
#import "BCTMainBottomBar.h"
#import "BCTIOManager.h"
#import "BCTVCManager.h"
#import "BCTChatListVC.h"
#import "BCTFriendsVC.h"
#import "BCTDiscoveryVC.h"
#import "BCTMeVC.h"

@interface BCTMainVC () <BCTMainBottomBarDelegate>

@property (nonatomic, strong) BCTMainBottomBar* bottomBar;

@property (nonatomic, strong) BCTChatListVC*    chatListVC;

@property (nonatomic, strong) BCTFriendsVC*     friendsVC;

@property (nonatomic, strong) BCTDiscoveryVC*   discoveryVC;

@property (nonatomic, strong) BCTMeVC*          meVC;

@end

@implementation BCTMainVC


- (instancetype)init {
    if (self = [super init]) {
        _chatListVC = [[BCTChatListVC alloc] initWithStyle:UITableViewStylePlain];
        _friendsVC = [[BCTFriendsVC alloc] initWithStyle:UITableViewStyleGrouped];
        _discoveryVC = [[BCTDiscoveryVC alloc] initWithStyle:UITableViewStyleGrouped];
        _meVC = [[BCTMeVC alloc] initWithStyle:UITableViewStyleGrouped];
        _bottomBar = [[BCTMainBottomBar alloc] initWithFrame:CGRectMake(0, kBCTScreenHeight - kBCTMainBottomBarHeight, kBCTScreenWidth, kBCTMainBottomBarHeight)];
        _bottomBar.BCTDelegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.chatListVC.tableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomBar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [BCTIOManager sharedManager].phoneNumber = @"00000000000";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark BCTMainBottomBarDelegate

- (void)bottomBar:(BCTMainBottomBar *)bottomBar didSelectSection:(int)index {
    self.navigationItem.title = bottomBar.currentTitle;
}



@end
