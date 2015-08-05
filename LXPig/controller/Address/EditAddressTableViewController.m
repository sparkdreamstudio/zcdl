//
//  EditAddressTableViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import "EditAddressTableViewController.h"
#import "LocationNaviViewController.h"
@interface EditAddressTableViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *contact;
@property (weak, nonatomic) IBOutlet UITextField *moble;

@property (weak, nonatomic) IBOutlet UITextField *detailAddress;
@property (weak, nonatomic) IBOutlet UILabel *city;
//@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (strong,nonatomic) Location* location;
@end

@implementation EditAddressTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.address==nil)
    {
        self.address = [[Address alloc]init];
        self.temp = [[Address alloc]init];
        
    }
    else
    {
        
        self.temp = [[Address alloc]init];
        self.temp.keyId = self.address.keyId;
        self.temp.contact = self.address.contact;
        self.temp.tel  = self.address.tel;
//        self.temp.zipcode = self.address.zipcode;
        self.temp.province = self.address.province;
        self.temp.city = self.address.city;
        self.temp.district = self.address.district;
        self.temp.address = self.address.address;
        self.temp.isDefault = self.address.isDefault;
    }
    self.location = [[Location alloc]init];
    [self.location addObserver:self forKeyPath:@"district" options:NSKeyValueObservingOptionNew context:nil];
    // Do any additional setup after loading the view.
}
-(void)dealloc
{
    [self.location removeObserver:self forKeyPath:@"district"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"district"])
    {
        self.temp.province = self.location.province;
        self.temp.city = self.location.city;
        self.temp.district = self.location.district;
        [self loadAddress];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    
}

-(void)loadAddress
{
    self.contact.text = self.temp.contact;
    self.moble.text = self.temp.tel;
    self.detailAddress.text = self.temp.address;
    self.city.text = [NSString stringWithFormat:@"%@%@%@",self.temp.province,self.temp.city,self.temp.district];
//    self.code.text = self.temp.zipcode;
    self.checkBtn.selected = self.temp.isDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//{
//    NSMutableString *tempString = [NSMutableString stringWithString:textField.text];
//    [tempString replaceCharactersInRange:range withString:string];
//    if (textField == self.contact) {
//        self.temp.contact = tempString;
//    }
//    else if (textField == self.moble)
//    {
//        self.temp.tel = tempString;
//    }
//    else if (textField == self.detailAddress)
//    {
//        self.temp.address = tempString;
//    }
//    else if (textField == self.code)
//    {
//        self.temp.zipcode = tempString;
//    }
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.contact) {
        self.temp.contact = textField.text;
    }
    else if (textField == self.moble)
    {
        self.temp.tel = textField.text;
    }
    else if (textField == self.detailAddress)
    {
        self.temp.address = textField.text;
    }
//    else if (textField == self.code)
//    {
//        self.temp.zipcode = textField.text;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        if (self.checkBtn.isSelected) {
            [self.checkBtn setSelected:NO];
        }
        else
        {
            [self.checkBtn setSelected:YES];
        }
        self.temp.isDefault = self.checkBtn.isSelected;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"address_select_location"])
    {
        LocationNaviViewController* controller = [segue destinationViewController];
        controller.location = self.location;
    }
}


@end
