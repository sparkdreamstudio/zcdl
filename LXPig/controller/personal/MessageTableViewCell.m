//
//  MessageTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/6/9.
//
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell ()

@property (weak,nonatomic) IBOutlet UILabel* timeLabel;
@property (weak,nonatomic) IBOutlet UILabel* contentLabel;
@property (weak,nonatomic) IBOutlet UIView*  unreadView;
@property (weak,nonatomic) IBOutlet UIView*  coverView;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint* rightContraint;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint* leftContraint;
@property (weak,nonatomic) IBOutlet UIButton* cancelButton;

@property (assign,nonatomic) BOOL deleteModel;
@property (strong,nonatomic) UITapGestureRecognizer* tap;
@property (strong,nonatomic) UISwipeGestureRecognizer* swipeLeft;
@property (strong,nonatomic) UISwipeGestureRecognizer* swipeRight;
@end

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.unreadView.layer.masksToBounds = YES;
    self.unreadView.layer.cornerRadius = 5;
    self.deleteModel = NO;
    
    self.coverView.userInteractionEnabled = YES;
    self.swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture:)];
    [self.swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.coverView addGestureRecognizer:self.swipeLeft];
    
    self.swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture:)];
    [self.swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.coverView addGestureRecognizer:self.swipeRight];
    
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
}

-(void)prepareForReuse
{
    if (self.deleteModel == YES) {
        [self.coverView removeGestureRecognizer:self.tap];
    }
    self.deleteModel = NO;
    self.rightContraint.constant = 0;
    self.leftContraint.constant = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadData:(NSDictionary *)dic
{
    self.timeLabel.text = [dic objectForKey:@"createTime"];
    self.contentLabel.text = [dic objectForKey:@"content"];
}

-(IBAction)deleteBtnClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageTableViewCellDelete:)]) {
        [self.delegate messageTableViewCellDelete:self];
    }
}

-(void)swipeGesture:(UISwipeGestureRecognizer*)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.deleteModel == NO) {
            POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
            animation.toValue = @(self.cancelButton.frame.size.height);
            [self.rightContraint pop_addAnimation:animation forKey:@"startDelete"];
            
            animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
            animation.toValue = @(-self.cancelButton.frame.size.height);
            [self.leftContraint pop_addAnimation:animation forKey:@"startDelete"];
            
            self.deleteModel = YES;
            [self.coverView addGestureRecognizer:self.tap];
        }
    }
    else if(gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if (self.deleteModel == YES) {
            POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
            animation.toValue = @(0);
            [self.rightContraint pop_addAnimation:animation forKey:@"closeDelete"];
            animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
            animation.toValue = @(0);
            [self.leftContraint pop_addAnimation:animation forKey:@"closeDelete"];
            self.deleteModel = NO;
            [self.coverView removeGestureRecognizer:self.tap];
        }
    }
}

-(void)tapGesture:(UITapGestureRecognizer*)gesture
{
    POPBasicAnimation* animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    animation.toValue = @(0);
    [self.rightContraint pop_addAnimation:animation forKey:@"closeDelete"];
    animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    animation.toValue = @(0);
    [self.leftContraint pop_addAnimation:animation forKey:@"closeDelete"];
    self.deleteModel = NO;
    [self.coverView removeGestureRecognizer:self.tap];
}

@end
