//
//  UtensilsViewController.m
//  WiltshireMob
//
//  Created by rckrbn on 7/10/13.
//
//

#import "UtensilsViewController.h"
#import "BHAlbum.h"
#import "BHPhoto.h"

@interface UtensilsViewController ()
@property (nonatomic, strong) NSMutableArray *albums;

@end

@implementation UtensilsViewController

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
	// Do any additional setup after loading the view.
    // Create an array of albums of 1 category which is bakeware
    self.albums = [NSMutableArray array];
    // Get CSV array containing all details of the CSV file
    NSMutableArray *linesarray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"Key"]];
    // Get the array line start of Bakeware Category, other categories will beplaced on other albums
    NSString *category = [NSString stringWithFormat:@"%@",linesarray [107] [1]];
    int i = [linesarray indexOfObjectPassingTest:^BOOL(id element,NSUInteger idx,BOOL *stop)
             {
                 return [(NSArray *)element containsObject:category];
             }];
    BHAlbum *album = [[BHAlbum alloc] init];
    // Get the category of the line
    NSString *lineCat = [NSString stringWithFormat:@"%@",linesarray[i] [1]];
    album.name = [NSString stringWithFormat:@"%@",lineCat];
    // Read every line until category changes
    while ([lineCat isEqualToString: category]) {
        NSString *lineURL = [NSString stringWithFormat:@"%@",linesarray[i] [12]];
        NSString* webStringURL = [lineURL stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSURL *url = [NSURL URLWithString:webStringURL];
        //Get the caption which in this case is the item name.
        NSString *caption = [NSString stringWithFormat:@"%@",linesarray[i] [3]];
        BHPhoto *photo = [BHPhoto photoWithImageURL:url withCaption:caption];
        [album addPhoto:photo];
        i++;
        // Exit the loop if the category changes
        NSString *lineCat = [NSString stringWithFormat:@"%@",linesarray[i] [1]];
        if (![lineCat isEqualToString: category]) {
            break;
        }
    }
    [self.albums addObject:album];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





