//
//  BCTSocketManager.h
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BCTSocketManagerDelegate;

@interface BCTSocketManager : NSObject

@property (nonatomic, assign, readonly) BOOL                isInernetReachable;

@property (nonatomic, assign, readonly) BOOL                isConnectedToServer;

@property (nonatomic, weak) id<BCTSocketManagerDelegate>    delegate;

- (void)connect;

- (void)sendData:(NSData*)data;

@end

@protocol BCTSocketManagerDelegate <NSObject>

- (void)socketManager:(BCTSocketManager*)manager didConnectToHost:(NSString*)host;

- (void)socketManager:(BCTSocketManager *)manager cannotConnectToHost:(NSString *)host;

- (void)socketManager:(BCTSocketManager*)manager didReceivedData:(NSData*)data;


@end
