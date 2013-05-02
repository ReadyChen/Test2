//
//  MyAnnotation.h
//  Test2
//
//  Created by Chen WeiTing on 13/4/29.
//  Copyright (c) 2013年 Chen WeiTing. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;

@end
