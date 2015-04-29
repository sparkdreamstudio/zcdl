//
//  CartTableViewController.h
//  LXPig
//
//  Created by leexiang on 15/4/27.
//
//

#import <UIKit/UIKit.h>

@class CartViewController;

@interface CartTableViewController : LXPigTableVIewController

@property (assign, nonatomic)BOOL editModel;
@property (weak,nonatomic) CartViewController* cartViewController;


@end
