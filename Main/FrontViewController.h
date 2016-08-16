//
//  FrontViewController.h
//  WiltshireMob
//
//  Created by rckrbn on 28/09/13.
//
//

#import <UIKit/UIKit.h>

@interface FrontViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UILabel *awesomeLblView;
@property (strong, nonatomic) IBOutlet UIImageView *upArrow;
@property (strong, nonatomic) IBOutlet UILabel *tapMenu;
- (IBAction)pageChange:(id)sender;


@end
