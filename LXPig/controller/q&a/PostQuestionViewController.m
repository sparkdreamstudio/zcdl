//
//  PostQuestionViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/10.
//
//

#import "PostQuestionViewController.h"
#import "NetWorkClient.h"
@interface PostQuestionViewController ()<UIActionSheetDelegate,JGProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong,nonatomic) NSNumber* codeId;
@property (strong, nonatomic) UIImageView *chioceView;
@end
bool gMark = false;
@implementation PostQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title =@"我要提问";
    self.typeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.typeBtn.layer.masksToBounds = YES;
    self.typeBtn.layer.borderColor = HEXCOLOR(@"cdcdcd").CGColor;
    self.typeBtn.layer.borderWidth = 0.5;
    self.typeBtn.layer.cornerRadius = 3;
    self.codeId = @(-1);
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.cornerRadius = 3;
    if(IOS_SYSTEM_VERSION >= 7.f)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor  = HEXCOLOR(@"f5f5f5");
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderColor = HEXCOLOR(@"cdcdcd").CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.cornerRadius = 3;
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDismissKeyboard:)];
    [self.view addGestureRecognizer:gesture];
    
    self.textView.text = @"请输入服务内容...";
    self.textView.delegate = self;
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initWithAshen];
}

//- (void)viewDidLayoutSubviews {
//    //if (!gMark) {
//
//        [self initWithAshen];
//        //gMark = true;
//    //}
//}

/********************Ashen****************************/
- (void) initWithAshen {
    NSLog(@"%f",_typeBtn.frame.origin.y);
    _typeBtn.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_typeBtn.frame.origin.x + _typeBtn.frame.size.width / 6 * 5 , _typeBtn.frame.origin.y, 0.5, _typeBtn.frame.size.height)];
    line.backgroundColor = HEXCOLOR(@"cdcdcd");
    [self.view addSubview:line];
    
    _chioceView = [[UIImageView alloc] initWithFrame:CGRectMake(_typeBtn.frame.origin.x + _typeBtn.frame.size.width / 6 * 5 + (_typeBtn.frame.size.width / 6 - 20) / 2, _typeBtn.frame.origin.y + (_typeBtn.frame.size.height - 20) / 2, 20, 20)];
    [_chioceView setImage:[UIImage imageNamed:@"button_arrow_down"]];
    
    [self.view addSubview:_chioceView];
    
    [self.textView setFrame:CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, self.textView.frame.size.height / 3 * 2)];
    self.textView.textColor = [UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000];
    
    
    [self.commitBtn setFrame:CGRectMake(self.commitBtn.frame.origin.x, CGRectGetMaxY(self.textView.frame) + self.commitBtn.frame.size.height, self.commitBtn.frame.size.width, self.commitBtn.frame.size.height)];
}

#pragma mark - UITextViewDelegate Method
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.textView.text  isEqual: @"请输入服务内容..."]) {
        self.textView.text = @"";
        self.textView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([self.textView.text  isEqual: @""]) {
        self.textView.textColor = [UIColor colorWithRed:156.0/255.0f green:156.0/255.0f blue:156.0/255.0f alpha:1.000];
        self.textView.text = @"请请输入服务内容...";
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showType:(id)sender {
    UIActionSheet* action =[[UIActionSheet alloc]initWithTitle:@"请选择标签" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    action.delegate = self;
    for (NSDictionary* dic in self.qAndAType) {
        [action addButtonWithTitle:dic[@"name"]];
    }
    [action showInView:self.view];
}

-(void)tapDismissKeyboard:(UITapGestureRecognizer*)gesture
{
    [self.textView resignFirstResponder];
}

- (IBAction)commitQuestion:(id)sender {
    if (self.textView.text.length == 0) {
        [self showNormalHudDimissWithString:@"请填写问题"];
        return;
    }
    if (self.codeId.integerValue == -1) {
        [self showNormalHudDimissWithString:@"请选择标签"];
        return;
    }
    UIView* hud = [self showNormalHudNoDimissWithString:@"提交中，请稍等"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_PROBLEM With:@{@"action":@"save",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"codeId":self.codeId,@"content":self.textView.text} success:^(NSDictionary *responseObj, NSString *timeSp) {
        hud.tag = 1;
        [self dismissHUD:hud WithSuccessString:@"完成"];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:hud WithSuccessString:@"失败"];
    }];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=actionSheet.cancelButtonIndex) {
        self.codeId = self.qAndAType[buttonIndex-1][@"id"];
        [self.typeBtn setTitle:self.qAndAType[buttonIndex-1][@"name"] forState:UIControlStateNormal];
    }
}
-(void)progressHUD:(JGProgressHUD *)progressHUD didDismissFromView:(UIView *)view
{
    if (progressHUD.tag == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
