//
//  ShowLoginSegue.m
//  LXPig
//
//  Created by leexiang on 15/4/12.
//
//

#import "ShowLoginSegue.h"

@implementation ShowLoginSegue

-(void)perform
{
    UIViewController* vc= self.sourceViewController;
    UIView* firstVCView = vc.parentViewController.parentViewController.view;
    UIView* secondVCView = [self.destinationViewController view];
    
    secondVCView.frame = CGRectOffset(secondVCView.frame, 0, SCREEN_HEIGHT);
    secondVCView.transform = CGAffineTransformScale(secondVCView.transform,0.001,0.001);
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    [window insertSubview:secondVCView aboveSubview:firstVCView];
    [UIView animateWithDuration:0.5 animations:^{
        firstVCView.transform = CGAffineTransformScale(firstVCView.transform, 0.001, 0.001);
        firstVCView.frame = CGRectOffset(firstVCView.frame, 0, -SCREEN_HEIGHT);
        
        secondVCView.transform = CGAffineTransformIdentity;
        secondVCView.frame = CGRectOffset(secondVCView.frame, 0, -SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [vc presentViewController:self.destinationViewController animated:NO completion:nil];
    }];
    
    
}

@end
