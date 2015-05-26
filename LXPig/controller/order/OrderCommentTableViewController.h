//
//  OrderCommentTableViewController.h
//  LXPig
//
//  Created by leexiang on 15/5/7.
//
//

#import <UIKit/UIKit.h>

@class OrderCommentViewController;

@interface OrderCommentTableViewController : LXPigTableVIewController
@property (strong,nonatomic) NSDictionary* orderInfo;
@property (strong,nonatomic) OrderCommentViewController* controller;
@end
