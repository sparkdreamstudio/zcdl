//
//  SlideViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/14.
//
//

#import "SlideViewController.h"
#import "UserManagerObject.h"
#define MAX_RIGHT_TRAIL (-SCREEN_WIDTH*0.25)
#define MAX_SCALE       (0.75f)

typedef NS_ENUM(NSUInteger, SlideViewState) {
    SlideViewStateCenterShow,
    SlideViewStateLeftMoving,
    SlideViewStateLeftShow,
    SlideViewStateRightMoving,
    SlideViewStateRightShow,
};

@interface SlideViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *rightMenuContainer;
@property (weak, nonatomic) IBOutlet UIView *mainViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewTrail;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) SlideViewState      slideViewState;
-(void) showRightView;
-(void) showCenterView;
@end

@implementation SlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _slideViewState = SlideViewStateCenterShow;
    _tapGesture.delegate =self;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![[UserManagerObject shareInstance] sessionid]) {
        [self performSegueWithIdentifier:@"ShowLogin" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(self.slideViewState != SlideViewStateCenterShow)
        return  YES;
    else
        return NO;
}
-(void)setSlideViewState:(SlideViewState)state
{
    _slideViewState = state;
    switch (state) {
        case SlideViewStateCenterShow:
        {
            self.tapGesture.enabled = NO;
            POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            animation.fromValue = [NSValue valueWithCGSize:CGSizeMake(MAX_SCALE, MAX_SCALE)];
            animation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
            animation.duration = 0.2;
            animation.completionBlock = ^(POPAnimation *anim, BOOL finished)
            {
                if (finished) {
                    self.mainViewContainer.transform = CGAffineTransformIdentity;
                }
            };
            [self.mainViewContainer pop_addAnimation:animation forKey:@"show_main_scale"];
            animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
            animation.duration = 0.2;
            animation.fromValue = @(self.mainViewTrail.constant);
            animation.toValue = @(0);
            animation.completionBlock = ^(POPAnimation *anim, BOOL finished)
            {
                if (finished) {
                    self.mainViewTrail.constant = 0;
                }
            };
            [self.mainViewTrail pop_addAnimation:animation forKey:@"show_main_trail"];
            break;
        }
        case SlideViewStateRightShow:
        {
            self.tapGesture.enabled = YES;
            POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            animation.duration = 0.2;
            animation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
            animation.toValue = [NSValue valueWithCGSize:CGSizeMake(MAX_SCALE, MAX_SCALE)];
            animation.completionBlock = ^(POPAnimation *anim, BOOL finished)
            {
                if (finished) {
                    self.mainViewContainer.transform = CGAffineTransformScale(CGAffineTransformIdentity, MAX_SCALE, MAX_SCALE);
                }
            };
            [self.mainViewContainer pop_addAnimation:animation forKey:@"show_main_scale"];
            animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
            animation.duration = 0.2;
            animation.fromValue = @(self.mainViewTrail.constant);
            animation.toValue = @(MAX_RIGHT_TRAIL);
            animation.completionBlock = ^(POPAnimation *anim, BOOL finished)
            {
                if (finished) {
                    self.mainViewTrail.constant = MAX_RIGHT_TRAIL;
                }
            };
            [self.mainViewTrail pop_addAnimation:animation forKey:@"show_main_trail"];
        }
            
        default:
            break;
    }
}

- (IBAction)panMainViewGesture:(UIPanGestureRecognizer*)sender {
    CGPoint trans = [sender translationInView:[UIApplication sharedApplication].keyWindow];
    static BOOL isHideSideMenu;
    static CGFloat startx;
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
        {
            switch (self.slideViewState) {
                case SlideViewStateCenterShow:
                {
                    if(trans.x < 0){
                        // 移动右边页面
                        self.slideViewState = SlideViewStateRightMoving;
                        //startx = self.rightContainer.frame.origin.x;
                    }
                    break;
                }
                
                case SlideViewStateRightShow:
                {
                    if (trans.x > 0) {
                        // 移动左侧页面
                        self.slideViewState = SlideViewStateLeftMoving;
                    }
                    break;
                }
                
                default:
                    break;
            }
            
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            switch (self.slideViewState) {
                case SlideViewStateRightMoving:
                {
                    [self showRightView];
                    break;
                }
                case SlideViewStateLeftMoving:
                {
                    [self showCenterView];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (IBAction)tapMainViewGesture:(id)sender {
    if (self.slideViewState != SlideViewStateCenterShow) {
        [self showCenterView];
    }
}

- (void)showRightView;
{
    self.slideViewState = SlideViewStateRightShow;
}
-(void)showCenterView
{
    self.slideViewState = SlideViewStateCenterShow;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
