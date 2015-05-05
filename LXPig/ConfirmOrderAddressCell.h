//
//  ConfirmOrderAddressCell.h
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import <UIKit/UIKit.h>

@class Address;

@interface ConfirmOrderAddressCell : UITableViewCell

-(void)loadAddress:(Address*)address;

@end
