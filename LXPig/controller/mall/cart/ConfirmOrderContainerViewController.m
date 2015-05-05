//
//  ConfirmOrderContainerViewController.m
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import "ConfirmOrderContainerViewController.h"
#import "ConfirmOrderTableViewController.h"
#import "PigCart.h"
#import "NetWorkClient.h"
#import "AddressManager.h"
@interface ConfirmOrderContainerViewController ()<NSURLConnectionDelegate>
@property (weak,nonatomic)ConfirmOrderTableViewController* controller;
@property (weak,nonatomic)IBOutlet UILabel* totalPrice;
@property (strong,nonatomic) NSMutableData* receiveData;
@end

@implementation ConfirmOrderContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSInteger price = 0;
    for (CartItems* items in [[PigCart shareInstance]itemsArray]) {
        for (CartItem *item in items.itemlist) {
            if (item.selected) {
                price += ([item.salePrice integerValue] *[item.num integerValue]);
            }

        }
    }
    self.totalPrice.text  =[NSString stringWithFormat:@"%ld",(long)price];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)cofirmOrder:(id)sender
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setValue:@"save" forKey:@"action"];
    [params setValue:[self getJson] forKey:@"data"];
    [params setValue:[[UserManagerObject shareInstance]sessionid] forKey:@"sessionid"];
    UIView* view = [self.parentViewController showNormalHudNoDimissWithString:@"提交订单"];
    [[NetWorkClient shareInstance]postUrl:SERVICE_ORDER With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:view WithSuccessString:[responseObj objectForKey:@"message"]];
        [self.view setHidden:YES];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self dismissHUD:view WithErrorString:[responseObj objectForKey:@"message"]];
    }];

}



-(NSString*)getJson
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    
    [dic setValue:[NSNumber numberWithLongLong:self.controller.address.keyId] forKey:@"shipAddressId"];
    NSMutableArray* item1 = [NSMutableArray array];
    
    for (ConfirmOrderItems *items in self.controller.arrayProduct) {
        NSMutableDictionary* item1Dic = [NSMutableDictionary dictionaryWithDictionary:@{@"enterpriseId":items.enterpriseKeyId,@"note":items.note,@"isTestService":[NSNumber numberWithInteger:items.isTestService]}];
        
        NSMutableArray*item2 = [NSMutableArray array];
        for (ConfirmOrderItem* item in items.itemlist) {
            [item2 addObject:@{@"productId":[NSNumber numberWithLongLong:item.keyId],@"num":item.num}];
        }
        [item1Dic setValue:item2 forKey:@"list2"];
        [item1 addObject:item1Dic];
    }
    [dic setValue:item1 forKey:@"list1"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:nil];
    NSMutableString *str =  [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *character = nil;
    for (int i = 0; i < str.length; i ++) {
        character = [str substringWithRange:NSMakeRange(i, 1)];
        if ([str isEqualToString:@"\\"])
            [str deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    return str;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"confirm_order_table"]) {
        self.controller = [segue destinationViewController];
    }
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    
    NSLog(@"%@",[res allHeaderFields]);
    
    self.receiveData = [NSMutableData data];
    
    
    
    
    
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    
    [self.receiveData appendData:data];
    
}

//数据传完之后调用此方法

-(void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    
    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",receiveStr);
    
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法

-(void)connection:(NSURLConnection *)connection

 didFailWithError:(NSError *)error

{
    
    NSLog(@"%@",[error localizedDescription]);
}

@end
