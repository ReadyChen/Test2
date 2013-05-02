//
//  ByTimeViewCell.m
//  Test2
//
//  Created by Chen WeiTing on 13/5/1.
//  Copyright (c) 2013年 Chen WeiTing. All rights reserved.
// 

#import "ByTimeViewCell.h"

@implementation ByTimeViewCell

@synthesize firstLabel;
@synthesize secondLabel;
@synthesize thirdLabel;
@synthesize fourthLabel;

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

@end
