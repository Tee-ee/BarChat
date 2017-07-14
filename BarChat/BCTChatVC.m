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

@interface BCTChatVC () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UITableView*      chatTableView;

@property (nonatomic, strong) UIToolbar*        inputBar;

@property (nonatomic, strong) UITextView*      inputView;

@property (nonatomic, strong) UITextView*       tempInputView;

@property (nonatomic, strong) NSMutableArray<BCTMessage*>* messages;

@property (nonatomic, strong) NSMutableArray<BCTMessage*>* messagesToDisplay;

@property (nonatomic, strong) NSTimer*          messageTimer;

@property (nonatomic, strong) UITapGestureRecognizer*   tapRecognizer;

@end

@implementation BCTChatVC
{
    NSString*   _reuseIdentifier;
    CGRect      _inputBarOriginalFrame;
    CGFloat     _inputBarYWhenKeyboardShow;
}
- (instancetype)init {
    if (self = [super init]) {
        
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kBCTScreenWidth, kBCTScreenHeight - kBCTNorm(50.f)) style:UITableViewStylePlain];
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.allowsSelection = NO;
        _reuseIdentifier = @"BCTChatCell";
        [_chatTableView registerClass:[BCTChatCell class] forCellReuseIdentifier:_reuseIdentifier];
        _inputBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kBCTScreenHeight - kBCTNorm(50.f), kBCTScreenWidth, kBCTNorm(80.f))];
        CALayer* hairline = [CALayer layer];
        hairline.frame = CGRectMake(0, -0.5f, kBCTScreenWidth, 0.5f);
        hairline.backgroundColor = [[UIColor colorWithWhite:0.85 alpha:1.f] CGColor];
        [_inputBar.layer addSublayer:hairline];
        
        _inputBarOriginalFrame = _inputBar.frame;
        _inputView = [[UITextView alloc] initWithFrame:CGRectMake(kBCTNorm(40.f), kBCTNorm(7.5f), kBCTNorm(200.f), kBCTNorm(37.5f))];
        _tempInputView = [[UITextView alloc] initWithFrame:_inputView.frame];
        _inputView.layer.cornerRadius = kBCTNorm(5.f);
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.delegate = self;
        _inputView.font = [UIFont systemFontOfSize:kBCTNorm(18.f)];
        _inputView.textAlignment = NSTextAlignmentLeft;
        _inputView.layer.borderWidth = 0.5f;
        _inputView.layer.borderColor = [[UIColor colorWithWhite:0.8f alpha:1.f] CGColor];
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
    [self.inputBar addSubview:self.inputView];
    
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
    
    if (self.chatTableView.contentInset.bottom != kBCTNorm(20.f)) {
        self.chatTableView.contentInset = UIEdgeInsetsMake(self.chatTableView.contentInset.top, 0, kBCTNorm(70.f), 0);
    }

    self.navigationItem.title = self.displayName;
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.chatTableView.contentInset = UIEdgeInsetsMake(self.chatTableView.contentInset.top, 0, kBCTNorm(20.f), 0);
    self.inputView.contentInset = UIEdgeInsetsZero;
//    [self fakeSomeMessages];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.inputView resignFirstResponder];
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
    cell.fatherVC = self;
    cell.message = message;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCTMessage* message = [self.messages objectAtIndex:indexPath.row];
    CGFloat bubbleFinalHeight = message.bubbleHeight + kBCTNorm(20.f);
    return MAX(kBCTNorm(50.f), bubbleFinalHeight);
}

#pragma mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString* content = textView.text;
    if ((content.length + text.length - range.length) > 80) {
        NSLog(@"[NOTICE] text length too long");
        return NO;
    }
    
    if ([text containsString:@"\n"]) {
        if (content.length != 0) {
            [[BCTIOManager sharedManager] sendMessage:content to:self.peerPhoneNumber];
            textView.text = @"";
            [self textViewDidChange:textView];
            [textView resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {

    NSDictionary *dictAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:kBCTNorm(18.f)]};
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:dictAttr];
    CGSize size = [textView sizeThatFits:CGSizeMake(kBCTNorm(200.f), FLT_MAX)];
    CGFloat finalHeight = MIN(size.height,kBCTNorm(kBCTInputViewMaxHeight));
    CGFloat heightDelta = finalHeight - textView.frame.size.height;
    CGRect inputBarFinalFrame = CGRectMake(self.inputBar.frame.origin.x, self.inputBar.frame.origin.y - heightDelta, self.inputBar.frame.size.width, self.inputBar.frame.size.height + heightDelta);
    CGRect chatTableViewFinalFrame = CGRectMake(self.chatTableView.frame.origin.x, self.chatTableView.frame.origin.y - heightDelta, self.chatTableView.frame.size.width, self.chatTableView.frame.size.height);
    
    [UIView animateWithDuration:0.3f animations:^{
        self.inputBar.frame = inputBarFinalFrame;
        textView.frame = CGRectMake(kBCTNorm(40.f), kBCTNorm(7.5f), kBCTNorm(200.f), finalHeight);
        self.chatTableView.frame = chatTableViewFinalFrame;
    }];
    if (size.height > kBCTNorm(kBCTInputViewMaxHeight)) {
        textView.scrollEnabled = YES;
    }
    else {
        textView.scrollEnabled = NO;
    }
}

#pragma mark keyboard process
- (void)keyboardWillShow:(id)sender {
    
    NSDictionary* info = [sender userInfo];
    
    CGFloat keyboardHeight = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    _inputBarYWhenKeyboardShow = _inputBarOriginalFrame.origin.y - keyboardHeight;
    CGRect finalFrame = CGRectMake(_inputBarOriginalFrame.origin.x, _inputBarYWhenKeyboardShow, _inputBarOriginalFrame.size.width, _inputBarOriginalFrame.size.height);
    UIEdgeInsets finalInset = UIEdgeInsetsMake(self.chatTableView.contentInset.top, 0, kBCTNorm(20.f) + keyboardHeight, 0);
    self.chatTableView.contentInset = finalInset;
    
    self.inputBar.clipsToBounds = YES;
    [UIView animateWithDuration:duration animations:^{
        self.inputBar.frame = finalFrame;
    } completion:^(BOOL finished){
        self.inputBar.clipsToBounds = NO;
        [self scrollToBottom];
    }];
}

- (void)keyboardWillHide:(id)sender {
    
    self.chatTableView.contentInset = UIEdgeInsetsMake(self.chatTableView.contentInset.top, 0, kBCTNorm(20.f), 0);
    self.inputBar.clipsToBounds = YES;
    [UIView animateWithDuration:0.2f animations:^{
        self.inputBar.frame = _inputBarOriginalFrame;
    } completion:^(BOOL finished){
        self.inputBar.clipsToBounds = NO;
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
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}

- (void)tap:(UITapGestureRecognizer*)recognizer {
    [self.inputView resignFirstResponder];
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
