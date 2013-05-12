//
//  ByDistViewCell.m
//  Test2
//
//  Created by Chen WeiTing on 13/5/2.
//  Copyright (c) 2013年 Chen WeiTing. All rights reserved.
//

#import "ByDistViewCell.h"
#import "Arrow.h"

@implementation ByDistViewCell

@synthesize firstLabel;
@synthesize secondLabel;
@synthesize thirdLabel;
@synthesize bShowArrow;
@synthesize fAngle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    // 列舉 舊有 Arrow class in subviews, 找到就移除
    for (id b in self.subviews)
    {
        // isKingOfClass 有效
        // if(b.tag==123793) 也有效 , addSubview 之前需指派 b.tag = (int)i;
        if([b isKindOfClass:[Arrow class]]) {
            [b removeFromSuperview];
        }
    }
    
    if(bShowArrow)
    {
        // 畫上 新的 Arrow class
        Arrow *view = [[Arrow alloc] initWithFrame:CGRectMake(210, 10, 80, 80)];
        view.fAngle = fAngle;
        [view setBackgroundColor: [UIColor clearColor]];
        [self addSubview: view];
    }
}

-(void)removeArrow
{
    
}

@end
