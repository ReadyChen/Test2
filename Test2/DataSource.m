//
//  DataSource.m
//  Test2
//
//  Created by Chen WeiTing on 13/4/29.
//  Copyright (c) 2013年 Chen WeiTing. All rights reserved.
//

#import "DataSource.h"
#import "Common.h"
#import "XMLReader.h"

@implementation DataSource

@synthesize MyArray;
@synthesize filteredByTimeMyArray;
@synthesize filteredByDistMyArray;
@synthesize locationManager;
@synthesize iDisplayRang;
@synthesize tableDistView;
@synthesize tableTimeView;

@synthesize bAddLeavedFlag;

-(id)init {
    return [self initWithAppID:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    DebugLog(@" LM didUpdateToLocation newLocation LM.lat %f, LM.Long %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    //do your stuff
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    DebugLog(@" LM didChangeAuthorizationStatus %d",status);
    NSLog(@" LM.lat %f, LM.Long %f / %d", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude, status);
    
    if(status==kCLAuthorizationStatusAuthorized)
    {
       [manager startUpdatingLocation];
    }

    // 下面的段落 , 是 DS init 的一部分
    // 當 系統定位 條件每次(包含第一次)有改變, 就觸發 Filter Sort Dist MyArray & tableView refresh.
    [self FilteringSortedArrayWithAdjust:0];
    [tableDistView reloadData];
    [tableTimeView reloadData];
}

-(void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    [manager stopUpdatingLocation];
    
    NSString *errorString;
    DebugLog(@"locationManager didFailWithError %@",[error localizedDescription]);
    
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Access to Location Services denied by user";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    //[alert show];
}

-(id)initWithAppID:(id)input
{
    if (self = [super init]) {
        
        iDisplayRang = DISPLAY_RANGE;
        bAddLeavedFlag = false;
        
        MyArray = [[NSMutableArray alloc] init];
        filteredByDistMyArray = [[NSMutableArray alloc] init];
        filteredByTimeMyArray = [[NSMutableArray alloc] init];

        // get System Current Location
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
        [locationManager startUpdatingLocation];
        
        NSError *parseError = nil;
        
        //NSString *testXMLString = @"<items><item id=\"0001\" type=\"donut\"><name>Cake</name><ppu>0.55</ppu><batters><batter id=\"1001\">Regular</batter><batter id=\"1002\">Chocolate</batter><batter id=\"1003\">Blueberry</batter></batters><topping id=\"5001\">None</topping><topping id=\"5002\">Glazed</topping><topping id=\"5005\">Sugar</topping></item></items>";
        
        // Parse the XML into a dictionary
        //NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLString:testXMLString error:&parseError];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TPE_V5_4133" ofType:@"xml"];
        NSData *nsData = [NSData dataWithContentsOfFile:path];
        NSDictionary *xmlDictionary = [XMLReader dictionaryForXMLData:nsData error:&parseError];

        // 產出 MyArray
        [self describeDictionary:xmlDictionary];
        
    }
    return self;
}

-(void)describeDictionary:(NSDictionary*)dict
{
    NSArray *keys;
    int i, count;
    id key;
    
    keys = [dict allKeys];
    count = [keys count];
    
    NSDictionary *dictionary = [[NSDictionary alloc] init];
    
    for (i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];
        NSDictionary *keysvalue = [dict objectForKey: key];
        
        NSDictionary *allPlacemark = [keysvalue objectForKey: @"Placemark"];
        NSLog(@" Done allPlacemark.count = %i", allPlacemark.count);
        for(id onePlacemark in allPlacemark)
        {
            // 取出 XML 單比 Placemark 的各欄位(Key)值
            NSDictionary *DictCarNumber = [onePlacemark objectForKey:@"CarNumber"];
            NSString *CarNumber = [DictCarNumber objectForKey:@"text"];
            
            NSDictionary *DictCarRound = [onePlacemark objectForKey:@"CarRound"];
            NSString *CarRound = [DictCarRound objectForKey:@"text"];
            
            NSDictionary *DictName = [onePlacemark objectForKey:@"Name"];
            NSString *Name = [DictName objectForKey:@"text"];
            
            NSDictionary *DictAddress = [onePlacemark objectForKey:@"Address"];
            NSString *Address = [DictAddress objectForKey:@"text"];
            
            NSDictionary *DictCoordinates = [onePlacemark objectForKey:@"Coordinates"];
            NSString *Coordinates = [DictCoordinates objectForKey:@"text"];
            
            NSDictionary *DictLat = [onePlacemark objectForKey:@"Lat"];
            NSString *Lat = [DictLat objectForKey:@"text"];
            
            NSDictionary *DictLong = [onePlacemark objectForKey:@"Long"];
            NSString *Long = [DictLong objectForKey:@"text"];
            
            NSDictionary *DictSH = [onePlacemark objectForKey:@"SH"];
            NSString *SH = [DictSH objectForKey:@"text"];
            
            NSDictionary *DictSM = [onePlacemark objectForKey:@"SM"];
            NSString *SM = [DictSM objectForKey:@"text"];
            
            NSDictionary *DictEH = [onePlacemark objectForKey:@"EH"];
            NSString *EH = [DictEH objectForKey:@"text"];
            
            NSDictionary *DictEM = [onePlacemark objectForKey:@"EM"];
            NSString *EM = [DictEM objectForKey:@"text"];
            
            // 準備 填入 Dict 的資料格式
            NSString *strStayTime = [NSString stringWithFormat:@"%02i:%02i~%02i:%02i", [SH integerValue],[SM integerValue],[EH integerValue],[EM integerValue]];
            
            // 產生 date Start/End HHMM 物件
            NSDate *dateStartHHMM = [NSDate date];
            NSCalendar*calendar =[NSCalendar currentCalendar];
            NSDateComponents *comps =[calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|
                                      NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:dateStartHHMM];
            [comps setHour:[SH intValue]];
            [comps setMinute:[SM intValue]];
            [comps setSecond:0];
            dateStartHHMM =[calendar dateFromComponents:comps];
            
            NSDate *dateEndHHMM = [NSDate date];
            NSCalendar*calendar2 =[NSCalendar currentCalendar];
            NSDateComponents *comps2 =[calendar2 components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|
                                      NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:dateEndHHMM];
            int iEH = [EH intValue];
            if ( iEH>0&&iEH<=3 ) // (00會以24顯示)不處理, 只處理 凌晨 01,02,03 跨日
                iEH = iEH+24;
            [comps2 setHour:iEH];
            [comps2 setMinute:[EM intValue]];
            [comps2 setSecond:0];
            dateEndHHMM =[calendar2 dateFromComponents:comps2];
            
            // 產生 經緯度 座標
            CLLocationDegrees fLatitude = [Lat doubleValue];
            CLLocationDegrees fLongitude = [Long doubleValue];
            
            // 產生 Addr 字串
            NSString *strAddr = Address;
            

            // 不 計算 trashPoint 與 user location 的直線距離 , 先填入 1.23 for Dummy.
            float fDist = (float)1.23;

            dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                          strStayTime,@"StayTime",
                          dateStartHHMM,@"StartTime",
                          dateEndHHMM, @"EndTime",
                          [NSNumber numberWithDouble:fLongitude], @"Longitude",
                          [NSNumber numberWithDouble:fLatitude], @"Latitude",
                          [NSNumber numberWithFloat:fDist], @"Dist",
                          strAddr,@"Addr",
                          nil];
            
            [MyArray addObject:dictionary];
        }
    }
    NSLog(@" Done MyArray.count = %i",MyArray.count);
}

-(void)FilteringSortedArrayWithAdjust:(NSInteger)iAdjustRang
{
    // 就靠這個 iDisplayRang 做顯示數量的調控了
    if((iDisplayRang + iAdjustRang) > 0)
    {
        if ((iDisplayRang + iAdjustRang) > DISPLAY_MAX )
        {
            // 超過 我設定的 顯示數量了
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已顯示100筆資料"
                                                            message:@"預設顯示上限為100筆,如有其他需求,請來信告知"
                                                           delegate:nil
                                                  cancelButtonTitle:@"關閉"
                                                  otherButtonTitles:nil];
            [alert show];
            NSLog(@"(iDisplayRang %d + iAdjustRang %d) > DISPLAY_MAX %d ",iDisplayRang,iAdjustRang,DISPLAY_MAX);
            return;
        }
        
        // 確保不會使 iDisplayRang 減成負值
        iDisplayRang = iDisplayRang + iAdjustRang;
    }
    else
    {
        // 已經是最小值 10 了
        return;
    }
    NSLog(@" iDisplayRang = %i ",iDisplayRang);
    
    
    // = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    
    
    // 準備 MyArrayWithDist for 接下來的 ByDist & ByTime filter
    NSMutableArray *MyArrayWithDist = [[NSMutableArray alloc] init];
    
    // 遞迴 MyArray , 準備產生 計算 Dist(距離) 的 MyArrayWithDist
    for(id b in MyArray)
    {
        // 計算 trashPoint 與 user location 的直線距離
        NSString *strStayTime = [b objectForKey:@"StayTime"];
        NSDate *dateStartHHMM = [b objectForKey:@"StartTime"];
        NSDate *dateEndHHMM = [b objectForKey:@"EndTime"];
        double dLat = [[b objectForKey:@"Latitude"] doubleValue];
        double dLong = [[b objectForKey:@"Longitude"] doubleValue];
        NSString *strAddr = [b objectForKey:@"Addr"];
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:dLat longitude:dLong];
        CLLocation *loc2;
        if(locationManager.location.coordinate.latitude!=0 && locationManager.location.coordinate.longitude!=0)
        {
            // 有取得 裝置系統定位
            loc2 = [[CLLocation alloc] initWithLatitude:locationManager.location.coordinate.latitude longitude:locationManager.location.coordinate.longitude];
        }
        else
        {
            // 沒有取得 裝置系統定位 , 使用 App 預設點位
            loc2 = [[CLLocation alloc] initWithLatitude:DEFAULT_LAT longitude:DEFAULT_LONG];
        }
        CLLocationDistance dist = [loc distanceFromLocation:loc2];
        
        NSDictionary *dictionary = [[NSDictionary alloc] init];
        dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                      strStayTime,@"StayTime",
                      dateStartHHMM,@"StartTime",
                      dateEndHHMM, @"EndTime",
                      [NSNumber numberWithDouble:dLong], @"Longitude",
                      [NSNumber numberWithDouble:dLat], @"Latitude",
                      [NSNumber numberWithFloat:dist], @"Dist",
                      strAddr,@"Addr",
                      nil];
        
        [MyArrayWithDist addObject:dictionary];
    }
    NSLog(@" Done MyArrayWithDist.count = %i",MyArrayWithDist.count);

    
    // = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
    
    
    // 清除 filteredByDistMyArray 全部舊資料
    [filteredByDistMyArray removeAllObjects];
    
    // 以 Dist 排序
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Dist"
																   ascending:YES
																	selector:@selector(compare:)] ;
	
	NSArray *descriptors = [NSArray arrayWithObject:nameDescriptor];
	NSMutableArray *sortedByDistMyArray = (NSMutableArray*)[MyArrayWithDist sortedArrayUsingDescriptors:descriptors];
    

    
    // 產生 filteredByDistMyArray
    for (NSDictionary *dict in sortedByDistMyArray)
    {
        if( bAddLeavedFlag )
        {
            [filteredByDistMyArray addObject:dict];
        }
        else
        {
            UILabel *labelDummy = [[UILabel alloc] init];
            NSInteger iCarStatus = [self CheckCarStatusWithPoint:[dict objectForKey:@"StartTime"] dateEnd:[dict objectForKey:@"EndTime"] retLabel:labelDummy];
            
            if(iCarStatus!=2)
            {
                [filteredByDistMyArray addObject:dict];
            }
        }
        
        if( filteredByDistMyArray.count == iDisplayRang )
        {
            break;
        }
    }
        
    
    // = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

    
    
    // 清除 filteredByTimeMyArray 全部舊資料
    [filteredByTimeMyArray removeAllObjects];
    
    // 以 StartTime 排序
    NSSortDescriptor *nameDescrpt = [[NSSortDescriptor alloc] initWithKey:@"StartTime"
																   ascending:YES
																	selector:@selector(compare:)] ;
	NSArray *descrpts = [NSArray arrayWithObject:nameDescrpt];
	NSMutableArray *sortedByTimeMyArray = (NSMutableArray*)[filteredByDistMyArray sortedArrayUsingDescriptors:descrpts];
    
    // 產生 filteredByTimeMyArray
    for (NSDictionary *dict in sortedByTimeMyArray)
    {
        if( bAddLeavedFlag )
        {
            [filteredByTimeMyArray addObject:dict];
        }
        else
        {
            UILabel *labelDummy = [[UILabel alloc] init];
            NSInteger iCarStatus = [self CheckCarStatusWithPoint:[dict objectForKey:@"StartTime"] dateEnd:[dict objectForKey:@"EndTime"] retLabel:labelDummy];
            
            if(iCarStatus!=2)
            {
                [filteredByTimeMyArray addObject:dict];
            }
        }
        
        if( filteredByTimeMyArray.count == iDisplayRang )
        {
            break;
        }
    }
    

}


-(NSInteger)CheckCarStatusWithPoint:(NSDate*)dateTrashPointStart dateEnd:(NSDate*)dateTrashPointEnd retLabel:(UILabel*)retLabel
{
    NSInteger iRet = 0;
    
    NSDate *dateNow = [[NSDate alloc] init];
    
    // 開關, 如這裡關起來, 將使用系統正確時間, 打開, 將使用 Debug HH MM
    if(DEBUG_HHMM)
    {
        // 準備 set Start HH MM
        NSCalendar *calendar1 = [NSCalendar currentCalendar];
        NSDateComponents *comps =[calendar1 components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|
                                  NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:dateNow];
        [comps setHour:DEBUG_HH];
        [comps setMinute:DEBUG_MM];
        [comps setSecond:0];
        
        // 執行 set Start HH MM , 更新 date 形態的 StartHHMM
        dateNow =[calendar1 dateFromComponents:comps];
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar] ;
    NSDateComponents *componentsStart = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit
                                                    fromDate:dateNow
                                                      toDate:dateTrashPointStart
                                                     options:0];
    NSDateComponents *componentsEnd = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit
                                                  fromDate:dateNow
                                                    toDate:dateTrashPointEnd
                                                   options:0];

    if(componentsStart.hour <= 0 || componentsStart.minute <= 0 )
    {
        //@"--:--已到達,%02i:%02i後離開"
        iRet = 1;
        if(componentsEnd.hour==0 && componentsEnd.minute==0)
        {
            retLabel.text = [NSString stringWithFormat:@"--:--已到達,正在離開"];
        }
        else
        {
            retLabel.text = [NSString stringWithFormat:@"--:--已到達,%02i:%02i後離開", componentsEnd.hour, componentsEnd.minute];
        }
    }
    if(componentsEnd.hour < 0 || componentsEnd.minute < 0 )
    {
        //@"已離開"
        iRet = 2;
        retLabel.text = [NSString stringWithFormat:@"已離開"];
    }
    if( (componentsStart.hour > 0 || componentsStart.minute > 0 ) && (componentsEnd.hour > 0 || componentsEnd.minute > 0 ) )
    {
        //@"%02i:%02i後到達,%02i:%02i後離開"
        iRet = 3;
        retLabel.text = [NSString stringWithFormat:@"%02i:%02i後到達,%02i:%02i後離開", componentsStart.hour, componentsStart.minute, componentsEnd.hour, componentsEnd.minute];
    }
    
    return iRet;
}

@end
