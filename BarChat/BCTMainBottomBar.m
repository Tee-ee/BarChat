//
//  BCTMainBottomBar.m
//  BarChat
//
//  Created by Vince on 7/10/17.
//  Copyright © 2017 ChenghaoWang. All rights reserved.
//

#import "BCTMainBottomBar.h"
#import "BCTMacros.h"


@interface BCTMainBottomBarItem : UIView

@property (nonatomic, strong) UIButton*     itemIcon;

@property (nonatomic, strong) UILabel*      itemTitle;

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString*)imageName title:(NSString*)title imageFrame:(CGRect)imageFrame;

- (void)itemSelected:(BOOL)selected;

@end


@interface BCTMainBottomBar()

@property (nonatomic, strong) NSMutableArray<BCTMainBottomBarItem*>*    barItems;

@property (nonatomic, strong) UITapGestureRecognizer*       tapRecognizer;

@property (nonatomic, weak)   BCTMainBottomBarItem*         previousItem;

@end

@implementation BCTMainBottomBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSArray* buttonImageNames = @[@"chat", @"friends", @"discovery", @"me"];
        NSArray* buttonTitles = @[@"微信",@"通讯录",@"发现",@"我"];
        NSArray* buttonIconFrames = @[[NSValue valueWithCGRect:CGRectMake(0,0,kBCTNorm(26.f), kBCTNorm(22.f))],
                                      [NSValue valueWithCGRect:CGRectMake(0,0,kBCTNorm(26.f), kBCTNorm(21.f))],
                                      [NSValue valueWithCGRect:CGRectMake(0,0,kBCTNorm(24.f), kBCTNorm(24.f))],
                                      [NSValue valueWithCGRect:CGRectMake(0,0,kBCTNorm(23.f), kBCTNorm(21.f))]];

        _barItems = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            BCTMainBottomBarItem* item = [[BCTMainBottomBarItem alloc] initWithFrame:CGRectMake(i * frame.size.width * 0.25, 0, frame.size.width * 0.25, kBCTNorm(50.f)) imageName:buttonImageNames[i] title:buttonTitles[i] imageFrame:[buttonIconFrames[i] CGRectValue]];
            
            [self addSubview:item];
            [_barItems addObject:item];
        }
        
        self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:self.tapRecognizer];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer*)recognizer {
    
    CGFloat tapLocationX = [recognizer locationInView:self].x;
    
    for (int i = 0; i < 4; i++) {
        if (tapLocationX < (i + 1) * kBCTScreenWidth * 0.25) {
            [self sectionSelected:i];
            return;
        }
    }
}

- (void)sectionSelected:(int)index {
    if (self.previousItem != nil) {
        [self.previousItem itemSelected:NO];
    }
    BCTMainBottomBarItem* item = [self.barItems objectAtIndex:index];
    [item itemSelected:YES];
    self.currentTitle = item.itemTitle.text;
    self.previousItem = item;
    
    if (self.BCTDelegate) {
        [self.BCTDelegate bottomBar:self didSelectSection:index];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self sectionSelected:0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation BCTMainBottomBarItem
{
    BOOL    _isSelected;
}
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString*)imageName title:(NSString*)title imageFrame:(CGRect)imageFrame {
    

    if (self = [super initWithFrame:frame]) {
        _isSelected  = NO;
        _itemIcon = [[UIButton alloc] initWithFrame:imageFrame];
        _itemIcon.center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5 - kBCTNorm(5.f));
        [_itemIcon setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"main_%@_button", imageName]] forState:UIControlStateDisabled];
        [_itemIcon setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"main_%@_button_selected", imageName]] forState:UIControlStateSelected];
        [_itemIcon setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"main_%@_button_selected", imageName]] forState:UIControlStateHighlighted];
        _itemIcon.enabled = NO;
        
        _itemTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, kBCTNorm(32.5f), frame.size.width, kBCTNorm(20.f))];
        _itemTitle.textAlignment = NSTextAlignmentCenter;
        _itemTitle.textColor = [UIColor colorWithWhite:0.5f alpha:1.f];
        _itemTitle.font = [UIFont fontWithName:@".SFUIText" size:kBCTNorm(11.f)];
        _itemTitle.text = title;
        
        [self addSubview:_itemIcon];
        [self addSubview:_itemTitle];
        
    }
    
    return self;
}

- (void)itemSelected:(BOOL)selected{
    if (selected == _isSelected) {
        return;
    }
    _isSelected = selected;
    UIColor* color = selected ? [UIColor colorWithRed:0.1f green:0.7f blue:0.1f alpha:1.f] : [UIColor colorWithWhite:0.5f alpha:1.f];
    self.itemTitle.textColor = color;
    self.itemIcon.enabled = selected;
    self.itemIcon.selected = selected;

}
@end




