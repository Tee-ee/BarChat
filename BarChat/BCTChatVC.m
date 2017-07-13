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
#import "BCTIOManager.h"

@interface BCTChatVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView*      chatTableView;

@property (nonatomic, strong) UIToolbar*        inputBar;

@property (nonatomic, strong) UITextField*      inputField;

@property (nonatomic, strong) NSMutableArray<BCTMessage*>* messages;

@property (nonatomic, strong) NSMutableArray<BCTMessage*>* messagesToDisplay;

@property (nonatomic, strong) NSTimer*          messageTimer;

@property (nonatomic, strong) UITapGestureRecognizer*   tapRecognizer;

@end

@implementation BCTChatVC
{
    NSString*   _reuseIdentifier;
    CGRect      _inputBarOriginalFrame;
}
- (instancetype)init {
    if (self = [super init]) {
        
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kBCTScreenWidth, kBCTScreenHeight - kBCTNorm(50.f)) style:UITableViewStylePlain];
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _reuseIdentifier = @"BCTChatCell";
        [_chatTableView registerClass:[BCTChatCell class] forCellReuseIdentifier:_reuseIdentifier];
        _inputBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kBCTScreenHeight - kBCTNorm(50.f), kBCTScreenWidth, kBCTNorm(50.f))];
        _inputBarOriginalFrame = _inputBar.frame;
        _inputField = [[UITextField alloc] initWithFrame:CGRectMake(kBCTNorm(40.f), kBCTNorm(kBCTNorm(7.5f)), kBCTNorm(200.f), kBCTNorm(35.f))];
        _inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputField.borderStyle = UITextBorderStyleRoundedRect;
        _inputField.backgroundColor = [UIColor whiteColor];
        _inputField.delegate = self;
        _messages = [NSMutableArray array];
        _messagesToDisplay = [NSMutableArray array];
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.chatTableView];
    [self.view addSubview:self.inputBar];
    [self.view addGestureRecognizer:self.tapRecognizer];
    [self.inputBar addSubview:self.inputField];
    
    self.messageTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f repeats:YES block:^(NSTimer* timer){
        if (self.messagesToDisplay.count != 0) {
            BCTMessage* message = [self.messagesToDisplay firstObject];
            [self.messages addObject:message];
            [self scrollToBottom];
            [self.messagesToDisplay removeObjectAtIndex:0];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.chatTableView.contentInset = UIEdgeInsetsMake(self.chatTableView.contentInset.top, 0, kBCTNorm(70.f), 0);
    
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.chatTableView.contentInset = UIEdgeInsetsMake(self.chatTableView.contentInset.top, 0, kBCTNorm(20.f), 0);
//    [self fakeSomeMessages];
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewDidDisappear:animated];
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
    cell.fatherVC = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCTMessage* message = [self.messages objectAtIndex:indexPath.row];
    CGFloat bubbleFinalHeight = message.bubbleHeight + kBCTNorm(20.f);
    return MAX(kBCTNorm(50.f), bubbleFinalHeight);
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString* content = textField.text;
    
    if (content.length == 0) {
        return NO;
    }
    else {
        [[BCTIOManager sharedManager] sendMessage:textField.text to:self.peerPhoneNumber];
        textField.text = @"";
        [textField resignFirstResponder];
        return YES;
    }
}

#pragma mark keyboard process
- (void)keyboardWillShow:(id)sender {
    
    NSDictionary* info = [sender userInfo];
    
    CGFloat keyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect finalFrame = CGRectMake(self.inputBar.frame.origin.x, self.inputBar.frame.origin.y - keyboardHeight, self.inputBar.frame.size.width, self.inputBar.frame.size.height);
    
    [UIView animateWithDuration:duration animations:^{
        self.inputBar.frame = finalFrame;
        self.chatTableView.contentInset = UIEdgeInsetsMake(self.chatTableView.contentInset.top, 0, kBCTNorm(20.f) + keyboardHeight, 0);
    } completion:^(BOOL finished){
        [self scrollToBottom];
    }];
}

- (void)keyboardWillHide:(id)sender {
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.inputBar.frame = _inputBarOriginalFrame;
        self.chatTableView.contentInset = UIEdgeInsetsMake(self.chatTableView.contentInset.top, 0, kBCTNorm(20.f), 0);
        
    }];
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

- (void)tap:(UITapGestureRecognizer*)recognizer {
    [self.inputField resignFirstResponder];
}

- (void)fakeSomeMessages {
    for (int i = 0; i < 20; i++) {
        int random = arc4random()%2;
        NSString* content = @"hi";
        for (int i = 0; i < arc4random()%10 + 10; i++) {
            content = [content stringByAppendingString:@" hi"];
        }
        BCTMessage* message = [BCTMessage messageWithJSON:@{@"ID":@0, @"from":random==0? @"15689932457":@"18563816406", @"to":@"18563816406", @"content":content, @"type":@0}];
        [_messagesToDisplay addObject:message];
    }
}

- (void)addMessage:(BCTMessage*)message {
    message.isAnimated = NO;
    [self.messagesToDisplay addObject:message];
}

- (void)refresh {
    [self fetchMessages];
    [self scrollToBottom];
}

- (void)fetchMessages {
    self.messages = [NSMutableArray array];
    NSArray* messages = [[BCTIOManager sharedManager] getMessagesWithPhoneNumber:self.peerPhoneNumber];
    for (NSDictionary* messageDict in messages) {
        BCTMessage* message = [BCTMessage messageWithJSON:messageDict];
        [self.messages addObject:message];
    }
}
@end
