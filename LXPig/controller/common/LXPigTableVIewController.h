//
//  LXPigTableVIewController.h
//  LXPig
//
//  Created by leexiang on 15/4/11.
//
//

#import <UIKit/UIKit.h>

@interface LXPigTableVIewController : UITableViewController


-(void)addBackButton;
-(void)addCancelButton;

-(void)addPullRefresh;
-(void)pullRfresh;
/**
 *  添加上拉刷新更多，默认关闭上啦刷新，根据返回数据启动
 */
-(void)addInfinitScorll;
-(void)infinitScorll;

-(void)stopPull;
-(void)stopInfinitScorll;
-(void)startRefresh;
-(void)setPullViewHidden:(BOOL)hidden;
-(void)setInfinitScorllHidden:(BOOL)hidden;
-(BOOL)showInfinitScorll;
@end
