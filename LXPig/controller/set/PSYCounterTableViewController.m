//
//  PSYCounterTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/16.
//
//

#import "PSYCounterTableViewController.h"
#import "PSYButtonTableViewCell.h"
#import "PSYCountIntputTableViewCell.h"
#import "PSYResultViewController.h"
@interface PSYCounterTableViewController ()<PSYButtonTableViewCellDelegate,PSYCountIntputTableViewCellDelegate,UIActionSheetDelegate>
{
    NSInteger param0;
    NSInteger param1;
    NSInteger param2;
    NSInteger param3;
    NSInteger param4;
}
@property (weak,nonatomic)UIButton *btn;

@end

@implementation PSYCounterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    param0 = param1 = param2 = param3 = param4 = -1;
    
    [self addBackButton];
    self.title = @"PSY即时计算器";
    self.tableView.backgroundColor = HEXCOLOR(@"f7f7f7");
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    UIView* headerView = [[[NSBundle mainBundle] loadNibNamed:@"PSYCounterHeaderAndFooter" owner:nil options:nil] objectAtIndex:0];
//    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 178.f*375.f/SCREEN_WIDTH);
//    self.tableView.tableHeaderView = headerView;
    
    UIView* footerView = [[[NSBundle mainBundle] loadNibNamed:@"PSYCounterHeaderAndFooter" owner:nil options:nil] objectAtIndex:1];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    UIButton *resultButton =(UIButton*)[footerView viewWithTag:1];
    resultButton.layer.masksToBounds = YES;
    resultButton.layer.cornerRadius = 4;
    [resultButton addTarget:self action:@selector(getResult:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = footerView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PSYButtonTableViewCell" bundle:nil] forCellReuseIdentifier:@"PSYButtonTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PSYCountIntputTableViewCell" bundle:nil] forCellReuseIdentifier:@"PSYCountIntputTableViewCell"];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)psyButtonClickCell:(PSYButtonTableViewCell *)cell
{
    [self.tableView endEditing:YES];
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"选择测定周期" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"一周",@"一月",@"3个月",@"半年",@"一年", nil];
    [sheet showInView:self.view];
}

-(void)psyCountInputCell:(PSYCountIntputTableViewCell *)cell text:(NSString *)text
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case 2:
            param1 = [text integerValue];
            break;
        case 3:
            param2 = [text integerValue];
            break;
        case 4:
            param3 = [text integerValue];
            break;
        case 5:
            param4 = [text integerValue];
            break;
        default:
            break;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        NSArray* array = @[@"一周",@"一月",@"3个月",@"半年",@"一年"];
        [self.btn setTitle:[array objectAtIndex:buttonIndex] forState:UIControlStateNormal];
        param0 = buttonIndex;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 178.f*375.f/SCREEN_WIDTH;
    else
        return 67;
}

-(void)getResult:(UIButton*)btn
{
    if (param0 == -1) {
        [self showNormalHudDimissWithString:@"请选择测定周期"];
    }
    if (param1 == -1) {
        [self showNormalHudDimissWithString:@"请填写存栏母猪数"];
    }
    if (param2 == -1) {
        [self showNormalHudDimissWithString:@"请填写产活仔数"];
    }
    if (param3 == -1) {
        [self showNormalHudDimissWithString:@"请填写产仔窝数"];
    }
    if (param4 == -1) {
        [self showNormalHudDimissWithString:@"请填写断奶仔猪数"];
    }
    NSInteger count = 0;
    switch (param0) {
        case 0:
            count = 52;
            break;
        case 1:
            count = 12;
            break;
        case 2:
            count = 4;
            break;
        case 3:
            count = 2;
            break;
        case 4:
            count = 1;
            break;
        default:
            break;
    }
    CGFloat result1 = ((CGFloat)param2)/((CGFloat)param3);
    CGFloat result2 = 365.f/(((CGFloat)param3*count)/((CGFloat)param1))-114-25;
    CGFloat result3 = ((CGFloat)param4)/((CGFloat)param2);
    CGFloat result4 = ((CGFloat)param3*count)/((CGFloat)param1)*result1*result3;
    PSYResultViewController* controller = [[PSYResultViewController alloc]initWithNibName:@"PSYResultViewController" bundle:nil];
    controller.r1 = result1;
    controller.r2 = result2;
    controller.r3 = result3;
    controller.r4 = result4;
    [self.navigationController pushViewController:controller animated:YES];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0)
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            UIView* view = [[[NSBundle mainBundle] loadNibNamed:@"PSYCounterHeaderAndFooter" owner:nil options:nil] objectAtIndex:0];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.contentView addSubview:view];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        }
        
        return  cell;
    }
    else if (indexPath.row == 1) {
        PSYButtonTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PSYButtonTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        self.btn = cell.textButton;
        return cell;
    }
    else{
        PSYCountIntputTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PSYCountIntputTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        switch (indexPath.row) {
            case 2:
                cell.title.text = @"存栏母猪数";
                break;
            case 3:
                cell.title.text = @"单位时间产活仔数";
                break;
            case 4:
                cell.title.text = @"单位时间产仔窝数";
                break;
            case 5:
                cell.title.text = @"单位时间断奶仔猪数";
                break;
            default:
                break;
        }
        return cell ;
    }
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
