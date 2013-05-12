//
//  ByTimeViewCell.h
//  Test2
//
//  Created by Chen WeiTing on 13/5/1.
//  Copyright (c) 2013年 Chen WeiTing. All rights reserved.
// 

#import <UIKit/UIKit.h>

@interface ByTimeViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *firstLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondLabel;
@property (nonatomic, weak) IBOutlet UILabel *thirdLabel;

@property(assign,nonatomic) BOOL bShowArrow;
@property(assign,nonatomic) CGFloat fAngle;

@end
