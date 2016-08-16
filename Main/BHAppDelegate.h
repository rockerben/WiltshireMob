//
//  BHAppDelegate.h
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCStackViewController.h"

@class BHSplashViewController;

@interface BHAppDelegate : UIResponder <UIApplicationDelegate>
{
    UIImageView *splashView;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BHSplashViewController *splashController;

@property (strong, nonatomic) BCStackViewController *stackViewController;



- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
