//
//  MapViewViewController.h
//  TabView
//
//  Created by Chen WeiTing on 13/4/25.
//  Copyright (c) 2013年 Chen WeiTing. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UILabel *recipeLabel;
@property (nonatomic, strong) NSString *recipeName;
@property (nonatomic, readwrite) CLLocationCoordinate2D trashCoordinate;
@property (nonatomic, readwrite) CLLocationCoordinate2D userCoordinate;
@property (nonatomic, readwrite) MKCoordinateRegion mapViewRegion;

@end
