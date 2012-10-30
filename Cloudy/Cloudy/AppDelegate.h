//
//  AppDelegate.h
//  Cloudy
//
//  Created by Parag Dulam on 23/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"
#import "CLBaseViewController.h"
#import "CLAccountsTableViewController.h"
#import "DropboxSDK.h"
#import "LiveConnectClient.h"
#import "Constants.h"

@class CLAccountsTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,DBSessionDelegate,LiveAuthDelegate,DDMenuControllerDelegate>
{
    DBSession *dropboxSession;
    LiveConnectClient *liveConnectClient;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DBSession *dropboxSession;
@property (strong, nonatomic) LiveConnectClient *liveConnectClient;
@property (weak,nonatomic) CLAccountsTableViewController *callBackViewController;

-(void) initialSetup;



@end
