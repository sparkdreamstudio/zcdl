//
//  ProductCommentController.m
//  LXPig
//
//  Created by leexiang on 15/4/23.
//
//

#import "ProductCommentController.h"
#import "NetWorkClient.h"
#import "SKTagView.h"
#import "CommentTagCell.h"
#import "ProductCommentCell.h"
#import <Masonry/Masonry.h>
#define DEFAULT_TAG @"全部"
@interface ProductCommentController () 
@property (strong,nonatomic)NSString* currentTagString;
@property (strong,nonatomic)NSMutableArray* commentArray;
@property (strong,nonatomic)NSArray* tagArray;
@property (assign,nonatomic)NSInteger currentPage;
@property (assign,nonatomic)NSInteger tagHeight;
@end

@implementation ProductCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPullRefresh];
    [self addInfinitScorll];
    [self startRefresh];
    self.tagHeight = 1;
    //[self.tableView registerClass:[ProductCommentCell class] forCellReuseIdentifier:@"cell0"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

-(void)pullRfresh
{
    _currentPage = 1;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"list",@"currentPageNo":[NSNumber numberWithInteger:self.currentPage],@"pageSize":@"20",@"productId":[NSNumber numberWithLongLong:self.productId]}];
    if (self.currentTagString) {
        [params setValue:self.currentTagString forKey:@"label"];
    }
    __weak ProductCommentController* weakself = self;
    [[NetWorkClient shareInstance]postUrl:SERVICE_COMMENT With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [weakself stopPull];
        
        weakself.tagArray = [responseObj[@"data"] valueForKey:@"labelList"];
        weakself.commentArray = [responseObj[@"data"] valueForKey:@"commentList"];
        if (weakself.commentArray.count < 20) {
            [weakself setInfinitScorllHidden:YES];
        }
        else{
            [weakself setInfinitScorllHidden:NO];
        }
        [weakself.tableView reloadData];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [weakself stopPull];
    }];
}

-(void)infinitScorll
{
    _currentPage = 1;
    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithDictionary:@{@"action":@"list",@"currentPageNo":[NSNumber numberWithInteger:self.currentPage],@"pageSize":@"20",@"productId":[NSNumber numberWithLongLong:self.productId]}];
    if (self.currentTagString) {
        [params setValue:self.currentTagString forKey:@"label"];
    }
    __weak ProductCommentController* weakself = self;
    [[NetWorkClient shareInstance]postUrl:SERVICE_COMMENT With:params success:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopInfinitScorll];
        NSArray *array = [responseObj[@"data"] valueForKey:@"commentList"];
        if (array.count < 20) {
            [weakself setInfinitScorllHidden:YES];
        }
        else{
            [weakself setInfinitScorllHidden:NO];
        }
        if (array.count == 0) {
            return ;
        }
        
        weakself.tagArray = [responseObj[@"data"] valueForKey:@"labelList"];
        [weakself.commentArray addObjectsFromArray:array];
        NSMutableArray* arrayIndexPath = [NSMutableArray array];
        for (NSUInteger i = weakself.commentArray.count-array.count; i < array.count; i++) {
            [arrayIndexPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [arrayIndexPath addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:arrayIndexPath withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    } failure:^(NSDictionary *responseObj, NSString *timeSp) {
        [self stopInfinitScorll];
    }];
}

- (void)configureCell:(CommentTagCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.tagView.preferredMaxLayoutWidth = SCREEN_WIDTH;
    cell.tagView.padding    = UIEdgeInsetsMake(9, 8, 9, 8);
    cell.tagView.backgroundColor = [UIColor colorWithRed:0xf5/255.f green:0xf5/255.f blue:0xf5/255.f alpha:1];
    cell.tagView.insets    = 6;
    cell.tagView.lineSpace = 8;
    cell.tagView.didClickTagAtIndex = ^(NSUInteger index){
        
    };
    [cell.tagView removeAllTags];
    [cell.tagView setDidClickTagAtIndex:^(NSUInteger i) {
        self.currentTagString = [[self.tagArray objectAtIndex:i] valueForKey:@"label"];
        [self startRefresh];
    }];
    NSMutableArray* tagStringArray = [NSMutableArray array];
    __block NSInteger selectedIndex = -1;
    [self.tagArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString* string = [[obj valueForKey:@"label"] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if ([self.currentTagString isEqualToString:string]) {
            selectedIndex = idx;
        }
        [tagStringArray addObject:[NSString stringWithFormat:@"%@( %ld )",string,(long)[[obj valueForKey:@"cnt"] integerValue]]];
    }];
//    //Add Tags
    [tagStringArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         SKTag *tag = [SKTag tagWithText:obj];
         tag.textColor = [UIColor colorWithRed:0x5a/255.f green:0x63/255.f blue:0x6c/255.f alpha:1];
         tag.fontSize = 10;
         tag.selectedTextColor = [UIColor whiteColor];;
         tag.padding = UIEdgeInsetsMake(7, 10, 7, 10);
         tag.bgImg = [Utils imageWithColor:[UIColor colorWithRed:0xfe/255.f green:0xfe/255.f blue:0xfe/255.f alpha:1]];
         tag.selectedBgImg = [Utils imageWithColor:NavigationBarColor];
         tag.borderColor = [UIColor colorWithRed:0xd5/255.f green:0xd5/255.f blue:0xd5/255.f alpha:1];
         tag.borderWidth = 1;
         tag.cornerRadius = 4;
         if (idx == selectedIndex) {
             tag.selected = YES;
         }
         [cell.tagView addTag:tag];
     }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count ==0?0:(self.commentArray.count + 1);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CommentTagCell *cell = nil;
        if (!cell)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell0"];
        }
        
        [self configureCell:cell atIndexPath:indexPath];
        CGFloat height= [cell.tagView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
        
        return height;
    }
    else
    {
        if ([[self.commentArray[indexPath.row - 1] valueForKey: @"replyContent"] length] > 0) {
            return 123+[Utils getSizeOfString:[self.commentArray[indexPath.row - 1] valueForKey: @"content"] WithSize:CGSizeMake(SCREEN_WIDTH-24, NSIntegerMax) AndSystemFontSize:13].height + [Utils getSizeOfString:[NSString stringWithFormat:@"【客服回复】%@",[self.commentArray[indexPath.row - 1] valueForKey: @"replyContent"]] WithSize:CGSizeMake(SCREEN_WIDTH-24, NSIntegerMax) AndSystemFontSize:12].height;
        }
        else
        {
            return 110+[Utils getSizeOfString:[self.commentArray[indexPath.row - 1] valueForKey: @"content"] WithSize:CGSizeMake(SCREEN_WIDTH-24, NSIntegerMax) AndSystemFontSize:13].height;
        }
//<<<<<<< Updated upstream
        
//=======
//        return 110+[Utils getSizeOfString:[self.commentArray[indexPath.row - 1] valueForKey: @"content"] WithSize:CGSizeMake(SCREEN_WIDTH-24, NSIntegerMax) AndSystemFontSize:14].height;
//>>>>>>> Stashed changes
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CommentTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
    else
    {
        ProductCommentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        NSDictionary* dic = self.commentArray[indexPath.row - 1];
//        NSString * string =  [dic[@"members"] objectForKey:@"userName"];
        if ([[dic[@"members"] objectForKey:@"nickName"] length]>0) {
            cell.name.text = [dic[@"members"] objectForKey:@"nickName"];
        }
        else
        {
            NSMutableString* str = [NSMutableString stringWithString:[dic[@"members"] objectForKey:@"userName"]];
            [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            cell.name.text = str;
        }
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:/112.74.98.66:8080%@",[dic[@"members"] objectForKey:@"photoPath"]]] placeholderImage:[UIImage imageNamed:@"user_default"]];
        cell.date.text = dic[@"date"];
        cell.comment.text = dic[@"content"];
        cell.commentHeight.constant = [Utils getSizeOfString:dic[@"content"] WithSize:CGSizeMake(SCREEN_WIDTH-24, NSIntegerMax) AndSystemFontSize:13].height;
        if ([dic[@"replyContent"] length] > 0) {
            cell.replyContent.text = [NSString stringWithFormat:@"【客服回复】%@",dic[@"replyContent"]];
            cell.replyContentHeight.constant = [Utils getSizeOfString:[NSString stringWithFormat:@"【客服回复】%@",dic[@"replyContent"]] WithSize:CGSizeMake(SCREEN_WIDTH-24, NSIntegerMax) AndSystemFontSize:12].height;
            cell.seperatorHeight.constant = 13;
        }
        else
        {
            cell.replyContent.text = @"";
            cell.replyContentHeight.constant = 0;
            cell.seperatorHeight.constant = 0;
        }
        NSInteger star = [dic[@"star"] integerValue];
        for (int i = 0; i < 5; i++) {
            switch (i) {
                case 0:
                {
                    if (star>0) {
                        [cell.star0 setImage:[UIImage imageNamed:@"mall_comment_star"]];
                    }
                    else
                    {
                        [cell.star0 setImage:[UIImage imageNamed:@"mall_comment_nostar"]];
                    }
                    break;
                }
                case 1:
                {
                    if (star>1) {
                        [cell.star1 setImage:[UIImage imageNamed:@"mall_comment_star"]];
                    }
                    else
                    {
                        [cell.star1 setImage:[UIImage imageNamed:@"mall_comment_nostar"]];
                    }
                    break;
                }
                case 2:
                {
                    if (star>2) {
                        [cell.star2 setImage:[UIImage imageNamed:@"mall_comment_star"]];
                    }
                    else
                    {
                        [cell.star2 setImage:[UIImage imageNamed:@"mall_comment_nostar"]];
                    }
                    break;
                }
                case 3:
                {
                    if (star>3) {
                        [cell.star3 setImage:[UIImage imageNamed:@"mall_comment_star"]];
                    }
                    else
                    {
                        [cell.star3 setImage:[UIImage imageNamed:@"mall_comment_nostar"]];
                    }
                    break;
                }
                case 4:
                {
                    if (star>4) {
                        [cell.star4 setImage:[UIImage imageNamed:@"mall_comment_star"]];
                    }
                    else
                    {
                        [cell.star4 setImage:[UIImage imageNamed:@"mall_comment_nostar"]];
                    }
                    break;
                }
                    
                default:
                    break;
            }
        }
        
        return cell;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
