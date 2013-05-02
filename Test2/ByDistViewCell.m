//
//  ByDistViewCell.m
//  Test2
//
//  Created by Chen WeiTing on 13/5/2.
//  Copyright (c) 2013年 Chen WeiTing. All rights reserved.
//

#import "ByDistViewCell.h"

@implementation ByDistViewCell

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
