//
//  PersonalInfoViewController.m
//  LXPig
//
//  Created by leexiang on 15/4/29.
//
//

#import "PersonalInfoViewController.h"
#import "ChangeInfoViewController.h"

@interface PersonalInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sexual;


@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 25;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[[UserManagerObject shareInstance]photoFile]] placeholderImage:nil];
    self.name.text = [[UserManagerObject shareInstance] name];
    self.nickName.text = [[UserManagerObject shareInstance]nickName];
    self.sexual.text = [[[UserManagerObject shareInstance]sex]integerValue]==0?@"男":@"女";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片库",@"相机", nil];
                sheet.tag = 2;
                [sheet showInView:self.view];
                break;
            }
            case 1:
                [self performSegueWithIdentifier:@"change_property" sender:@{@"nickName":@"修改昵称"}];
                break;
            case 2:
                [self performSegueWithIdentifier:@"change_property" sender:@{@"name":@"修改姓名"}];
                break;
            case 3:
            {
                UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
                sheet.tag = 1;
                [sheet showInView:self.view];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - action sheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=actionSheet.cancelButtonIndex) {
        switch (actionSheet.tag) {
            
            case 1:
            {
                UIView* hud = [self showNormalHudNoDimissWithString:@"提交信息中"];
                [[UserManagerObject shareInstance]changeInfo:@"sex" Value:[NSString stringWithFormat:@"%ld",(long)buttonIndex] Success:^(NSDictionary *responseObj, NSString *timeSp) {
                    [self dismissHUD:hud];
                    self.sexual.text = [[[UserManagerObject shareInstance]sex]integerValue]==0?@"男":@"女";
                } failure:^(NSDictionary *responseObj, NSString *timeSp) {
                    if (responseObj) {
                        [self dismissHUD:hud WithErrorString:[responseObj objectForKey:@"message"]];
                    }
                    else
                    {
                        [self dismissHUD:hud WithErrorString:@"网络不给力哦"];
                    }
                }];
                break;
            }
            case 2:
            {
                
                UIImagePickerController* controller =[self showImagePickerByType:buttonIndex];
                controller.delegate = self;
                [self presentViewController:controller animated:YES completion:nil];
                
                break;
            }
            default:
                break;
        }
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"change_property"])
    {
        NSDictionary* dic = sender;
        ChangeInfoViewController* controller = [segue destinationViewController];
        controller.property = dic.allKeys[0];
        controller.controllerTitle = dic.allValues[0];
    }
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UserManagerObject shareInstance]changeHeadImage:[Utils imageWithImage:[info objectForKey:UIImagePickerControllerOriginalImage] scaledToSize:CGSizeMake(100, 100)] Success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self.tableView reloadData];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        
    }];
}

@end
