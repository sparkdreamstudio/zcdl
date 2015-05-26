//
//  ForgetPasswordSecViewController.h
//  LXPig
//
//  Created by leexiang on 15/5/17.
//
//

#import "LXPigTableVIewController.h"
@class LoginTableViewController;
@interface ForgetPasswordSecViewController : LXPigTableVIewController

@property (nonatomic,strong)NSString* mobile;
@property (weak,nonatomic) id loginController;

@end
