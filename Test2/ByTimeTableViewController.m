//
//  ByTimeTableViewController.m
//  TabView
//
//  Created by Chen WeiTing on 13/4/25.
//  Copyright (c) 2013年 Chen WeiTing. All rights reserved.
//

#import "ByTimeTableViewController.h"
#import "Common.h"
#import "MapViewController.h"
#import "ByTimeViewCell.h"
#import "DataSource.h"
#import <math.h>


@interface ByTimeTableViewController ()

@end

@implementation ByTimeTableViewController

DataSource *DS;
MapViewController *mapViewCtrl;
UIBarButtonItem *naButton;
BOOL bAddLeavedTimeFlag = false;

-(IBAction)deleteAction:(UIBarButtonItem *)sender{
    UIBarButtonItem* btn = sender;
    DebugLog(@" !! %d",btn.tag);
    switch(btn.tag)
    {
        case 1:
        {
            if(bAddLeavedTimeFlag)
            {
                sender.title = @"- 已離開";
            }
            else
            {
                sender.title = @"+ 已離開";
            }
            bAddLeavedTimeFlag = !bAddLeavedTimeFlag;
            DS.bAddLeavedFlag = bAddLeavedTimeFlag;
            [DS FilteringSortedArrayWithAdjust:0];
            [DS.tableDistView reloadData];
            [DS.tableTimeView reloadData];
        }
            break;
        case 2:
        {
            [DS FilteringSortedArrayWithAdjust:-10];
            [DS.tableDistView reloadData];
            [DS.tableTimeView reloadData];
        }
            break;
        case 3:
        {
            [DS FilteringSortedArrayWithAdjust:10];
            [DS.tableDistView reloadData];
            [DS.tableTimeView reloadData];
        }
            break;
    }
}

-(void)InitLayout{
    
    // 改寫 nav 後的 btn 顯示名稱
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"Back";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    // 在畫面上方 添加一排 btns, btns 透過 .tag 作為按下之後的 switch case 識別
    naButton = [[UIBarButtonItem alloc] initWithTitle:@"+ 已離開" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAction:)];
    naButton.tag = 1;
    if(bAddLeavedTimeFlag)
    {
        naButton.title = @"- 已離開";
    }
    else
    {
        naButton.title = @"+ 已離開";
    }
    
    UIBarButtonItem *subRangeButton = [[UIBarButtonItem alloc] initWithTitle:@"- 距離範圍" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAction:)];
    subRangeButton.tag = 2;
    UIBarButtonItem *addRangeButton = [[UIBarButtonItem alloc] initWithTitle:@"+ 距離範圍" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAction:)];
    addRangeButton.tag = 3;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:self
                                   action:@selector(deleteAction:)];
    doneButton.style = UIBarButtonItemStyleBordered;
    doneButton.tag = 4;
    
     UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                      target:self
                                      action:@selector(deleteAction:)];
    refreshButton.style = UIBarButtonItemStyleBordered;
    refreshButton.tag = 5;
    
    //self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:doneButton, refreshButton, nil];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addRangeButton, subRangeButton, naButton, nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@" ByTime viewWillAppear");
    bAddLeavedTimeFlag = DS.bAddLeavedFlag;
    
    if(bAddLeavedTimeFlag)
    {
        naButton.title = @"- 已離開";
    }
    else
    {
        naButton.title = @"+ 已離開";
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@" ByTime viewDidAppear");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;

    [self InitLayout];
    
    if(!DS)
    {
        DS = [[DataSource alloc] init];
    }
    DS.tableTimeView = self.tableView;
    DS.bAddLeavedFlag = bAddLeavedTimeFlag;
    
    if(!mapViewCtrl)
        mapViewCtrl = [self.storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DS.filteredByTimeMyArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"ByTimeTableCell";
    
    ByTimeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ByTimeViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }

    // 從 Array 拉出一筆 dictionary
    NSDictionary *dictionary = [[NSDictionary alloc] init];
    dictionary = [DS.filteredByTimeMyArray objectAtIndex:indexPath.row];
    
    [self setOneRawData:dictionary toCell:cell];
    
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

-(void)setOneRawData:(NSDictionary *)dictionary toCell:(ByTimeViewCell *)cell
{ 
    // 準備 距離 差
    float fDist = [[dictionary objectForKey:@"Dist"] doubleValue];
    fDist = fDist/1000;
    NSString *strDist = [NSString stringWithFormat:@"距離%.2f公里",fDist];
    
    // 準備 方向度數
    CLLocationManager *tmpLocationManager = [DS locationManager];
    if( tmpLocationManager.location.coordinate.latitude!=0 || tmpLocationManager.location.coordinate.longitude!=0 )
    {
        // 如果不是 Zero , 才 計算方向 + 顯示方向,
        CLLocationCoordinate2D trashCoordinate;
        trashCoordinate.latitude = [[dictionary objectForKey:@"Latitude"] doubleValue];
        trashCoordinate.longitude = [[dictionary objectForKey:@"Longitude"] doubleValue];
        
        float deltaLatitude = trashCoordinate.latitude - tmpLocationManager.location.coordinate.latitude;
        float deltaLongitude = trashCoordinate.longitude - tmpLocationManager.location.coordinate.longitude;
        float angle = atan2(deltaLongitude, deltaLatitude) * 180 / M_PI;
        
        cell.fourthLabel.text = [NSString stringWithFormat:@"%.0f", angle];
    }
    
    // 顯示 Cell
    cell.firstLabel.text = (NSString*)[dictionary objectForKey:@"StayTime"];
    [DS CheckCarStatusWithPoint:[dictionary objectForKey:@"StartTime"] dateEnd:[dictionary objectForKey:@"EndTime"] retLabel:cell.secondLabel];
    cell.thirdLabel.text = strDist;

    return;
}

//设置点击行的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dictionary = [[NSDictionary alloc] init];
    dictionary = [DS.filteredByTimeMyArray objectAtIndex:indexPath.row];
    
    // 取得 Trash 點座標 , Set 到 mapViewCtrl.trashCoordinate 準備作為 MyAnnotation 使用
    CLLocationCoordinate2D trashCoordinate;
    trashCoordinate.latitude = [[dictionary objectForKey:@"Latitude"] doubleValue];
    trashCoordinate.longitude = [[dictionary objectForKey:@"Longitude"] doubleValue];
    mapViewCtrl.trashCoordinate = trashCoordinate;
    
    // 取得 User 點座標
    CLLocationManager *tmpLocationManager = [DS locationManager];
    
    // 產生 MapView Region , 且 trashCoordinate 與 user location 合成出 Center
    MKCoordinateRegion tmpMapViewRegion;
    // 檢查 user location
    if( tmpLocationManager.location.coordinate.latitude!=0 || tmpLocationManager.location.coordinate.longitude!=0 )
    {
        // 如果不是 Zero , 才 合成 Region Center,
        if(0)
        {
            // 兩點之間的垂心作為地圖中心顯示
            tmpMapViewRegion.center.latitude = (tmpLocationManager.location.coordinate.latitude+trashCoordinate.latitude)/2;
            tmpMapViewRegion.center.longitude = (tmpLocationManager.location.coordinate.longitude+trashCoordinate.longitude)/2;
            tmpMapViewRegion.span.latitudeDelta = fabsf(tmpLocationManager.location.coordinate.latitude-trashCoordinate.latitude)*1.2;
            tmpMapViewRegion.span.longitudeDelta = fabsf(tmpLocationManager.location.coordinate.longitude-trashCoordinate.longitude)*1.2;
        }
        else
        {
            // 以 user location 作為中心顯示
            tmpMapViewRegion.center.latitude = tmpLocationManager.location.coordinate.latitude;
            tmpMapViewRegion.center.longitude = tmpLocationManager.location.coordinate.longitude;
            tmpMapViewRegion.span.latitudeDelta = fabsf(tmpLocationManager.location.coordinate.latitude-trashCoordinate.latitude)*2.2;
            tmpMapViewRegion.span.longitudeDelta = fabsf(tmpLocationManager.location.coordinate.longitude-trashCoordinate.longitude)*2.2;
        }
    }
    else
    {
        // 如果是 Zero , 將 trashCoordinate 作為 Center
        tmpMapViewRegion.center.latitude = trashCoordinate.latitude;
        tmpMapViewRegion.center.longitude = trashCoordinate.longitude;
        tmpMapViewRegion.span.latitudeDelta = 0.01;
        tmpMapViewRegion.span.longitudeDelta = 0.01;
    }

    mapViewCtrl.mapViewRegion = tmpMapViewRegion;
    
    // 顯示的文字資訊
    mapViewCtrl.recipeName = (NSString*)[dictionary objectForKey:@"Addr"];
    mapViewCtrl.hidesBottomBarWhenPushed = YES;
        
    // ViewController Trigger !~
    [self.navigationController pushViewController:mapViewCtrl animated:YES];
    
    DebugLog(@" ... this is row %d ", indexPath.row + 1);

}

//设置行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)dealloc {
    //[super dealloc];
}



@end
