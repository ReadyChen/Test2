//
//  ByTimeTableViewController.m
//  TabView
//
//  Created by Chen WeiTing on 13/4/25.
//  Copyright (c) 2013年 Chen WeiTing. All rights reserved.
//

#import "ByTimeTableViewController.h"
#import "MapViewController.h"

@interface ByTimeTableViewController ()

@end

@implementation ByTimeTableViewController

-(void)configNaviBtn{
    
}

-(void)deleteAction:(id)sender{
    UIButton* btn = sender;
    NSLog(@" !! %d",btn.tag);
    switch(btn.tag)
    {
        case 1:
            //
            break;
        case 2:
            //
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    //self.title = @"By Time.";

    // 改寫 nav 後的 btn 顯示名稱
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"Back";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self
                                   action:@selector(deleteAction:)];
    saveButton.style = UIBarButtonItemStyleBordered;
    saveButton.tag = 1;
    
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                     target:self
                                     action:@selector(deleteAction:)];
    deleteButton.style = UIBarButtonItemStyleBordered;
    deleteButton.tag = 2;
    
    UIBarButtonItem *addbutton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(deleteAction:)];
    addbutton.style = UIBarButtonItemStyleBordered;
    addbutton.tag = 3;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                   target:self
                                   action:@selector(deleteAction:)];
    editButton.style = UIBarButtonItemStyleBordered;
    editButton.tag = 4;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                   target:self
                                   action:@selector(deleteAction:)];
    doneButton.style = UIBarButtonItemStyleBordered;
    doneButton.tag = 5;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:saveButton, deleteButton, nil];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editButton, doneButton, nil];

    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys: @"one", [NSNumber numberWithInt: 1], @"two",[NSNumber numberWithInt: 3], nil];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"value1", @"key1", @"value2", @"key2", nil];
    
    NSEnumerator *enumerator = [dictionary keyEnumerator];
    id key;
    
    while ((key = [enumerator nextObject])) {
        /* code that uses the returned key */
        NSLog (@"Next Object is: %@", key);  
    }

    
    myData = [[NSArray alloc] initWithObjects:@"GMail" , @"YMail" , @"Hotmail" , @"NUMail" , nil];
    mySubtitleData = [[NSArray alloc] initWithObjects:@"GMail\nSub" , @"YMail\nSub" , @"Hotmail Sub" , @"NUMail Sub" , nil];
    
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

     return [myData count];
    //return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"ByTimeTableCell111";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Updated @ 2012-08-07
    // Sample Code without "cell check" message:
    // *** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'UITableView dataSource must return a cell from tableView:cellForRowAtIndexPath:'
    //
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }

    // Set up the cell...
    cell.textLabel.text = (NSString*)[myData objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = (NSString*)[mySubtitleData objectAtIndex:indexPath.row];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

//设置点击行的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // Navigation logic may go here. Create and push another view controller.
    MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
    vc.recipeName = (NSString*)[myData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@" ... this is row %d ", indexPath.row + 1);

}

//设置行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)dealloc {
    //[super dealloc];
}

@end
