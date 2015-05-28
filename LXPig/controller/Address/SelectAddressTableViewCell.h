//
//  SelectAddressTableViewCell.h
//  LXPig
//
//  Created by 李响 on 15/5/28.
//
//

#import <UIKit/UIKit.h>
@class Address;
@interface SelectAddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
-(void)loadAddress:(Address*)address;
@end
