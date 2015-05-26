//
//  InfoViewTypeCustomTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/10.
//
//

#import "InfoViewTypeCustomTableViewController.h"
#import "SKTagView.h"
#import "InfoViewCustomTableViewCell.h"
#import "NetWorkClient.h"
#import "InfoViewController.h"
@interface InfoViewTypeCustomTableViewController ()<UIAlertViewDelegate>
@property (strong,nonatomic)NSArray* focusArray;
@property (strong,nonatomic)NSArray* unFocusArray;
@property (assign,nonatomic) BOOL reloadInfoView;
@end

@implementation InfoViewTypeCustomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.title =@"自定义栏目";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HEXCOLOR(@"f8f8f8");
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoViewCustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
    [self loadCustom];
    self.reloadInfoView = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.reloadInfoView) {
        [self.controller loadNews];
    }
    
}

-(void)loadCustom
{
    [[NetWorkClient shareInstance]postUrl:SERVICE_FOCUSNEWS With:@{@"action":@"list",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"type":@"0"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        self.unFocusArray = [responseObj objectForKey:@"data"];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
    [[NetWorkClient shareInstance]postUrl:SERVICE_FOCUSNEWS With:@{@"action":@"list",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"type":@"1"} success:^(NSDictionary *responseObj, NSString *timeSp) {
        self.focusArray = [responseObj objectForKey:@"data"];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configureCell:(InfoViewCustomTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.tagView.preferredMaxLayoutWidth = SCREEN_WIDTH;
    cell.tagView.padding    = UIEdgeInsetsMake(9, 12, 9, 12);
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor whiteColor];
        cell.tagView.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor = HEXCOLOR(@"f8f8f8");
        cell.tagView.backgroundColor = HEXCOLOR(@"f8f8f8");
    }
    cell.tagView.insets    = 15;
    cell.tagView.lineSpace = 16;
    cell.tagView.didClickTagAtIndex = ^(NSUInteger index){
        
    };
    [cell.tagView removeAllTags];
    NSMutableArray* tagStringArray = [NSMutableArray array];
    NSArray* tagArray = nil;
    if (indexPath.section == 0) {
        tagArray = self.focusArray;
        [cell.tagView setDidPressLongTagAtIndex:^(NSUInteger index) {
            NSDictionary* dic = self.focusArray[index];
            UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定删除栏目%@?",dic[@"name"]]delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
            view.tag = [dic[@"id"] integerValue];
            [view show];
//            NSDictionary* dic = self.focusArray[index];
//            [[NetWorkClient shareInstance]postUrl:SERVICE_FOCUSNEWS With:@{@"action":@"delete",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"codeId":dic[@"id"]} success:^(NSDictionary *responseObj, NSString *timeSp) {
//                [self loadCustom];
//                self.reloadInfoView = YES;
//            } failure:^(NSDictionary *responseObj, NSString *timeSp) {
//            }];
        }];
    }
    else
    {
        tagArray = self.unFocusArray;
        [cell.tagView setDidClickTagAtIndex:^(NSUInteger index) {
            NSDictionary* dic = self.unFocusArray[index];
            [[NetWorkClient shareInstance]postUrl:SERVICE_FOCUSNEWS With:@{@"action":@"save",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"codeId":dic[@"id"]} success:^(NSDictionary *responseObj, NSString *timeSp) {
                [self loadCustom];
                self.reloadInfoView = YES;
            } failure:^(NSDictionary *responseObj, NSString *timeSp) {
            }];
        }];
    }
    [tagArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        [tagStringArray addObject:[obj objectForKey:@"name"]];
    }];
    //    //Add Tags
    [tagStringArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         SKTag *tag = [SKTag tagWithText:obj];
         tag.textColor = HEXCOLOR(@"3d4852");
         tag.fontSize = 15;
         tag.padding = UIEdgeInsetsMake(8, 8, 8, 8);
         tag.bgImg = [Utils imageWithColor:HEXCOLOR(@"f3f3f3")];
         tag.borderColor = HEXCOLOR(@"cdcdcd");
         tag.borderWidth = 1;
         tag.cornerRadius = 5;
         
         [cell.tagView addTag:tag];
     }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[NetWorkClient shareInstance]postUrl:SERVICE_FOCUSNEWS With:@{@"action":@"delete",@"sessionid":[[UserManagerObject shareInstance]sessionid],@"codeId":[NSNumber numberWithInteger:alertView.tag]} success:^(NSDictionary *responseObj, NSString *timeSp) {
            [self loadCustom];
            self.reloadInfoView = YES;
        } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        }];
    }
}

#pragma mark - Table view data source

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        UILabel* label = [[UILabel alloc]init];
        label.text = @"已展示项目";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = HEXCOLOR(@"848484");
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:label];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:15]];
        return view;
    }
    else
    {
        UIView* view = [[UIView alloc]init];
        view.backgroundColor = HEXCOLOR(@"f8f8f8");
        UILabel* label = [[UILabel alloc]init];
        label.text = @"点击添加更多项目项目";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = HEXCOLOR(@"848484");
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:label];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:15]];
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoViewCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
    
    [self configureCell:cell atIndexPath:indexPath];
    return [cell.tagView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoViewCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
