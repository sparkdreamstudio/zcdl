//
//  EditAddressTableViewController.h
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import "LXPigTableVIewController.h"
#import "AddressManager.h"
@interface EditAddressTableViewController : LXPigTableVIewController
@property (strong,nonatomic)Address* address;
@property (strong,nonatomic)Address* temp;
-(void)loadAddress;
@end
