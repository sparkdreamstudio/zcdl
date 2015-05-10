//
//  QAndADetailTableViewController.h
//  LXPig
//
//  Created by leexiang on 15/5/9.
//
//

#import <UIKit/UIKit.h>

@class QAndADetailViewController;

@interface QAndADetailTableViewController : LXPigTableVIewController
@property (strong,nonatomic) NSDictionary* problem;
@property (strong,nonatomic) QAndADetailViewController* controller;
@property (strong,nonatomic) NSArray* qAndAType;
@end
