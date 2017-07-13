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
#import "BCTVCManager.h"
#import "BCTChatListVC.h"
#import "BCTFriendsVC.h"
#import "BCTDiscoveryVC.h"
#import "BCTMeVC.h"
#import "BCTIOManager.h"

@interface BCTMainVC () <BCTMainBottomBarDelegate>

@property (nonatomic, strong) BCTMainBottomBar* bottomBar;

@property (nonatomic, strong) NSMutableArray<__kindof UITableViewController*>* childrenVCs;

@end

@implementation BCTMainVC


- (instancetype)init {
    if (self = [super init]) {
        _childrenVCs = [NSMutableArray array];
        BCTChatListVC* chatListVC = [[BCTChatListVC alloc] initWithStyle:UITableViewStylePlain];
        [_childrenVCs addObject:chatListVC];
        [BCTVCManager sharedManager].chatListVC = chatListVC;
        
        BCTFriendsVC* friendsVC = [[BCTFriendsVC alloc] initWithStyle:UITableViewStyleGrouped];
        [_childrenVCs addObject:friendsVC];
        [BCTVCManager sharedManager].friendsVC = friendsVC;
        
        BCTDiscoveryVC* discoveryVC = [[BCTDiscoveryVC alloc] initWithStyle:UITableViewStyleGrouped];
        [_childrenVCs addObject:discoveryVC];
        [BCTVCManager sharedManager].discoveryVC = discoveryVC;
        
        BCTMeVC* meVC = [[BCTMeVC alloc] initWithStyle:UITableViewStyleGrouped];
        [_childrenVCs addObject:meVC];
        
        _bottomBar = [[BCTMainBottomBar alloc] initWithFrame:CGRectMake(0, kBCTScreenHeight - kBCTMainBottomBarHeight, kBCTScreenWidth, kBCTMainBottomBarHeight)];
        _bottomBar.BCTDelegate = self;

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (UITableViewController* VC in self.childrenVCs) {
        [self.view addSubview:VC.tableView];
        VC.tableView.hidden = YES;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (UIViewController* VC in self.childrenVCs) {
        [VC viewWillAppear:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (UIViewController* VC in self.childrenVCs) {
        [VC viewDidAppear:animated];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark BCTMainBottomBarDelegate

- (void)bottomBar:(BCTMainBottomBar *)bottomBar didSelectSection:(int)index {
    self.navigationItem.title = bottomBar.currentTitle;
    
    if (bottomBar.previousIndex != -1) {
        UITableViewController* previousVC = [self.childrenVCs objectAtIndex:bottomBar.previousIndex];
        previousVC.tableView.hidden = YES;
    }
    
    UITableViewController* currentVC = [self.childrenVCs objectAtIndex:index];
    currentVC.tableView.hidden = NO;
}



@end
