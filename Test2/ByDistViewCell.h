//
//  ByDistViewCell.h
//  Test2
//
//  Created by Chen WeiTing on 13/5/2.
//  Copyright (c) 2013年 Chen WeiTing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ByDistViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *firstLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondLabel;
@property (nonatomic, weak) IBOutlet UILabel *thirdLabel;
@property (nonatomic, weak) IBOutlet UILabel *fourthLabel;

@property(assign,nonatomic) CGFloat fAngle;

@end
