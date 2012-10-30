//
//  CLBrowserTableViewController.h
//  Cloudy
//
//  Created by Parag Dulam on 23/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import "CLBaseViewController.h"
#import "AppDelegate.h"
#import "CLWebViewController.h"
#import "CLBrowserCell.h"
#import "AGImagePickerController.h"

@interface CLBrowserTableViewController : CLBaseViewController<DBRestClientDelegate,LiveOperationDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,LiveDownloadOperationDelegate,AGImagePickerControllerDelegate>
{
    NSDictionary *inputDictionary;
    DBRestClient *metaDataRestClient;
    UITableView *browserTableView;
    NSMutableArray *tableData;
    UIActivityIndicatorView *activityIndicator;
    UIToolbar * fileOperationsToolBar;
    UIButton *editButton;
}

@property(nonatomic,strong) NSDictionary *inputDictionary;

-(id) initWithInputDictionary:(NSDictionary *) configDictionary;
-(void) viewShownBySlidingAnimation;

@end
