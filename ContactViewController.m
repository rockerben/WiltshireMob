//
//  ContactViewController.m
//  WiltshireMob
//
//  Created by rckrbn on 7/10/13.
//
//

#import "ContactViewController.h"
#include "math.h"
#import <MessageUI/MessageUI.h>

@interface ContactViewController () <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *popView;
@end

@implementation ContactViewController
@synthesize popView;
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
       
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnWdwView:(id)sender {
    [popView setFrame:CGRectMake(0, 280, 320, 150)];
    [self.view addSubview:popView];
}

- (IBAction)btnClsWdwView:(id)sender {
    [popView removeFromSuperview];
}

- (IBAction)btnPhone:(id)sender {
    NSString *phoneNumber = @"telprompt://+61449652913";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)btnEmail:(id)sender {
    [self showMailComposerAndSend];
}

-(void)showMailComposerAndSend {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"(Via Wiltshire Kitchen App.)"];
        NSMutableString *emailBody = [NSMutableString string];
                [mailer setMessageBody:emailBody isHTML:YES];
        [self presentViewController:mailer animated:YES completion:^{}];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Mail Failure"
                              message:
                              @"Your device doesn't support in-app email"
                              delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show]; }
}

- (void)mailComposeController: (MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)btnCallMcp:(id)sender {
    NSString *phoneNumber = @"telprompt://+61293708000";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
@end
