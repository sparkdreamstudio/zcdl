//
//  InfoListTableViewController.h
//  LXPig
//
//  Created by leexiang on 15/5/11.
//
//

#import <UIKit/UIKit.h>

@class InfoViewController;

@interface InfoListTableViewController : LXPigTableVIewController

@property (weak,nonatomic) InfoViewController* controller;
@property (weak,nonatomic) NSNumber* val;

@end
