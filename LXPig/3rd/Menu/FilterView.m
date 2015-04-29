//
//  FilterView.m
//  IFlying
//
//  Created by llwang on 13-11-21.
//  Copyright (c) 2013年 com.iflying. All rights reserved.
//
#import "FilterView.h"

@interface FilterView() <PullDownMenuDelegate>
{
    NSMutableArray *_selectedArray;
}
@end

@implementation FilterView

- (id)initWithFrame:(CGRect)frame
   buttonTitleArray:(NSArray*)titleArray
    dataSourceArray:(NSArray*)dataArray
           delegate:(id<FilterViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        _dataArray = dataArray;
        _selectedArray = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        NSInteger count = titleArray.count;
        for (int i = 0; i<count ;i++) {
            UIButton* b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.imageEdgeInsets = UIEdgeInsetsMake(0, self.frame.size.width/count - 10, 0, 0);
            b.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 15);
            b.backgroundColor = [UIColor whiteColor];
            b.adjustsImageWhenHighlighted = NO;
            [b setTag:i];
            [b.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [b setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [b setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [b setImage:[UIImage imageNamed:@"mall_main_menu_normal"] forState:UIControlStateNormal];
            [b setImage:[UIImage imageNamed:@"mall_main_menu_selected"] forState:UIControlStateSelected];
            [b setImage:[UIImage imageNamed:@"mall_main_menu_selected"] forState:UIControlStateHighlighted];
            [b setBackgroundImage:[UIImage imageNamed:@"mall_tab_bg"] forState:UIControlStateNormal];

            [b setFrame:CGRectMake(i*self.frame.size.width/count, 0, self.frame.size.width/count, self.frame.size.height)];
            [b setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [b addTarget:self
                  action:@selector(__showTableView:)
        forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:b];
            //每个button对应_selectedArray的一项
            [_selectedArray addObject:@{}];
        }
        
        for (int i=1; i<count; i++) {
            UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.frame.size.width/count, 0, 0.5, self.frame.size.height)];
            separator.contentMode = UIViewContentModeScaleAspectFit;
            separator.image = [UIImage imageNamed:@"filter_separator"];
            [self addSubview:separator];
        }
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
}

- (void)setEnabled:(BOOL)enable
{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            ((UIButton *)v).enabled = enable;
        }
    }
}

- (void)setSelected:(BOOL)selected
{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[UIButton class]]) {
            ((UIButton *)v).selected = selected;
        }
    }
}

#pragma mark - PullDownMenud Delegate

- (void)pullDownMenu:(PullDownMenu *)pullDownMenu didSelectedCell:(NSDictionary *)info selectedMenuIndex:(NSInteger)tag
{
    [_selectedArray replaceObjectAtIndex:tag withObject:info];
    if (_delegate && [_delegate respondsToSelector:@selector(filterView:didSelectedCell:selectedMenuIndex:)]) {
        self.selected = NO;
        //替换选中项
        //实现代理，刷新Controller界面
        [_delegate filterView:self didSelectedCell:info selectedMenuIndex:tag];
    }
}

- (void)pullDownMenuWillDismiss:(PullDownMenu *)pullDownMenu
{
    self.selected = NO;
}

#pragma mark - Private

-(void)__showTableView:(UIButton*)sender
{
    if (_dataArray == nil) {
        return;
    }
    //已经显示下拉菜单
    if (sender.isSelected) {
        [PullDownMenu dismissActiveMenu:nil];
        sender.selected = NO;
        return;
    }
    self.selected = NO;

    [PullDownMenu showMenuBelowView:self
                              array:[_dataArray objectAtIndex:sender.tag]
                  selectedMenuIndex:sender.tag
                     selectedDetail:[_selectedArray objectAtIndex:sender.tag]
                           delegate:self];
    sender.selected = YES;
}

-(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
