//
//  ViewPaperViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/5.
//
//

#import "ViewPaperViewController.h"

@interface ViewPaperViewController ()

@end

@implementation ViewPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    JGProgressHUD *hud = [self showProgressHudNoDimissWithString:@"下载图片中"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
