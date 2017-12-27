//
//  settingsTableViewController.m
//  Neodius
//
//  Created by Benjamin de Bos on 16-09-17.
//  Copyright © 2017 ITS-VIsion. All rights reserved.
//

#import "settingsTableViewController.h"
#import "selectionSettingsTableViewController.h"
#import "walletManagementTableViewController.h"

@implementation settingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Settings", nil);
    UIImage *menuIcon = [UIImage imageWithIcon:@"fa-reorder"
                               backgroundColor:[UIColor clearColor]
                                     iconColor:[UIColor redColor]
                                     iconScale:1.0
                                       andSize:CGSizeMake(24, 24)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:menuIcon
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(openLeftSide)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged:) name:NSCurrentLocaleDidChangeNotification object:nil];
}

- (void)languageChanged:(NSNotification *)notification {
    [self.tableView reloadData];
    self.title = NSLocalizedString(@"Settings", nil);
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont fontWithName:FONT_LIGHT size:header.textLabel.font.pointSize];
}


-(void)viewWillAppear:(BOOL)animated {
    baseFiat        = [[NeodiusDataSource sharedData] getFiatData][[[NeodiusDataSource sharedData] getBaseFiat]];
    baseCrypto      = [[NeodiusDataSource sharedData] getCryptoData][[[NeodiusDataSource sharedData] getBaseCrypto]];
    refreshInterval = [[NeodiusDataSource sharedData] getIntervalData][[[NeodiusDataSource sharedData] getRefreshInterval]];
    [self.tableView reloadData];
}

-(void)openLeftSide {
    [self.viewDeckController openSide:IIViewDeckSideLeft animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 3;

    if (section == 4)
        return 1;
    
    return 2;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return NSLocalizedString(@"General",nil);
    else if (section == 1)
        return NSLocalizedString(@"Currency",nil);
    else if (section == 2)
        return NSLocalizedString(@"Security",nil);
    
    return NSLocalizedString(@"Visual and messages",nil);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];

    if (cell == nil) {
        if (indexPath.section == 0 || indexPath.section == 1) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"menuCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.font = [UIFont fontWithName:FONT_LIGHT size:16];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.detailTextLabel.font = [UIFont fontWithName:FONT_LIGHT size:16];
        cell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = neoGreenColor;
        cell.selectedBackgroundView = selectionColor;
    }
    
    NSString *icon;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Wallet management", nil);
            icon = @"fa-folder-o";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Wallet refresh interval", nil);
            cell.detailTextLabel.text = [[NeodiusDataSource sharedData] switchIntervalLabel:refreshInterval[@"labelValue"]
                                                                                    andType:refreshInterval[@"labelType"]];
            icon = @"fa-clock-o";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"Language", nil);
            icon = @"fa-globe";
            NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:[NSBundle defaultLanguage]];
            cell.detailTextLabel.text = [currentLocale displayNameForKey:NSLocaleIdentifier value:[NSBundle defaultLanguage]];
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Base fiat currency", nil);
            
            cell.detailTextLabel.text = baseFiat[@"name"];
            icon = @"fa-usd";
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Base crypto currency", nil);
            cell.detailTextLabel.text = baseCrypto[@"name"];
            icon = @"fa-bitcoin";
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Secure app with passcode",nil);
            icon = @"fa-lock";
            securitySwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            securitySwitch.tintColor = neoGreenColor;
            securitySwitch.tag = 0;
            securitySwitch.on = [LTHPasscodeViewController doesPasscodeExist];
            [securitySwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = securitySwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = ([self isTouchIDAvailable] ? NSLocalizedString(@"TouchID", nil) : NSLocalizedString(@"TouchID (not available)", nil));
            icon = @"fa-hand-o-up";
            touchIdSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            touchIdSwitch.tintColor = neoGreenColor;
            touchIdSwitch.tag = 1;
            touchIdSwitch.enabled = ([LTHPasscodeViewController doesPasscodeExist] && [self isTouchIDAvailable]);
            touchIdSwitch.on = [LTHPasscodeViewController sharedUser].allowUnlockWithTouchID;
            [touchIdSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = touchIdSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            icon = @"fa-spinner";
            cell.textLabel.text = NSLocalizedString(@"Refresh timer", nil);
            showTimer = [[UISwitch alloc] initWithFrame:CGRectZero];
            showTimer.tintColor = neoGreenColor;
            showTimer.tag = 2;
            showTimer.on = [[NeodiusDataSource sharedData] getShowTimer];
            [showTimer addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = showTimer;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            icon = @"fa-commenting-o";
            cell.textLabel.text = NSLocalizedString(@"Connection status messages", nil);
            showMessages = [[UISwitch alloc] initWithFrame:CGRectZero];
            showMessages.tintColor = neoGreenColor;
            showMessages.tag = 3;
            showMessages.on = [[NeodiusDataSource sharedData] getShowMessages];
            [showMessages addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = showMessages;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            icon = @"fa-globe";
            cell.textLabel.text = NSLocalizedString(@"Use MainNet blockchain", nil);
            useMainNet = [[UISwitch alloc] initWithFrame:CGRectZero];
            useMainNet.tintColor = neoGreenColor;
            useMainNet.tag = 4;
            useMainNet.on = [[NeodiusDataSource sharedData] getUseMainNet];
            [useMainNet addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = useMainNet;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }

    cell.imageView.image = [[NeodiusDataSource sharedData] tableIconPositive:icon];
    cell.imageView.highlightedImage = [[NeodiusDataSource sharedData] tableIconNegative:icon];
    
    return cell;

}

-(void)toggleSwitch:(id)sender {
    UISwitch *switchControl = sender;
    
    if (switchControl.tag == 0) {
        if (switchControl.on) {
            [[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController:self
                                                                                    asModal:NO];
        } else {
            [[LTHPasscodeViewController sharedUser] showForDisablingPasscodeInViewController:self
                                                                                     asModal:NO];
            [[LTHPasscodeViewController sharedUser] setAllowUnlockWithTouchID:NO];
        }
    } else if (switchControl.tag == 1) {
        
        if (switchControl.on) {
            [LTHPasscodeViewController sharedUser].enablePasscodeString = @"Aan";
        } else {
            [LTHPasscodeViewController sharedUser].enablePasscodeString = @"Uit";
        }
        [LTHPasscodeViewController sharedUser].allowUnlockWithTouchID = switchControl.on;

    } else if (switchControl.tag == 2) {
        [[NeodiusDataSource sharedData] setShowTimer:switchControl.on];
    } else if (switchControl.tag == 3) {
        [[NeodiusDataSource sharedData] setShowMessages:switchControl.on];
    } else if (switchControl.tag == 4) {
        [[NeodiusDataSource sharedData] setUseMainNet:switchControl.on];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectionSettingsTableViewController *sstvc = [[selectionSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[walletManagementTableViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        } else if (indexPath.row == 1) {
            sstvc.type = @"refreshInterval";
            [self.navigationController pushViewController:sstvc animated:YES];
        } else {
            GSLanguagePickerController *vc = [GSLanguagePickerController new];
            vc.useDoneButton = NO;
            vc.cellSelectedFontColor = [UIColor whiteColor];
            vc.cellSelectedBackgroundColor = neoGreenColor;
            vc.cellTintColor = neoGreenColor;
            vc.cellFont = [UIFont fontWithName:FONT size:16.0];
            vc.cellDetailFont = [UIFont fontWithName:FONT_LIGHT size:14.0];
            vc.title = NSLocalizedString(@"Language", nil);
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            sstvc.type = @"fiat";
        } else {
            sstvc.type = @"crypto";
        }
        [self.navigationController pushViewController:sstvc animated:YES];
    }
}

- (BOOL)isTouchIDAvailable {
    if ([[UIDevice currentDevice].systemVersion compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)
        return [[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    return NO;
}




@end
