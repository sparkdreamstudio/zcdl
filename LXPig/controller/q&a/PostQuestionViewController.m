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

@end

@implementation PostQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title =@"我要提问";
    self.typeBtn.layer.masksToBounds = YES;
    self.typeBtn.layer.borderColor = HEXCOLOR(@"cdcdcd").CGColor;
    self.typeBtn.layer.borderWidth = 1;
    self.typeBtn.layer.cornerRadius = 1;
    self.codeId = @(-1);
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.cornerRadius = 1;
    if(IOS_SYSTEM_VERSION >= 7.f)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor  = HEXCOLOR(@"f5f5f5");
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderColor = HEXCOLOR(@"cdcdcd").CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 1;
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDismissKeyboard:)];
    [self.view addGestureRecognizer:gesture];
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
