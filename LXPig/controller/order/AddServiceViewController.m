//
//  AddServiceViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/7.
//
//

#import "AddServiceViewController.h"
#import "OrderServiceTableViewController.h"
#import "NetWorkClient.h"
@interface AddServiceViewController ()<UITextViewDelegate>
{
    BOOL isLoaded;
}
@property (weak,nonatomic) IBOutlet UIView* textAndBtnView;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint* bottomContraint;
@property (weak,nonatomic) OrderServiceTableViewController* controller;
@property (weak,nonatomic) IBOutlet UITextView* textView;
@property (strong,nonatomic) NSString* serviceContent;
@end

@implementation AddServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textAndBtnView.layer.masksToBounds = YES;
    self.textAndBtnView.layer.borderColor = [UIColor colorWithRed:0xcd/255.f green:0xcd/255.f blue:0xcd/255.f alpha:1].CGColor;
    self.textAndBtnView.layer.borderWidth = 1;
    self.textAndBtnView.layer.cornerRadius = 4;
    [self addBackButton];
    self.title =@"订单服务";
    isLoaded = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (isLoaded == NO) {
        [self.controller startRefresh];
        isLoaded = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                            object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]
                           
                           CGRectValue];
    NSTimeInterval animationDuration = [[userInfo
                                         
                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    animation.toValue = [NSNumber numberWithFloat:keyboardRect.size.height];
    animation.duration = animationDuration;
    [self.bottomContraint pop_addAnimation:animation forKey:@"bottom_height"];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration = [[userInfo
                                         
                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    animation.toValue = [NSNumber numberWithFloat:0];
    animation.duration = animationDuration;
    [self.bottomContraint pop_addAnimation:animation forKey:@"bottom_height_zero"];
}


-(IBAction)addService:(id)sender
{
    [self.textView resignFirstResponder];
    if (self.serviceContent == nil || self.serviceContent.length == 0) {
        [self showNormalHudDimissWithString:@"请填写服务内容"];
    }
    UIView* hud = [self showNormalHudNoDimissWithString:@"提交服务"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_SERVICE With:@{@"action":@"save",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"orderNum":[self.orderInfo objectForKey:@"orderNum"],@"content":self.serviceContent} success:^(NSDictionary *responseObj, NSString *timeSp) {

        [self dismissHUD:hud WithSuccessString:@"完成提交"];
        self.textView.text = @"";
        self.serviceContent = @"";
        [self.controller startRefresh];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:hud WithSuccessString:@"提交失败"];
    }];
}

-(void)textViewDidChange:(UITextView *)textView
{
    self.serviceContent = textView.text;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"show_service_table"]) {
        self.controller = [segue destinationViewController];
        self.controller.orderInfo = self.orderInfo;
    }
}


@end
