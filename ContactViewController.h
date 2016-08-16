//
//  ContactViewController.h
//  WiltshireMob
//
//  Created by rckrbn on 7/10/13.
//
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController


//opens the small window view
- (IBAction)btnWdwView:(id)sender;
//closes the small window view
- (IBAction)btnClsWdwView:(id)sender;
//call or email the developer
- (IBAction)btnPhone:(id)sender;
- (IBAction)btnEmail:(id)sender;
//call mcp
- (IBAction)btnCallMcp:(id)sender;



@end
