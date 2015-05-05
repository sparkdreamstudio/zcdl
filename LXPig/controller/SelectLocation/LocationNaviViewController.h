//
//  LocationNaviViewController.h
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import <UIKit/UIKit.h>

@interface Location : NSObject
@property (nonatomic,strong) NSString* province;
@property (nonatomic,strong) NSString* city;
@property (nonatomic,strong) NSString* district;
@end

@interface LocationNaviViewController : UINavigationController
@property (nonatomic,weak) Location* location;
@property (nonatomic,strong) Location* temp;

@end
