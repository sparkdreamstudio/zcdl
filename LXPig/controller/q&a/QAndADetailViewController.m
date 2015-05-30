//
//  QAndADetailViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/9.
//
//

#import "QAndADetailViewController.h"
#import "NetWorkClient.h"
#import "QAndADetailTableViewController.h"
@interface QAndADetailViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *answerText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomVertical;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (strong,nonatomic) QAndADetailTableViewController* controller;
@property (strong,nonatomic) NSString* answer;
@end

@implementation QAndADetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title =@"问答详情";
    self.btnView.layer.masksToBounds = YES;
    self.btnView.layer.borderColor = HEXCOLOR(@"cdcdcd").CGColor;
    self.btnView.layer.borderWidth = 1;
    self.btnView.layer.cornerRadius = 4;
    if ([[UserManagerObject shareInstance]userType] != 0) {
        self.bottomVertical.constant = -65;
    }
    else
    {
        if ([self.problem[@"isSolve"] integerValue]==1 || [[self.problem[@"members"] objectForKey:@"id"]longLongValue] == [[UserManagerObject shareInstance]userId]) {
            self.bottomVertical.constant = -65;
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.controller startRefresh];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.bottomVertical pop_addAnimation:animation forKey:@"bottom_height"];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration = [[userInfo
                                         
                                         objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    animation.toValue = [NSNumber numberWithFloat:0];
    animation.duration = animationDuration;
    [self.bottomVertical pop_addAnimation:animation forKey:@"bottom_height_zero"];
}
- (IBAction)postAnswer:(id)sender {
    if (self.answer.length == 0) {
        [self showNormalHudDimissWithString:@"答案不能为空"];
    }
    [self.answerText resignFirstResponder];
    UIView* hud = [self showNormalHudNoDimissWithString:@"提交回复中"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_PROBLEMREPLY With:@{@"action":@"save",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"problemId":[self.problem objectForKey:@"id"],@"content":self.answer} success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:hud WithSuccessString:@"成功"];
        self.answerText.text = @"";
        [self.controller startRefresh];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:hud WithErrorString:@"失败"];
    }];
}

-(void)textViewDidChange:(UITextView *)textView
{
    self.answer = textView.text;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"show_problem_table"]) {
        QAndADetailTableViewController* controller = [segue destinationViewController];
        controller.problem = self.problem;
        controller.controller = self;
        controller.qAndAType = self.qAndAType;
        self.controller = controller;
    }
}


@end
