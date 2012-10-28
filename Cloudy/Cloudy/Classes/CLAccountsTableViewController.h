//
//  CLAccountsTableViewController.h
//  Cloudy
//
//  Created by Parag Dulam on 23/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import "CLBaseViewController.h"
#import "AppDelegate.h"
#import "CLBrowserTableViewController.h"
#import "Constants.h"

@interface CLAccountsTableViewController : CLBaseViewController<UITableViewDataSource,UITableViewDelegate,LiveAuthDelegate,LiveOperationDelegate,DBRestClientDelegate>
{
    UITableView *accountsTableView;
    NSMutableArray *accounts;
    DBRestClient *restClient;
    UIActivityIndicatorView *activityIndicator;
    UIButton *editButton;
}

-(void)authenticationDoneForSession:(DBSession *)session;
-(void)  authenticationCancelledManuallyForSession:(DBSession *) session;
-(void) performTableViewAnimationForIndexPath:(NSIndexPath *) indexPath;
-(void) showRootViewController:(VIEW_TYPE) type;
-(void) startAnimating;
-(void) stopAnimating;


@end
