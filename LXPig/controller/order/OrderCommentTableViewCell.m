//
//  OrderCommentTableViewCell.m
//  LXPig
//
//  Created by leexiang on 15/5/7.
//
//

#import "OrderCommentTableViewCell.h"
#import "EDStarRating.h"

#define PLACE_HOLDER @"请填写您的宝贵意见..."
@implementation CommentObject

-(id)init
{
    self = [super init];
    if (self) {
        self.priceStar = 5;
        self.ruttingStar = 5;
        self.serviceStar = 5;
        self.content = @"";
    }
    return self;
}

@end

@interface OrderCommentTableViewCell () <EDStarRatingProtocol,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *productImgView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *salePrice;
@property (weak, nonatomic) IBOutlet UILabel *orderCnt;

@property (weak, nonatomic) IBOutlet UIButton *tagBtn;
@property (weak, nonatomic) IBOutlet EDStarRating *priceRating;
@property (weak, nonatomic) IBOutlet UILabel *priceRatingLabel;
@property (weak, nonatomic) IBOutlet EDStarRating *faqingRating;
@property (weak, nonatomic) IBOutlet UILabel *faqingRatingLabel;

@property (weak, nonatomic) IBOutlet EDStarRating *serviceRating;
@property (weak, nonatomic) IBOutlet UILabel *serviceRatingLable;
@end

@implementation OrderCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setRatingApperance:self.priceRating];
    [self setRatingApperance:self.faqingRating];
    [self setRatingApperance:self.serviceRating];
    
    self.comment.backgroundColor = [UIColor colorWithRed:0xfa/255.f green:0xfa/255.f blue:0xfa/255.f alpha:1];
    self.comment.layer.masksToBounds= YES;
    self.comment.layer.borderColor = [UIColor colorWithRed:0xcd/255.f green:0xcd/255.f blue:0xcd/255.f alpha:1].CGColor;
    self.comment.layer.borderWidth =1;
    self.comment.layer.cornerRadius = 5;
    self.comment.delegate = self;
    self.comment.text = PLACE_HOLDER;
    self.comment.textColor = HEXCOLOR(@"CDCDCD");
    //[self.tagBtn setTitle:@"请选择" forState:UIControlStateNormal];
}

-(void)setRatingApperance:(EDStarRating*)rating
{
    rating.starImage = [UIImage imageNamed:@"mall_comment_nostar"];
    rating.starHighlightedImage = [UIImage imageNamed:@"mall_comment_star"];
    rating.maxRating = 5;
    rating.delegate = self;
    rating.horizontalMargin = 9;
    rating.editable = YES;
    rating.displayMode = EDStarRatingDisplayFull;
    rating.rating = 5;
    
    self.tagBtn.layer.masksToBounds = YES;
    self.tagBtn.layer.borderColor = [UIColor colorWithRed:0xcd/255.f green:0xcd/255.f blue:0xcd/255.f alpha:1].CGColor;
    self.tagBtn.layer.borderWidth = 1;
    self.tagBtn.layer.cornerRadius = 2;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadData:(CommentObject*)object
{
    self.productName.text = object.name;
    [self.productImgView sd_setImageWithURL:[NSURL URLWithString:object.smallImg] placeholderImage:nil];
    self.salePrice.text = [NSString stringWithFormat:@"￥%@",object.salePrice];
    self.orderCnt.text = [NSString stringWithFormat:@"x%@",object.saleCnt];
    self.priceRating.rating = object.priceStar;
    self.priceRatingLabel.text = [NSString stringWithFormat:@"%ld分",(long)object.priceStar];
    self.faqingRating.rating = object.ruttingStar;
    self.faqingRatingLabel.text = [NSString stringWithFormat:@"%ld分",(long)object.ruttingStar];
    self.serviceRating.rating = object.serviceStar;
    self.serviceRatingLable.text = [NSString stringWithFormat:@"%ld分",(long)object.serviceStar];
    self.comment.text = object.content;
    if ([self.comment.text isEqualToString:@""]) {
        self.comment.text = PLACE_HOLDER;
        self.comment.textColor = HEXCOLOR(@"CDCDCD");
    }
    //[self.tagBtn setTitle:object.label forState:UIControlStateNormal];
    if (object.label && object.label.length > 0) {
        [self.tagBtn setTitle:object.label forState:UIControlStateNormal];
    }
    else{
        [self.tagBtn setTitle:@"请选择" forState:UIControlStateNormal];
    }
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:PLACE_HOLDER]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCommentCell:WithContent:)]) {
        [self.delegate orderCommentCell:self WithContent:textView.text];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = PLACE_HOLDER;
        textView.textColor = HEXCOLOR(@"dddddd");
    }
}

- (IBAction)changeTag:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCommentCell:WithTagButtonClick:)]) {
        [self.delegate orderCommentCell:self WithTagButtonClick:sender];
    }
}

-(void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderCommentCell:WithRatingTag:AndRating:)]) {
        [self.delegate orderCommentCell:self WithRatingTag:control.tag AndRating:control.rating];
    }
    switch (control.tag) {
        case 0:
            self.priceRatingLabel.text = [NSString stringWithFormat:@"%0.f分",rating];
            break;
        case 1:
            self.faqingRatingLabel.text = [NSString stringWithFormat:@"%0.f分",rating];
            break;
        case 2:
            self.serviceRatingLable.text = [NSString stringWithFormat:@"%0.f分",rating];
            break;
        default:
            break;
    }
}


@end
