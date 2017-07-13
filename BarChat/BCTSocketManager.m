//
//  BCTSocketManager.m
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTSocketManager.h"
#import "GCDAsyncSocket.h"
#import "Reachability.h"
#import "BCTMacros.h"

@interface BCTSocketManager() <GCDAsyncSocketDelegate>

@end

@implementation BCTSocketManager
{
    GCDAsyncSocket*     _socket;
    BOOL                _initialConnectTrial;
}

- (instancetype)init {
    if (self = [super init]) {
        _isInernetReachable = NO;
        _isConnectedToServer = NO;
        _initialConnectTrial = NO;
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        [self detectReachability];
    }
    return self;
}

- (void)detectReachability {
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.appleiphonecell.com"];
    reach.reachableBlock = ^(Reachability* reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"[SUCCEED] internet reachable");
            _isInernetReachable = YES;
        });
    };
    
    reach.unreachableBlock = ^(Reachability* reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"[FAILED] internet unreachable");
            _isInernetReachable = NO;
        });
    };
    
    [reach startNotifier];
}

- (void)connect {
    NSString* host = kBCTHost;
    NSNumber* port = kBCTPort;
    if (_isConnectedToServer) {
        NSLog(@"[NOTICE] socket has already connected to server: %@:%d", host, [port intValue]);
        return;
    }
    
    if (!_isInernetReachable && _initialConnectTrial) {
        NSLog(@"[FAILED] socket trying to connect when no Internet reachability");
        [self performSelector:@selector(connect) withObject:nil afterDelay:kBCTReconnectTimeInterval];
        return;
    }
    
    NSError*    error = nil;
    [_socket connectToHost:host onPort:[port intValue] error:&error];
    if (!_initialConnectTrial) {
        _initialConnectTrial = YES;
    }
    if (error) {
        _isConnectedToServer = NO;
        NSLog(@"[FAILED] cannot connect to server: %@:%d err: %@", host, [port intValue], error);
        [self.delegate socketManager:self cannotConnectToHost:host];
        [self performSelector:@selector(connect) withObject:nil afterDelay:kBCTReconnectTimeInterval];
    }
}

- (void)sendData:(NSData *)data {
    if (!_isConnectedToServer) {
        NSLog(@"[FAILED] trying to send data when disconnected");
        return;
    }
    
    [_socket writeData:data withTimeout:10.f tag:0];
    NSLog(@"[NOTICE] trying to send data");
}

#pragma mark GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"[SUCCEED] connected to server: %@:%d", host,port);
    _isConnectedToServer = YES;
    _isInernetReachable = YES;
    [self.delegate socketManager:self didConnectToHost:host];
    [_socket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"[SUCCEED] socket did write data");
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"[SUCCEED] socket did read data");
    [self.delegate socketManager:self didReceivedData:data];
    [_socket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"[NOTICE] socket did disconnect error: %@", err);
        _isConnectedToServer = NO;
        [self performSelector:@selector(connect) withObject:nil afterDelay:kBCTReconnectTimeInterval];
    });
}
@end
