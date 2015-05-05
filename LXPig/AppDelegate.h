//
//  AppDelegate.h
//  LXPig
//
//  Created by leexiang on 15/4/6.
//
//

#import <UIKit/UIKit.h>

@class SlideViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) SlideViewController* mainController;

@end

