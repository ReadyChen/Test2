//
//  MapViewViewController.m
//  TabView
//
//  Created by Chen WeiTing on 13/4/25.
//  Copyright (c) 2013年 Chen WeiTing. All rights reserved.
//

#import "MapViewController.h"
#import "MyAnnotation.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize trashCoordinate;
@synthesize userCoordinate;
@synthesize mapView;
@synthesize recipeLabel;
@synthesize recipeName;
@synthesize mapViewRegion;

MyAnnotation *lastAnnotation;


- (void)dealloc {
    //NSLog(@" MapViewContrl dealloc");
    //[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@" MapViewContrl viewWillAppear");

    // mapView setRegion:mapViewRegion 交給 Thread 去觸發 , 但 App 第一次執行 都還是會 卡住 Region
    [self performSelectorOnMainThread:@selector(updateMyMap) withObject:nil waitUntilDone:NO];
    
    // 移除上一個 Annotation
    [mapView removeAnnotation:lastAnnotation];
    
    MyAnnotation *trashAnnotation = [[MyAnnotation alloc] init];
    trashAnnotation.coordinate = trashCoordinate;
    trashAnnotation.title = @"高思數位網路";
    trashAnnotation.subtitle = @"媽，我在這裡啦!";
    lastAnnotation = trashAnnotation;
    
    // 把annotation加進MapView裡
    [mapView addAnnotation:trashAnnotation];

}

- (void)viewDidLoad
{
    //NSLog(@" MapViewContrl viewDidLoad");
    
    [super viewDidLoad];
    
    recipeLabel.text = recipeName;
    
    mapView.showsUserLocation = YES;
}

-(void) updateMyMap {
    
    //NSLog(@" MapViewContrl updateMyMap");
    [mapView setRegion:mapViewRegion animated:YES];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@" MapViewContrl didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
