//
//  DataSource.h
//  Test2
//
//  Created by Chen WeiTing on 13/4/29.
//  Copyright (c) 2013年 Chen WeiTing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface DataSource : NSObject

@property(strong,nonatomic) NSMutableArray *MyArray;
@property(strong,nonatomic) NSMutableArray *filteredByTimeMyArray;
@property(strong,nonatomic) NSMutableArray *filteredByDistMyArray;
@property(strong,nonatomic) CLLocationManager *locationManager;
@property(assign,nonatomic) NSInteger iDisplayRang;
@property(strong,nonatomic) UITableView *tableDistView;
@property(strong,nonatomic) UITableView *tableTimeView;
@property(assign,nonatomic) bool bAddLeavedFlag;

-(void)FilteringSortedArrayWithAdjust:(NSInteger)iAdjustRang;
-(NSInteger)CheckCarStatusWithPoint:(NSDate*)dateTrashPointStart dateEnd:(NSDate*)dateTrashPointEnd retLabel:(UILabel*)retLabel;

@end
