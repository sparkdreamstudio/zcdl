//
// Created by Shaokang Zhao on 15/1/12.
// Copyright (c) 2015 Shaokang Zhao. All rights reserved.
//

#import "SKTagButton.h"
#import "SKTag.h"

@implementation SKTagButton

+ (instancetype)buttonWithTag:(SKTag *)tag
{
    SKTagButton *btn = [super buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.numberOfLines = 1;
    [btn setTitle:tag.text forState:UIControlStateNormal];
    [btn setTitleColor:tag.textColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:tag.fontSize];
    btn.backgroundColor = tag.bgColor;
    btn.contentEdgeInsets = tag.padding;
    
    if (tag.selectedTextColor) {
        [btn setTitleColor:tag.selectedTextColor forState:UIControlStateHighlighted];
        [btn setTitleColor:tag.selectedTextColor forState:UIControlStateSelected];
    }
    
    if (tag.bgImg)
    {
        [btn setBackgroundImage:tag.bgImg forState:UIControlStateNormal];
    }
    if (tag.selectedBgImg)
    {
        [btn setBackgroundImage:tag.selectedBgImg forState:UIControlStateSelected];
        [btn setBackgroundImage:tag.selectedBgImg forState:UIControlStateHighlighted];
    }
    
    if (tag.borderColor)
    {
        btn.layer.borderColor = tag.borderColor.CGColor;
    }
    
    if (tag.borderWidth)
    {
        btn.layer.borderWidth = tag.borderWidth;
    }
    
    btn.userInteractionEnabled = tag.enable;
    
    btn.layer.cornerRadius = tag.cornerRadius;
    btn.layer.masksToBounds = YES;
    
    return btn;
}

@end
