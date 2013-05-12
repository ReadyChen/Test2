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
UIBarButtonItem *naByTimeButton;

-(IBAction)deleteAction:(UIBarButtonItem *)sender{
    UIBarButtonItem* btn = sender;
    DebugLog(@" !! %d",btn.tag);
    switch(btn.tag)
    {
        case 1:
        {
            if(DS.bAddLeavedFlag)
            {
                sender.title = @"+ 已離開";
            }
            else
            {
                sender.title = @"- 已離開";
            }
            DS.bAddLeavedFlag = !DS.bAddLeavedFlag;
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
    temporaryBarButtonItem.title = @"返回";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    // 在畫面上方 添加一排 btns, btns 透過 .tag 作為按下之後的 switch case 識別
    naByTimeButton = [[UIBarButtonItem alloc] initWithTitle:@"TBD 已離開" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteAction:)];
    naByTimeButton.tag = 1;
    
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
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addRangeButton, subRangeButton, naByTimeButton, nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    if(DS.bAddLeavedFlag)
    {
        naByTimeButton.title = @"- 已離開";
    }
    else
    {
        naByTimeButton.title = @"+ 已離開";
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    
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
    // refresh cell.
    cell.bShowArrow = false;
    cell.thirdLabel.text = @"";
    
    // 準備 方向度數
    CLLocationManager *userLocation = [DS locationManager];
    
    if( userLocation.location.coordinate.latitude!=0 || userLocation.location.coordinate.longitude!=0 )
    {
        cell.bShowArrow = true;
        
        // 如果不是 Zero , 才 計算方向 + 顯示方向,
        CLLocationCoordinate2D trashCoordinate;
        trashCoordinate.latitude = [[dictionary objectForKey:@"Latitude"] doubleValue];
        trashCoordinate.longitude = [[dictionary objectForKey:@"Longitude"] doubleValue];
        
        float deltaLatitude = trashCoordinate.latitude - userLocation.location.coordinate.latitude;
        float deltaLongitude = trashCoordinate.longitude - userLocation.location.coordinate.longitude;
        float angle = atan2(deltaLongitude, deltaLatitude) * 180 / M_PI - 90;
        // 產生的 angle 是由 12點鐘方向為 0,到3點鐘為 90,6點鐘為180, 特別是9點鐘為 -90, 7點鐘為 -170
        // 為了要轉換成 , 四象限 先減 90 , 在進行下列 if fabsf -360 修正
        
        if(angle>0)
        {
            angle = fabsf(angle - 360);
        }
        else
        {
            angle = fabsf(angle);
        }
        
        DebugLog(@" with user LM, now display Arrow %0.2f.",angle);
        
        // 此時得到 四象限的 angle 值
        cell.fAngle = angle;
   
        // 準備 距離 差
        float fDist = [[dictionary objectForKey:@"Dist"] doubleValue];
        if(fDist<1000)
        {
            cell.thirdLabel.text = [NSString stringWithFormat:@"距離%.0f公尺",fDist];
        }
        else
        {
            fDist = fDist/1000;
            cell.thirdLabel.text = [NSString stringWithFormat:@"距離%.2f公里",fDist];
        }

    }
    // 因為是 re-use cell , 需要透過 setNeedDisplay 去觸發 drawRect
    // drawRect 裡頭配置的 Arrow Class 才會 remove + add
    [cell setNeedsDisplay];
    
    // 在 Cell 顯示 到達 離開 的資訊 .
    cell.firstLabel.text = (NSString*)[dictionary objectForKey:@"StayTime"];
    [DS CheckCarStatusWithPoint:[dictionary objectForKey:@"StartTime"] dateEnd:[dictionary objectForKey:@"EndTime"] retLabel:cell.secondLabel];

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
    CLLocationManager *userLocation = [DS locationManager];
    
    // 產生 MapView Region , 且 trashCoordinate 與 user location 合成出 Center
    MKCoordinateRegion tmpMapViewRegion;
    // 檢查 user location
    if( userLocation.location.coordinate.latitude!=0 || userLocation.location.coordinate.longitude!=0 )
    {
        // 如果不是 Zero , 才 合成 Region Center,
        if(0)
        {
            // 兩點之間的垂心作為地圖中心顯示
            tmpMapViewRegion.center.latitude = (userLocation.location.coordinate.latitude+trashCoordinate.latitude)/2;
            tmpMapViewRegion.center.longitude = (userLocation.location.coordinate.longitude+trashCoordinate.longitude)/2;
            tmpMapViewRegion.span.latitudeDelta = fabsf(userLocation.location.coordinate.latitude-trashCoordinate.latitude)*1.2;
            tmpMapViewRegion.span.longitudeDelta = fabsf(userLocation.location.coordinate.longitude-trashCoordinate.longitude)*1.2;
        }
        else
        {
            // 以 user location 作為中心顯示
            tmpMapViewRegion.center.latitude = userLocation.location.coordinate.latitude;
            tmpMapViewRegion.center.longitude = userLocation.location.coordinate.longitude;
            tmpMapViewRegion.span.latitudeDelta = fabsf(userLocation.location.coordinate.latitude-trashCoordinate.latitude)*2.2;
            tmpMapViewRegion.span.longitudeDelta = fabsf(userLocation.location.coordinate.longitude-trashCoordinate.longitude)*2.2;
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
