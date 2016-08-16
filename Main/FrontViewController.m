//
//  FrontViewController.m
//  WiltshireMob
//
//  Created by rckrbn on 28/09/13.
//
//

#import "FrontViewController.h"
#import "MTStackViewController.h"

@interface FrontViewController()<UIScrollViewDelegate>
@end
int w = 0;

@implementation FrontViewController
@synthesize pageControl, scroll, awesomeLblView, tapMenu, upArrow;
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
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor redColor];
    scroll.delegate  = self;
    scroll.pagingEnabled = YES;
    NSInteger numberOfViews = 3;
    
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * 275; //275 is the width of the imageView
        // Create 3 views to be placed inside the scrollview
        UIImageView * awesomeView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, scroll.frame.size.width,scroll.frame.size.height)];
        if (i == 0)
        {
            [scroll addSubview:awesomeLblView];
        } else
        if (i == 1)
        {
            awesomeView.image = [UIImage imageNamed:@"frontcutlery"];
            awesomeView.contentMode = UIViewContentModeTop;
            awesomeView.backgroundColor = [UIColor clearColor];
            [scroll addSubview:awesomeView];
        } else
        if (i == 2)
        {
            awesomeView.image = [UIImage imageNamed:@"frontpan"];
            awesomeView.contentMode = UIViewContentModeScaleToFill;
            awesomeView.backgroundColor = [UIColor clearColor];
            [scroll addSubview:awesomeView];
        }
        
    }
    // Scroll's bounds
    scroll.contentSize = CGSizeMake(scroll.frame.size.width * numberOfViews,scroll.frame.size.height);
    // Page Control
    pageControl.numberOfPages = scroll.contentSize.width/scroll.frame.size.width;
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    // Scrollview slideshow effect
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
   
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pageChange:(id)sender {
    //_pageControlUsed = YES;
    CGFloat pageWidth = scroll.contentSize.width /pageControl.numberOfPages;
    CGFloat x = pageControl.currentPage * pageWidth;
    [scroll scrollRectToVisible:CGRectMake(x, 0, pageWidth, scroll.frame.size.height) animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
   
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

        pageControl.currentPage = lround(scroll.contentOffset.x /
                                          (scroll.contentSize.width / pageControl.numberOfPages));
}

- (void) onTimer {
    
    // Updates the variable h, adding the width of the frame
    w += scroll.frame.size.width;
    
    //This makes the scrollView scroll to the desired position
    scroll.contentOffset = CGPointMake(w,0);
    
    pageControl.currentPage = lround(scroll.contentOffset.x /
                                     (scroll.contentSize.width / pageControl.numberOfPages));
        if (pageControl.currentPage == 2)
    {
        w = 0;
        w =  - 275 ;
        
    }
    
}



@end
