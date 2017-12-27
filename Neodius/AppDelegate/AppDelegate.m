//
//  AppDelegate.m
//  Neodius
//
//  Created by Benjamin de Bos on 16-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//
#import "AppDelegate.h"
#import "menuTableViewController.h"
#import "walletViewTableViewController.h"
#import "baseMarketInfoViewController.h"
#import "NeodiusDataSource.h"
#import "neodiusUIComponents.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@implementation AppDelegate
@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [UINavigationBar appearance].barTintColor = neoGreenColor;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{
                                                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                                           NSFontAttributeName : [UIFont fontWithName:FONT size:22]
                                                           };

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor whiteColor]];
    
    UIViewController *centerController = [[walletViewTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UIViewController *menuController = [[menuTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    //create navigation controller for center
    centerController = [[UINavigationController alloc] initWithRootViewController:centerController];
    
    //create viewdeck controller
    deckController = [[IIViewDeckController alloc] initWithCenterViewController:centerController leftViewController:menuController];

    self.window.rootViewController = deckController;
    
    [_window makeKeyAndVisible];

    [LTHPasscodeViewController useKeychain:YES];
    [LTHPasscodeViewController sharedUser].touchIDString = NSLocalizedString(@"Use TouchID to unlock Neodius", nil);
    [LTHPasscodeViewController sharedUser].backgroundColor = [UIColor whiteColor];
    [LTHPasscodeViewController sharedUser].backgroundImage = [UIImage imageNamed:@"menuLogo"];
    [LTHPasscodeViewController sharedUser].labelTextColor = neoGreenColor;
    [LTHPasscodeViewController sharedUser].labelFont = [UIFont fontWithName:FONT_LIGHT size:20];
    
    [Instabug startWithToken:@"04f8d4215669322237207f2fae43def6" invocationEvent:IBGInvocationEventShake];
    
    if ([LTHPasscodeViewController doesPasscodeExist]) {
        if ([LTHPasscodeViewController didPasscodeTimerEnd]) {
            [[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:NO
                                                                     withLogout:NO
                                                                 andLogoutTitle:nil];
        }
    }

    //Launch fabric for crash reporting
    [Fabric with:@[[Crashlytics class]]];
    
    return YES;
}




-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end

