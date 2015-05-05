//
//  BillTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/4.
//
//

#import "BillTableViewCell.h"

#define TOP_INSET 15
#define LEFT_INSET 15
#define ITEM_WIDTH 60
#define BOTTOM_INSET 15
#define LINE_BREAK 15
#define HORI_BREAK 10

@interface BillTableViewCell ()

@end

@implementation BillTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadCell:(NSArray*)paperInfo WithAddButton:(BOOL)showAdd
{
    for (UIView* view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
//    UIButton * lineFirstButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    lineFirstButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.contentView addSubview:lineFirstButton];
//    
//    
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lineFirstButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:ITEM_WIDTH]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lineFirstButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:ITEM_WIDTH]];
    //        BOOL shouldbreak = NO;
    UIButton * lineFirstButton = nil;
    UIButton* preLineButton = nil;
    NSInteger lineButtonNum = 1;
    NSInteger count = showAdd ? (paperInfo.count + 1) : paperInfo.count;
    for (NSInteger index = 0; index < count; index++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 5;
        if (index < paperInfo.count) {
            button.tag = index;
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[paperInfo[index] objectForKey:@"smallImg"]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(paperButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:@"添加" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(addButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:button];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:ITEM_WIDTH]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:ITEM_WIDTH]];
        if (lineFirstButton == nil)
        {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:54+TOP_INSET]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:LEFT_INSET]];
            lineFirstButton = button;
        }
        else if (lineButtonNum == 1 && [self getLineWidth:lineButtonNum]<SCREEN_WIDTH) {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:lineFirstButton attribute:NSLayoutAttributeRight multiplier:1 constant:HORI_BREAK]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:lineFirstButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            preLineButton = button;
            lineButtonNum++;
        }
        else if ([self getLineWidth:lineButtonNum]<SCREEN_WIDTH)
        {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:preLineButton attribute:NSLayoutAttributeRight multiplier:1 constant:HORI_BREAK]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:preLineButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            preLineButton = button;
            lineButtonNum++;
        }
        else{
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lineFirstButton attribute:NSLayoutAttributeBottom multiplier:1 constant:TOP_INSET]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:LEFT_INSET]];
            lineFirstButton = button;
            lineButtonNum = 1;
        }
    }
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lineFirstButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-BOTTOM_INSET]];
}

-(CGFloat)getLineWidth:(NSInteger)num
{
    NSInteger totalNum = num+1;
    CGFloat width = (totalNum-1)*HORI_BREAK+totalNum*ITEM_WIDTH+LEFT_INSET*2;
    return width;
}

-(void)paperButtonClick:(UIButton*)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(billCellClick:WithBillButton:)]) {
        [self.delegate billCellClick:self WithBillButton:btn];
    }
}

-(void)addButton:(UIButton*)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(billCellClick:WithAddButton:)]) {
        [self.delegate billCellClick:self WithAddButton:btn];
    }
}

@end
