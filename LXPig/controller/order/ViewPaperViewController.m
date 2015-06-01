//
//  ViewPaperViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/5.
//
//

#import "ViewPaperViewController.h"
#import "NetWorkClient.h"
@interface ViewPaperViewController ()<JGProgressHUDDelegate>

@end

@implementation ViewPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title = @"票据";
    if (self.orderTag != 3 && self.orderTag != 4) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteImage:)];
    }
    
    // Do any additional setup after loading the view.
}

-(void)deleteImage:(UIBarButtonItem*)item
{
    UIView* hud = [self showNormalHudNoDimissWithString:@"删除票据"];
    [[NetWorkClient shareInstance] postUrl:SERVICE_PAPER With:@{@"action":@"delete",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"id":self.paperInfo[@"id"]}  success:^(NSDictionary *dic, NSString *timeSp) {
        hud.tag = 1;
        [self dismissHUD:hud WithSuccessString:@"删除成功"];

        NSLog(@"%@",[dic objectForKey:@"message"]);
    } failure:^(NSDictionary *dic, NSString *timeSp) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        [self dismissHUD:hud WithSuccessString:[dic objectForKey:@"message"]];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    JGProgressHUD *hud = [self showProgressHudNoDimissWithString:@"下载票据中"];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.paperInfo[@"img"]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        hud.progress = receivedSize/((CGFloat)expectedSize);
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (error == nil) {
            [hud dismiss];
            VIPhotoView *photoView = [[VIPhotoView alloc] initWithFrame:self.view.bounds andImage:image];
            photoView.autoresizingMask = (1 << 6) -1;
            [self.view addSubview:photoView];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
