//
//  LxPigViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/11.
//
//

#import "LxPigViewController.h"
#import "NetWorkClient.h"
#import "SVPullToRefresh.h"

@interface LxPigViewController ()

@property (nonatomic,strong)NSMutableArray* operationTimeSpArray;

@end

@implementation LxPigViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)addBackButton
{
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:BackButtomImageName] forState:UIControlStateNormal];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton addTarget:self action:@selector(popBackController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                               target:self
                                                                               action:nil];
    flexSpacer.width = -10;
    [self.navigationItem setLeftBarButtonItems:@[flexSpacer,backItem]];
}

-(void)addCancelButton
{
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissController:)];
    [self.navigationItem setLeftBarButtonItem:cancelItem];
}

-(IBAction)popBackController:(id)sender
{
    [self cancelAllOperation];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)dismissController:(id)sender
{
    [self cancelAllOperation];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelAllOperation
{
    for (NSString* timeSp in self.operationTimeSpArray) {
        [[NetWorkClient shareInstance]cancelWithTimeSp:timeSp];
    }
}


@end
