//
//  ViewController.h
//  LXPig
//
//  Created by leexiang on 15/4/6.
//
//

#import <UIKit/UIKit.h>

@interface MallHomeController : LXPigTableVIewController

//产品参数
@property (nonatomic,strong)    NSString* keyWord;
@property (nonatomic,strong)    NSNumber* enterpriseId;
@property (nonatomic,strong)    NSNumber* codeId;
@property (nonatomic,strong)    NSNumber* orderList;

@end

