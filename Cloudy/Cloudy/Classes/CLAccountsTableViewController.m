//
//  CLAccountsTableViewController.m
//  Cloudy
//
//  Created by Parag Dulam on 23/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import "CLAccountsTableViewController.h"


@interface CLAccountsTableViewController ()

@end

@implementation CLAccountsTableViewController

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
    CGRect rect = self.navigationController.view.bounds;
    rect.size.width -= 40.f;
    self.navigationController.view.frame = rect;
    
    rect = self.view.bounds;
    rect.size.width -= 40.f;
    self.view.frame = rect;

    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [editButton setTitle:@"Done" forState:UIControlStateSelected];
    [editButton setBackgroundImage:[UIImage imageNamed:@"editButton.png"] forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editButton addTarget:self
                   action:@selector(editButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [editButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.f]];
    [editButton setFrame:CGRectMake(0, 0, 50, 30)];
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    [self.navigationItem setLeftBarButtonItem:editBarButtonItem];

    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor clearColor];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [aView addSubview:activityIndicator];
    aView.frame = activityIndicator.frame;
    activityIndicator.hidesWhenStopped = YES;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aView];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    
    
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
//    titleLabel.text = @"Accounts";
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textColor = [UIColor whiteColor];
//    [titleLabel sizeToFit];
//    [self.navigationItem setTitleView:titleLabel];
    self.title = @"Accounts";
    
    accountsTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                     style:UITableViewStyleGrouped];
    accountsTableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    accountsTableView.backgroundView = nil;
    
    
    accountsTableView.dataSource = self;
    accountsTableView.delegate = self;
    [self.view addSubview:accountsTableView];
    NSArray *storedAccounts = [CLCacheManager accounts];
    if (![storedAccounts count]) {
        editButton.hidden = YES;
        accounts = [[NSMutableArray alloc] initWithObjects:@"Dropbox",@"SkyDrive", nil];
    } else {
        editButton.hidden = NO;
        accounts = [[NSMutableArray alloc] initWithArray:storedAccounts];
        switch ([storedAccounts count]) {
            case 1:
            {
                NSDictionary *account = [accounts objectAtIndex:0];
                VIEW_TYPE accountType = [[account objectForKey:ACCOUNT_TYPE] intValue];
                switch (accountType) {
                    case DROPBOX:
                        [accounts insertObject:@"SkyDrive" atIndex:1];
                        break;
                    case SKYDRIVE:
                        [accounts insertObject:@"Dropbox" atIndex:0];
                        break;
                    default:
                        break;
                }
            }
                break;
                
            default:
                break;
        }

    }
    [accountsTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Helper Methods


-(void) editButtonClicked:(UIButton *) sender
{
    sender.selected = !sender.selected;
    [accountsTableView setEditing:sender.selected animated:YES];
//    
//    if (!accountsTableView.editing) {
//        [accountsTableView setEditing:YES animated:YES];
//    } else {
//        [accountsTableView setEditing:NO animated:YES];
//    }
}



-(void) performTableViewAnimationForIndexPath:(NSIndexPath *) indexPath withAnimationSequence:(NSArray *) sequence
{
    [accountsTableView beginUpdates];
    
    [accountsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:[[sequence objectAtIndex:0] integerValue]];
    
    [accountsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:[[sequence objectAtIndex:1] integerValue]];
    
    
    [accountsTableView endUpdates];
    [activityIndicator stopAnimating];
}

-(void) showRootViewController:(VIEW_TYPE) type
{
    NSMutableDictionary *configDictionary = [[NSMutableDictionary alloc] init];
    [configDictionary setObject:[NSNumber numberWithInteger:type]
                         forKey:VIEW_TYPE_STRING];
    DDMenuController *menuController = (DDMenuController *)self.appDelegate.window.rootViewController;
    UINavigationController *navController = (UINavigationController *)menuController.rootViewController; 
    CLBrowserTableViewController *browserViewController = (CLBrowserTableViewController *)[navController.viewControllers objectAtIndex:0];
    [menuController setRootController:navController
                             animated:YES];
    switch (type) {
        case DROPBOX:
            [configDictionary setObject:DROPBOX_STRING
                                 forKey:@"TITLE"];
            [configDictionary setObject:@"dropbox_cell_Image.png" forKey:@"IMAGE_NAME"];
            break;
        case SKYDRIVE:
            [configDictionary setObject:SKYDRIVE_STRING
                                 forKey:@"TITLE"];
            [configDictionary setObject:@"SkyDriveIconWhite_32x32.png" forKey:@"IMAGE_NAME"];
            break;
        default:
            break;
    }
    [browserViewController setInputDictionary:configDictionary];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"CELL"];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    id object = [accounts objectAtIndex:indexPath.section];
    NSString *titleText = nil;
    UIImage *cellImage = nil;
    if ([object isKindOfClass:[NSString class]]) {
        titleText = (NSString *)object;
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *data = (NSDictionary *)object;
        titleText = [data objectForKey:@"displayName"];
    }
    
    switch (indexPath.section) {
        case DROPBOX:
            cellImage = [UIImage imageNamed:@"dropbox_cell_Image.png"];
            break;
        case SKYDRIVE:
            cellImage = [UIImage imageNamed:@"SkyDriveIconWhite_32x32.png"];
            break;
        default:
            break;
    }

    
    [cell.textLabel setText:titleText];
    [cell.imageView setImage:cellImage];
    return cell;
}


-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:55.f/255.f
                                           green:55.f/255.f
                                            blue:55.f/255.f
                                           alpha:1.f];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [accounts count];
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![activityIndicator isAnimating]) {
        UIViewController *vc = self.appDelegate.window.rootViewController;
        switch (indexPath.section) {
            case 0:
            {
                //Dropbox
                if (![[[DBSession sharedSession] userIds] count] && ![[DBSession sharedSession] isLinked]) {
                    [[DBSession sharedSession] linkFromController:vc];
                    self.appDelegate.callBackViewController = self;
                } else {
                    [self showRootViewController:DROPBOX];
                }
            }
                break;
            case 1:
            {
                //SkyDrive
                if (self.appDelegate.liveConnectClient.session == nil) {
                    [self.appDelegate.liveConnectClient login:vc
                                                       scopes:SCOPE_ARRAY
                                                     delegate:self];
                } else {
                    [self showRootViewController:SKYDRIVE];
                }
            }
                break;
                
                
            default:
                break;
        }
    }
}



- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *retVal = @"Logout";
    switch (indexPath.section)
    {
        case 0:
            retVal = @"UnLink";
            break;
            
        default:
            break;
    }
    return retVal;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    id key = [accounts objectAtIndex:indexPath.section];
    return ![key isKindOfClass:[NSString class]];
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CLCacheManager deleteAccount:[CLCacheManager getAccountForType:indexPath.section]];
    [CLCacheManager deleteFileStructureForView:indexPath.section];
    
    switch (indexPath.section) {
        case 0:
        {
            [accounts replaceObjectAtIndex:0 withObject:@"Dropbox"];
            DBSession *sharedSession = [DBSession sharedSession];
            NSString *userId = [[sharedSession userIds] objectAtIndex:0];
            [sharedSession unlinkUserId:userId];
        }
            break;
        case 1:
        {
            [accounts replaceObjectAtIndex:1 withObject:@"SkyDrive"];
            [self.appDelegate.liveConnectClient logout];
        }
            break;
        default:
            break;
    }
    NSArray *sequenceArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:UITableViewRowAnimationRight],[NSNumber numberWithInteger:UITableViewRowAnimationLeft], nil];
    [self performTableViewAnimationForIndexPath:indexPath withAnimationSequence:sequenceArray];
    [self editButtonClicked:editButton];
    
    [self.appDelegate initialSetup];
    if (![[CLCacheManager accounts] count]) {
        editButton.hidden = YES;
    }
}


#pragma mark - Loading Methods

-(void) startAnimating
{
    [activityIndicator startAnimating];
}


-(void) stopAnimating
{
    [activityIndicator stopAnimating];
}



#pragma mark - Authentication For Dropbox

-(void)authenticationDoneForSession:(DBSession *)session
{
    restClient = [[DBRestClient alloc] initWithSession:session
                                                              userId:[[session userIds] objectAtIndex:0]];
    restClient.delegate = self;
    [restClient loadAccountInfo];
    self.appDelegate.callBackViewController = nil;
    [activityIndicator startAnimating];
}

-(void)  authenticationCancelledManuallyForSession:(DBSession *) session
{
    self.appDelegate.callBackViewController = nil;
}


#pragma mark - LiveAuthDelegate

- (void) authCompleted: (LiveConnectSessionStatus) status
               session: (LiveConnectSession *) session
             userState: (id) userState
{
    [self.appDelegate.liveConnectClient getWithPath:@"/me"
                                           delegate:self];
    [activityIndicator startAnimating];
}

- (void) authFailed: (NSError *) error
          userState: (id)userState
{
    
}


#pragma mark - LiveOperationDelegate

- (void) liveOperationSucceeded:(LiveOperation *)operation
{
    NSDictionary *result = [CLDictionaryConvertor dictionaryFromAccountInfo:operation.result];
    [CLCacheManager storeAccount:result];
    [accounts replaceObjectAtIndex:1 withObject:result];
    NSArray *sequenceArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:UITableViewRowAnimationLeft],[NSNumber numberWithInteger:UITableViewRowAnimationRight], nil];
    [self performTableViewAnimationForIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] withAnimationSequence:sequenceArray];
    editButton.hidden = NO;
    [self tableView:accountsTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
}

- (void) liveOperationFailed:(NSError *)error
                   operation:(LiveOperation*)operation
{
    
}


#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info
{
    NSDictionary *accountInfo = [CLDictionaryConvertor dictionaryFromAccountInfo:info];
    [CLCacheManager storeAccount:accountInfo];
    [accounts replaceObjectAtIndex:0 withObject:accountInfo];
    NSArray *sequenceArray = [NSArray arrayWithObjects:[NSNumber numberWithInteger:UITableViewRowAnimationLeft],[NSNumber numberWithInteger:UITableViewRowAnimationRight], nil];
    [self performTableViewAnimationForIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] withAnimationSequence:sequenceArray];
    editButton.hidden = NO;
    [self tableView:accountsTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

}

- (void)restClient:(DBRestClient*)client loadAccountInfoFailedWithError:(NSError*)error
{
    
}

@end
