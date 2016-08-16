//
//  BCStackViewController.m
//  CollectionViewTutorial
//
//  Created by rckrbn on 21/07/13.
//  Copyright (c) 2013 Ben Cortez. All rights reserved.
//

#import "BCStackViewController.h"
#import "MTMenuViewController.h"

#import "CHCSVParser.h"
#import "Delegate.h"

@interface BCStackViewController ()

@end

@implementation BCStackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [super viewDidLoad];
    
    //parse the CSV file here
    NSString *file = [[NSBundle mainBundle] pathForResource:@"wilt2" ofType:@"csv"];
    NSLog(@"Beginning...");
	NSStringEncoding encoding = 0;
    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:file];
    CHCSVParser * p = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:&encoding delimiter:','];
    [p setRecognizesBackslashesAsEscapes:YES];
    [p setSanitizesFields:YES];
	NSLog(@"encoding: %@", CFStringGetNameOfEncoding(CFStringConvertNSStringEncodingToEncoding(encoding)));
	Delegate * d = [[Delegate alloc] init];
	[p setDelegate:d];
	NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
	[p parse];
	NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
	NSLog(@"raw difference: %f", (end-start));
    [[NSUserDefaults standardUserDefaults] setObject:d.lines forKey:@"Key"];
    //end parse
    
    
    
    //ios 7 status bar fix
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeAll;
    
    [self setAnimationDurationProportionalToPosition:YES];

    // This is the LEFT VIEW CONTROLLER
    MTMenuViewController *menuViewController = [[MTMenuViewController alloc] initWithNibName:nil bundle:nil];
    [self setLeftViewController:menuViewController];
   
    // This is the RIGHT VIEW CONTROLLER
    //UITableViewController* rightViewController = [[UITableViewController alloc] initWithNibName:nil bundle:nil];
    //[self setRightViewController:rightViewController];
    //self.rightViewControllerEnabled = YES;
   
    // This is the MIDDLE VIEW NAVIGATION CONTROLLER
    UINavigationController *contentNavigationController = [UINavigationController new];
    
    // Rounded corners of the middle navigation bar
    CALayer *capa = [contentNavigationController navigationBar].layer;
    [capa setShouldRasterize:YES];
    //Round
    CGRect bounds = capa.bounds;
    bounds.size.height += 10.0f;    //I'm reserving enough room for the shadow
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    [capa addSublayer:maskLayer];
    capa.mask = maskLayer;
    
    [self setContentViewController:contentNavigationController];
    
    // Set middle navbar image
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed: @"1"]
                                       forBarMetrics:UIBarMetricsDefault];
    
   
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
