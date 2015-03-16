//
//  ViewController.m
//  GMGridView
//
//  Created by Gulam Moledina on 11-10-09.
//  Copyright (c) 2011 GMoledina.ca. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Demo3ViewController.h"
#import "GMGridView.h"
#import "OptionsViewController.h"
#import "TextField.h"

#define NUMBER_ITEMS_ON_LOAD 250
#define NUMBER_ITEMS_ON_LOAD2 30

#define COLUMN 10

//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark ViewController (privates methods)
//////////////////////////////////////////////////////////////

@interface Demo3ViewController () <GMGridViewDataSource, GMGridViewActionDelegate>
{
    __gm_weak GMGridView *_gmGridView;
    UINavigationController *_optionsNav;
    UIPopoverController *_optionsPopOver;
    
    NSMutableArray *_data;
    NSMutableArray *_data2;
    __gm_weak NSMutableArray *_currentData;
    NSInteger _lastDeleteItemIndexAsked;
}

@property (nonatomic, retain) NSMutableArray *theNewData;

- (void)addMoreItem;
- (void)removeItem;
- (void)refreshItem;
- (void)presentInfo;
- (void)presentOptions:(UIBarButtonItem *)barButton;
- (void)optionsDoneAction;
- (void)dataSetChange:(UISegmentedControl *)control;

@end


//////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark ViewController implementation
//////////////////////////////////////////////////////////////

@implementation Demo3ViewController

@synthesize theNewData = _newData;

- (void)initTextField:(TextField*)textField with:(NSString*)aText editable:(BOOL)isEditable
{
    textField = [ [TextField alloc] init];
    textField.text = aText;
    textField.editable = isEditable;
    [_data addObject:textField];
    [_newData addObject:[NSString stringWithFormat:@""]];
}

- (void)initIPAD
{
    TextField *textField = [ [TextField alloc] init];
    textField.text = @"Col 1";
    textField.editable = FALSE;
    [_data addObject:textField];
    [_newData addObject:[NSString stringWithFormat:@""]];
    [self initTextField:textField with:@"Col 2" editable:FALSE];
    [self initTextField:textField with:@"Col 3" editable:FALSE];
    [self initTextField:textField with:@"Col 4" editable:FALSE];
    [self initTextField:textField with:@"Col 5" editable:FALSE];
    [self initTextField:textField with:@"Col 6" editable:FALSE];
    [self initTextField:textField with:@"Col 7" editable:FALSE];
    [self initTextField:textField with:@"Col 8" editable:FALSE];
    [self initTextField:textField with:@"Col 9" editable:FALSE];
    [self initTextField:textField with:@"Col10" editable:FALSE];
    
    [self initTextField:textField with:@"Row 1" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    
    [self initTextField:textField with:@"Row 2" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    
    [self initTextField:textField with:@"Row 3" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    
    [self initTextField:textField with:@"Total" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
    [self initTextField:textField with:@"" editable:FALSE];
}

- (id)init
{
    if ((self =[super init]))
    {
        self.title = @"Demo 3";
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMoreItem)];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width = 10;
        
        UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeItem)];
        
        UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space2.width = 10;
        
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshItem)];
        
        if ([self.navigationItem respondsToSelector:@selector(leftBarButtonItems)]) {
            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:addButton, space, removeButton, space2, refreshButton, nil];
        }else {
            self.navigationItem.leftBarButtonItem = addButton;
        }
        
        UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(presentOptions:)];
        
        if ([self.navigationItem respondsToSelector:@selector(rightBarButtonItems)]) {
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:optionsButton, nil];
        }else {
            self.navigationItem.rightBarButtonItem = optionsButton;
        }
        
        /*
        _data = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < NUMBER_ITEMS_ON_LOAD; i ++) 
        {
            [_data addObject:[NSString stringWithFormat:@"A %d", i]];
        }
        
        _data2 = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < NUMBER_ITEMS_ON_LOAD2; i ++) 
        {
            [_data2 addObject:[NSString stringWithFormat:@"B %d", i]];
        }
        
        _currentData = _data;
        */
        
        _data = [[NSMutableArray alloc] init];
        _newData = [[NSMutableArray alloc] init] ;
        
        [self initIPAD];
        
    }
    
    return self;
}

//////////////////////////////////////////////////////////////
#pragma mark controller events
//////////////////////////////////////////////////////////////

- (void)loadView 
{
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor]; // was whiteColor
    
    // Was 10 and 15
    NSInteger spacing = INTERFACE_IS_PHONE ? 1 : 2;
    
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:self.view.bounds];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = spacing;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    _gmGridView.centerGrid = YES;
    _gmGridView.actionDelegate = self;
//    _gmGridView.sortingDelegate = self;
//    _gmGridView.transformDelegate = self;
    _gmGridView.dataSource = self;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
    infoButton.frame = CGRectMake(self.view.bounds.size.width - 40, 
                                  self.view.bounds.size.height - 40, 
                                  40,
                                  40);
    infoButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [infoButton addTarget:self action:@selector(presentInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoButton];
    
    UISegmentedControl *dataSegmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"DataSet 1", @"DataSet 2", nil]];
    [dataSegmentedControl sizeToFit];
    dataSegmentedControl.frame = CGRectMake(5, 
                                            self.view.bounds.size.height - dataSegmentedControl.bounds.size.height - 5,
                                            dataSegmentedControl.bounds.size.width, 
                                            dataSegmentedControl.bounds.size.height);
    dataSegmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    dataSegmentedControl.tintColor = [UIColor greenColor];
    dataSegmentedControl.selectedSegmentIndex = 0;
    [dataSegmentedControl addTarget:self action:@selector(dataSetChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:dataSegmentedControl];
    
    
    OptionsViewController *optionsController = [[OptionsViewController alloc] init];
    optionsController.gridView = gmGridView;
    optionsController.contentSizeForViewInPopover = CGSizeMake(400, 500);
    
    _optionsNav = [[UINavigationController alloc] initWithRootViewController:optionsController];
    
    if (INTERFACE_IS_PHONE)
    {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(optionsDoneAction)];
        optionsController.navigationItem.rightBarButtonItem = doneButton;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _gmGridView.mainSuperView = self.navigationController.view; //[UIApplication sharedApplication].keyWindow.rootViewController.view;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    _gmGridView = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

//////////////////////////////////////////////////////////////
#pragma mark memory management
//////////////////////////////////////////////////////////////

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}

//////////////////////////////////////////////////////////////
#pragma mark orientation management
//////////////////////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}


//////////////////////////////////////////////////////////////
#pragma mark GMGridViewDataSource
//////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    //return [_currentData count];
    return [_data count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE) 
    {
        if (UIInterfaceOrientationIsLandscape(orientation)) 
        {
            return CGSizeMake(320/COLUMN, 22);
        }
        else
        {
            return CGSizeMake(480/COLUMN, 22);
        }
    }
    else
    {
        // http://stackoverflow.com/questions/2738734/get-current-orientation-of-ipad
        // was 230 and 175
        // 115 * 8 = 920; 44 * 14 = 616
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            return CGSizeMake(748/COLUMN, 44);
        }
        else
        {
            return CGSizeMake(960/COLUMN, 44);
        }
    }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    //NSLog(@"Creating view indx %d", index);
    
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) 
    {
        cell = [[GMGridViewCell alloc] init];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor whiteColor]; // was redColor
        view.layer.masksToBounds = NO;
        if (INTERFACE_IS_PHONE)
        {
            view.layer.cornerRadius = 1;  // was 8
        }
        else
        {
            view.layer.cornerRadius = 2;  // was 8
        }
        
        cell.contentView = view;
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:cell.contentView.bounds];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [textField setTag:index];

    if( index!=2 && index!=3 && ((index+5)%COLUMN == 0 || (index+4)%COLUMN == 0)) {
        NSLog(@"Inside cellForItemAtIndex, index = %i", index);
        textField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    } 
    else if ( index%COLUMN==0 && index >= ([_data count] - COLUMN) ) // extra row, first column (unit name, pick from pop up)
    {
        textField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    else if ( (index!=5 && (index+2)%COLUMN == 0) ) {
        textField.inputView = [self inputView];
    }
    else { 
        
    }
    
    textField.text = (NSString *)[[_data objectAtIndex:index] text];
//   textField.enabled = [[_data objectAtIndex:index] editable];
    textField.textAlignment = UITextAlignmentCenter;
    textField.backgroundColor = [UIColor clearColor];
    
    [cell.contentView addSubview:textField ];
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return YES; //index % 2 == 0;
}

//////////////////////////////////////////////////////////////
#pragma mark GMGridViewActionDelegate
//////////////////////////////////////////////////////////////

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %d", position);
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    
    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) 
    {
        [_currentData removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }
}

//////////////////////////////////////////////////////////////
#pragma mark private methods
//////////////////////////////////////////////////////////////

- (void)addMoreItem
{
    // Example: adding object at the last position
    NSString *newItem = [NSString stringWithFormat:@"%d", (int)(arc4random() % 1000)];
    
    [_currentData addObject:newItem];
    [_gmGridView insertObjectAtIndex:[_currentData count] - 1 withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
}

- (void)removeItem
{
    // Example: removing last item
    if ([_currentData count] > 0) 
    {
        NSInteger index = [_currentData count] - 1;
        
        [_gmGridView removeObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
        [_currentData removeObjectAtIndex:index];
    }
}

- (void)refreshItem
{
    // Example: reloading last item
    if ([_currentData count] > 0) 
    {
        int index = [_currentData count] - 1;
        
        NSString *newMessage = [NSString stringWithFormat:@"%d", (arc4random() % 1000)];
        
        [_currentData replaceObjectAtIndex:index withObject:newMessage];
        [_gmGridView reloadObjectAtIndex:index withAnimation:GMGridViewItemAnimationFade | GMGridViewItemAnimationScroll];
    }
}

- (void)presentInfo
{
    NSString *info = @"Long-press an item and its color will change; letting you know that you can now move it around. \n\nUsing two fingers, pinch/drag/rotate an item; zoom it enough and you will enter the fullsize mode";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info" 
                                                        message:info 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
    
    [alertView show];
}

- (void)dataSetChange:(UISegmentedControl *)control
{
    _currentData = ([control selectedSegmentIndex] == 0) ? _data : _data2;

    [_gmGridView reloadData];
}

- (void)presentOptions:(UIBarButtonItem *)barButton
{
    if (INTERFACE_IS_PHONE)
    {
        [self presentModalViewController:_optionsNav animated:YES];
    }
    else
    {
        if(![_optionsPopOver isPopoverVisible])
        {
            if (!_optionsPopOver)
            {
                _optionsPopOver = [[UIPopoverController alloc] initWithContentViewController:_optionsNav];
            }
            
            [_optionsPopOver presentPopoverFromBarButtonItem:barButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            [self optionsDoneAction];
        }
    }
}

- (void)optionsDoneAction
{
    if (INTERFACE_IS_PHONE)
    {
        [self dismissModalViewControllerAnimated:YES];
    }
    else
    {
        [_optionsPopOver dismissPopoverAnimated:YES];
    }
}

@end
