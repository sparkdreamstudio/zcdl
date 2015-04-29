//
//  AddressManageTableViewCell.h
//  LXPig
//
//  Created by leexiang on 15/4/30.
//
//

#import <UIKit/UIKit.h>
@class Address;
@interface AddressManageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
-(void)loadAddress:(Address*)address;
@end
