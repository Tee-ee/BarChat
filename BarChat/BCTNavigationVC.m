//
//  BCTNavigationVC.m
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTNavigationVC.h"
#import "BCTMacros.h"
#import "BCTMainVC.h"

@interface BCTNavigationVC ()

@end

@implementation BCTNavigationVC

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        self.navigationBar.barTintColor = [UIColor blackColor];
        self.navigationBar.barStyle = UIBarStyleBlack;
        
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor],
                                                   NSForegroundColorAttributeName,
                                                   [UIFont fontWithName:@".SFUIText" size:kBCTNorm(20.f)],
                                                   NSFontAttributeName,
                                                   nil];
        [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
