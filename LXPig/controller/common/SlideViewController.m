//
//  SlideViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/14.
//
//

#import "SlideViewController.h"
#import "UserManagerObject.h"
#import "AddressManager.h"
#import "PigCart.h"
#import "RightMenuViewController.h"
//#import "UIImageView+LBBlurredImage.h"
#import <Accelerate/Accelerate.h>
#define MAX_RIGHT_TRAIL (-96)
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewCenter;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (assign,nonatomic) BOOL showLoginController;
@property (nonatomic, assign) SlideViewState      slideViewState;
@property (nonatomic, weak) RightMenuViewController* rightMenu;
-(void) showRightView;
-(void) showCenterView;
@end

@implementation SlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _slideViewState = SlideViewStateCenterShow;
    _tapGesture.delegate =self;
    self.showLoginController = NO;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(processNtf:) name:NTF_SHOW_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(processNtf:) name:NTF_LOGIN_TIMEOUT object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(processNtf:) name:NTF_LOGIN_OK object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showRightMenu:) name:NTF_SHOW_RIGHT_MENU object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)processNtf:(NSNotification*)ntf
{
    if ([ntf.name isEqualToString:NTF_SHOW_LOGIN]) {
        if (self.showLoginController == NO) {
            self.showLoginController = YES;
            [self performSegueWithIdentifier:@"ShowLogin" sender:self];
        }
        
    }
    else if([ntf.name isEqualToString:NTF_LOGIN_TIMEOUT])
    {
        if (self.showLoginController == NO) {
            self.showLoginController = YES;
            [self performSegueWithIdentifier:@"ShowLogin" sender:self];
        }
    }
    else if([ntf.name isEqualToString:NTF_LOGIN_OK])
    {
        self.showLoginController = NO;
        if ([[UserManagerObject shareInstance]userType]==0) {
            [[PigCart shareInstance] refreshCartListSuccess:nil failure:nil];
            [[AddressManager shareInstance]getAddressArraySuccess:nil failure:nil];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showRightMenu:(NSNotification*)ntf
{
    [self showRightView];
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
//            POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//            animation.fromValue = [NSValue valueWithCGSize:CGSizeMake(MAX_SCALE, MAX_SCALE)];
//            animation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
//            animation.duration = 0.2;
//            animation.completionBlock = ^(POPAnimation *anim, BOOL finished)
//            {
//                if (finished) {
//                    self.mainViewContainer.transform = CGAffineTransformIdentity;
//                }
//            };
//            [self.mainViewContainer pop_addAnimation:animation forKey:@"show_main_scale"];
            POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
            animation.duration = 0.2;
            animation.fromValue = @(self.mainViewCenter.constant);
            animation.toValue = @(0);
            animation.completionBlock = ^(POPAnimation *anim, BOOL finished)
            {
                if (finished) {
                    self.mainViewCenter.constant = 0;
                    self.mainViewContainer.userInteractionEnabled = YES;
                }
            };
            [self.mainViewCenter pop_addAnimation:animation forKey:@"show_main_trail"];
            break;
        }
        case SlideViewStateRightShow:
        {
            [self setMainBlurView];
            self.tapGesture.enabled = YES;
            
            
            POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
            animation.duration = 0.2;
            animation.fromValue = @(self.mainViewCenter.constant);
            animation.toValue = @(-MAX_RIGHT_TRAIL);
            [self.mainViewCenter pop_addAnimation:animation forKey:@"show_main_trail"];
            self.mainViewContainer.userInteractionEnabled = NO;
            
//            animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//            animation.duration = 0.2;
//            animation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
//            animation.toValue = [NSValue valueWithCGSize:CGSizeMake(MAX_SCALE, MAX_SCALE)];
//            [self.mainViewContainer pop_addAnimation:animation forKey:@"show_main_scale"];
            
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

- (void)showRightView
{
    self.slideViewState = SlideViewStateRightShow;
}
-(void)showCenterView
{
    self.slideViewState = SlideViewStateCenterShow;
}

-(void)setMainBlurView
{
    [self.rightMenu.blurImageView setImage:[self blurryImage:[self imageFromView:self.mainViewContainer] withBlurLevel:0.09]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"rightMenu"]) {
        RightMenuViewController* controller = [segue destinationViewController];
        controller.slideController = self;
        self.rightMenu = controller;
    }
}
#pragma mark - Blur
- (UIImage *)imageFromView:(UIView *)theView
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
//    if (error) {
//        LLLog(@"error from convolution %ld", error);
//    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end
