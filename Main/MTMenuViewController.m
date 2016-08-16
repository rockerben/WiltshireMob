//
//  MTMenuViewController.m
//  MTStackViewControllerExample
//
//  Created by Andrew Carter on 1/31/13.
//  Copyright (c) 2013 WillowTree Apps. All rights reserved.
//

#import "MTMenuViewController.h"

#import "MTStackViewController.h"
#import "BCCell.h"
#import "BHCollectionViewController.h"
#import "ContactViewController.h"
#import "FrontViewController.h"
#import "BakewareViewController.h"
#import "CookwareViewController.h"
#import "UtensilsViewController.h"
#import "KitchenwareViewController.h"


static NSString *const MTTableViewCellIdentifier = @"MTTableViewCell";

@interface MTMenuViewController ()
{
    NSMutableArray *_datasource;
    BOOL _didSetInitialViewController;
    
}

    @end

@implementation MTMenuViewController


#pragma mark - UIViewController Overrides

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _datasource = [NSMutableArray new];
        [self populateDatasource];
        
        //[[self navigationItem] setTitle:@""];
    }
    return self;
}

- (void)viewDidLoad
{
    // This is the LEFT VIEW Controller GUTS
    
    // For some reason, when the view is added for the fold view, the nav bar gets pushed down for the status bar
    //  CGRect frame = self.navigationController.navigationBar.frame;
    //  self.navigationController.navigationBar.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    
    // This is the view's starting space. width + 75 gives additonal space
    CGRect frame1 = [self tableView].frame;//ben
    [self tableView].frame = CGRectMake(0, 0, CGRectGetWidth(frame1)+75, CGRectGetHeight(frame1)+30);
    
    // Set the left view table view as borderless
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    // Register Cell Identifier
    [[self tableView] registerNib:[UINib nibWithNibName:@"BCCell"bundle:nil] forCellReuseIdentifier:MTTableViewCellIdentifier];
    
    
    // Set the cool background view kitchen
    UIImageView *grungeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coolback"]];
    [grungeView setFrame:self.tableView.frame];
    self.tableView.backgroundView = grungeView;
    
    // Set left tableview  footer
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    [self tableView].tableFooterView = footer;
    
    // Set left tableview  header
    
    
    // Do any additional setup after loading the view from its nib.
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            UIView *headerSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 0,0,200)];//this is the header space
            self.tableView.tableHeaderView =headerSpace;
            // Add a small rectangle image (which is the Wiltshire logo) with shadow like tunewiki
            UIImageView *albumView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
            [albumView setFrame:CGRectMake(0, 70,150, 50)];
            [self.view addSubview: albumView];
   
            // iPhone Classic
        }
        if(result.height == 568)
        {
            UIView *headerSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 0,0,250)];//this is the header space
            self.tableView.tableHeaderView =headerSpace;
            // Add a small rectangle image (which is the Wiltshire logo) with shadow like tunewiki
            UIImageView *albumView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
            [albumView setFrame:CGRectMake(0, 70,150, 50)];
            [self.view addSubview: albumView];
            // iPhone 5
        }
    }

    
    
    // Set left tableview row height (for big cells)
   // [self.tableView setRowHeight: 30.00];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Frame = %@", self.navigationController.navigationBar);
    if (!_didSetInitialViewController)
    {
        [self setInitialViewController];
        _didSetInitialViewController = YES;
    }

}

#pragma mark - Instance Methods

- (void)setInitialViewController
{
    [self tableView:[self tableView] didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)populateDatasource
{
    [_datasource setArray:@[
        [UIColor redColor],
        [UIColor blueColor],
        [UIColor greenColor],
        [UIColor yellowColor],
        [UIColor purpleColor],
        [UIColor greenColor],
        

     ]];
}

- (void)configureCell:(BCCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *grungeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [grungeView setFrame:self.tableView.frame];

    cell.backgroundView = grungeView;
    
    switch ([indexPath row])
    {
        case 0:
            cell.imageLine.image = [UIImage imageNamed:@"lorange"];
            cell.imageField.image= [UIImage imageNamed:@"knife2"];
            cell.labelField.text= [NSString stringWithFormat:@"Home"];
            cell.labelDetailField.text= [NSString stringWithFormat:@"Always up to date catalogue in your mobile device"];
           
            break;
        case 1:
            cell.imageLine.image = [UIImage imageNamed:@"lviolet"];
            cell.imageField.image= [UIImage imageNamed:@"bakeware"];
            //cell.labelField.text=[NSString stringWithFormat:@"View Controller %d", [indexPath row]];
            cell.labelField.text=[NSString stringWithFormat:@"Bakeware"];
            cell.labelDetailField.text= [NSString stringWithFormat:@"Bend&Bake, Cake Tins, Bake Pans, Cooling Racks and More"];
            break;
        case 2:
            cell.imageLine.image = [UIImage imageNamed:@"lred"];
            cell.imageField.image= [UIImage imageNamed:@"pan"];
            //cell.labelField.text=[NSString stringWithFormat:@"View Controller %d", [indexPath row]];
            cell.labelField.text=[NSString stringWithFormat:@"Cookware"];
            cell.labelDetailField.text= [NSString stringWithFormat:@"Fry Pans, Sauce Pans"];
            break;
        case 3:
            cell.imageLine.image = [UIImage imageNamed:@"lgreen"];
            cell.imageField.image= [UIImage imageNamed:@"utensils"];
            cell.labelField.text=[NSString stringWithFormat:@"Utensils and Gadgets"];
            //cell.labelField.text=[NSString stringWithFormat:@"View Controller %d", [indexPath row]];
            cell.labelDetailField.text= [NSString stringWithFormat:@"Wiltshire Classic, Wiltshire Viva, Wiltshire Fusion"];
            break;
        case 4:
            cell.imageLine.image = [UIImage imageNamed:@"lblue"];
            cell.imageField.image= [UIImage imageNamed:@"knives"];
            //cell.labelField.text=[NSString stringWithFormat:@"View Controller %d", [indexPath row]];
            cell.labelField.text=[NSString stringWithFormat:@"Kitchenware"];
            cell.labelDetailField.text= [NSString stringWithFormat:@"Knives, Scissors, Salt and Pepper"];
            break;
        case 5:
            cell.imageLine.image = [UIImage imageNamed:@"lorange"];
            cell.imageField.image= [UIImage imageNamed:@"plate"];
            //cell.labelField.text=[NSString stringWithFormat:@"View Controller %d", [indexPath row]];
            cell.labelField.text=[NSString stringWithFormat:@"Contact"];
            cell.labelDetailField.text= [NSString stringWithFormat:@"For any enquiries, please let us know"];
            break;
        default:
            cell.imageLine.image = [UIImage imageNamed:@"lblue"];
            cell.imageField.image= [UIImage imageNamed:@"cup"];
            cell.labelField.text=[NSString stringWithFormat:@"View Controller %d", [indexPath row]];
            //cell.labelField.text=[NSString stringWithFormat:@"Bakeware"];
            cell.labelDetailField.text= [NSString stringWithFormat:@"quis nostrud exerci tation ullamcorper"];
            break;
    }
    
}

- (UIViewController *)contentViewcontrollerForIndexPath:(NSIndexPath *)indexPath
{
    UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
    [bt setFrame:CGRectMake(0, 0, 25, 120)];
    [bt setImage:[UIImage imageNamed:@"menu-icon"] forState:UIControlStateNormal];
    [bt addTarget:[self stackViewController] action:@selector(toggleLeftViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *menuBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem=menuBarButtonItem;
    
    //when view is swiped left to right, revel menu
    UISwipeGestureRecognizer *goRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe)];
    [goRight setDirection:UISwipeGestureRecognizerDirectionRight];
   
    

  
    switch ([indexPath row])
    {
        case 0:
        {
            FrontViewController *viewController0 = [[FrontViewController alloc] initWithNibName:@"FrontViewController" bundle:nil];
            [[viewController0 navigationItem] setLeftBarButtonItem:menuBarButtonItem];
            //UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Show" style:UIBarButtonItemStylePlain target:self action:@selector(rockViewController)];
            //[[viewController0 navigationItem] setRightBarButtonItem:anotherButton];
             [viewController0.view addGestureRecognizer:goRight];
            return viewController0;
            break;
        }
        case 1: {
            BakewareViewController *bakeWareController = [[BakewareViewController alloc] initWithNibName:@"BHCollectionViewController" bundle:nil];
            [[bakeWareController navigationItem] setLeftBarButtonItem:menuBarButtonItem];
             [bakeWareController.view addGestureRecognizer:goRight];
            return bakeWareController ;
            break;
        }
        case 2:{
            CookwareViewController *cookWareController = [[CookwareViewController alloc] initWithNibName:@"BHCollectionViewController" bundle:nil];
            [[cookWareController navigationItem] setLeftBarButtonItem:menuBarButtonItem];
            [cookWareController.view addGestureRecognizer:goRight];
            return cookWareController ;
            break;
        }
        case 3:{
            UtensilsViewController *utensilsController = [[UtensilsViewController alloc] initWithNibName:@"BHCollectionViewController" bundle:nil];
            [[utensilsController navigationItem] setLeftBarButtonItem:menuBarButtonItem];
            [utensilsController.view addGestureRecognizer:goRight];
            return utensilsController ;
            break;
        }
        case 4:{
            KitchenwareViewController *kitchenWareController = [[KitchenwareViewController alloc] initWithNibName:@"BHCollectionViewController" bundle:nil];
            [[kitchenWareController navigationItem] setLeftBarButtonItem:menuBarButtonItem];
            [kitchenWareController.view addGestureRecognizer:goRight];
            return kitchenWareController ;
            break;
        }

        case 5:{
            ContactViewController *contactController = [[ContactViewController alloc]
                initWithNibName:@"ContactViewController" bundle:nil];
            [[contactController navigationItem] setLeftBarButtonItem:menuBarButtonItem];
            [contactController.view addGestureRecognizer:goRight];
            return contactController ;
            break;
        }

        default:{
            CookwareViewController *cookWareController = [[CookwareViewController alloc] initWithNibName:@"BHCollectionViewController" bundle:nil];
            [[cookWareController navigationItem] setLeftBarButtonItem:menuBarButtonItem];
            [cookWareController.view addGestureRecognizer:goRight];
            return cookWareController ;
            break;
        }

    }

    
}

#pragma mark - UITableViewDatasource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BCCell *cell = [tableView dequeueReusableCellWithIdentifier:MTTableViewCellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datasource count];
  
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UINavigationController *navigationController = (UINavigationController *)[[self stackViewController] contentViewController];
    
    [navigationController setViewControllers:@[[self contentViewcontrollerForIndexPath:indexPath]]];
    
    [[self stackViewController] hideRightViewController];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



//[self addLinearGradientToView:viewController0. withColor:[UIColor blackColor] transparentToOpaque:YES];

- (void)addLinearGradientToView:(UIView *)theView withColor:(UIColor *)theColor transparentToOpaque:(BOOL)transparentToOpaque
{
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    //the gradient layer must be positioned at the origin of the view
    CGRect gradientFrame = theView.frame;
    gradientFrame.origin.x = 0;
    gradientFrame.origin.y = 0;
    gradient.frame = gradientFrame;
    
    //build the colors array for the gradient
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[theColor CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.9f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.4f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.5f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.5f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.5f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.5f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.3f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.1f] CGColor],
                       (id)[[UIColor clearColor] CGColor],
                       nil];
    
    //reverse the color array if needed
    if(transparentToOpaque)
    {
        colors = [[colors reverseObjectEnumerator] allObjects];
    }
    
    //apply the colors and the gradient to the view
    gradient.colors = colors;
    
    [theView.layer insertSublayer:gradient atIndex:0];
}


-(void) rightSwipe
{
    [[self stackViewController] toggleLeftViewController];
    
}

@end
