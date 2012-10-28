//
//  CLBrowserTableViewController.m
//  Cloudy
//
//  Created by Parag Dulam on 23/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import "CLBrowserTableViewController.h"
#import "CLAccountsTableViewController.h"

@interface CLBrowserTableViewController ()

@end

@implementation CLBrowserTableViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithInputDictionary:(NSDictionary *) configDictionary
{
    if (self = [super init]) {
        self.inputDictionary = configDictionary;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    browserTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                    style:UITableViewStylePlain];
    browserTableView.backgroundColor = [UIColor clearColor];
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [browserTableView addGestureRecognizer:swipeGesture];
    swipeGesture.delegate = self;
    
    browserTableView.dataSource = self;
    browserTableView.delegate = self;
    [self.view addSubview:browserTableView];
    
    tableData = [[NSMutableArray alloc] init];
    restClients = [[NSMutableArray alloc] init];
    
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor clearColor];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [aView addSubview:activityIndicator];
    aView.frame = activityIndicator.frame;
    activityIndicator.hidesWhenStopped = YES;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aView];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    browserTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizerDelegate

-(void) cellSwiped:(UIGestureRecognizer *) gestureRecognizer
{
    NSLog(@"swiped");
//    CGPoint location = [gestureRecognizer locationInView:browserTableView];
//    
//    //Get the corresponding index path within the table view
//    NSIndexPath *indexPath = [browserTableView indexPathForRowAtPoint:location];
//    
//    //Check if index path is valid
//    if(indexPath)
//    {
//        //Get the cell out of the table view
//        UITableViewCell *cell = [browserTableView cellForRowAtIndexPath:indexPath];
//        
//        //Update the cell or model
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return  YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}



#pragma mark - DBRestClientDelegate


//-(void) readPathsForMetadata:(DBMetadata *)data
//{
//    if ([data.contents count]) {
//        for (DBMetadata *mData in data.contents) {
//            [self readPathsForMetadata:mData];
//        }
//    } else {
//        NSLog(@"Path %@",data.path);
//    }
//}

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata
{
    NSDictionary *metadataDictionary = [CLDictionaryConvertor dictionaryFromMetadata:metadata];
    [CLCacheManager updateFolderStructure:metadataDictionary
                                  ForView:DROPBOX];
    [tableData removeAllObjects];
    [tableData addObjectsFromArray:[metadataDictionary objectForKey:@"contents"]];
    [browserTableView reloadData];
    [activityIndicator stopAnimating];
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path
{
    [activityIndicator stopAnimating];
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error
{
    [activityIndicator stopAnimating];
}


- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath metadata:(DBMetadata*)metadata
{
    [activityIndicator stopAnimating];
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error
{
    [activityIndicator stopAnimating];
}


#pragma mark - LiveOperationDelegate


- (void) liveOperationSucceeded:(LiveOperation *)operation
{
    NSDictionary *result = operation.result;
    
    [CLCacheManager updateFolderStructure:result
                                  ForView:SKYDRIVE];
    [tableData removeAllObjects];
    [tableData addObjectsFromArray:[result objectForKey:@"data"]];
    [browserTableView reloadData];
    [activityIndicator stopAnimating];
}

- (void) liveOperationFailed:(NSError *)error
                   operation:(LiveOperation*)operation
{
    [activityIndicator stopAnimating];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLBrowserCell *cell = (CLBrowserCell *)[tableView dequeueReusableCellWithIdentifier:@"CLBrowserCell"];
    if (!cell) {
        cell = [[CLBrowserCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"CLBrowserCell"];
    }
    id object = [tableData objectAtIndex:indexPath.row];
    UIImage *cellImage = nil;
    NSString *titleText = nil;
    NSString *detailText = nil;

    if ([object isKindOfClass:[NSString class]]) {
        titleText = (NSString *)object;
    } else if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *data = (NSDictionary *)object;
        titleText = [data objectForKey:@"name"];
        detailText = [data objectForKey:@"updated_time"];
        if ([[data objectForKey:@"type"] isEqualToString:@"folder"] || [[data objectForKey:@"type"] isEqualToString:@"album"]) {
            cellImage = [UIImage imageNamed:@"folder.png"];
        }
        if (!titleText) {
            titleText = [data objectForKey:@"filename"];
            detailText = [[data objectForKey:@"lastModifiedDate"] description];
            if ([[data objectForKey:@"isDirectory"] boolValue]) {
                cellImage = [UIImage imageNamed:@"folder.png"];
            }
        }
    } else if ([object isKindOfClass:[DBMetadata class]]) {
        DBMetadata *metaData = (DBMetadata *)object;
        titleText = [[metaData.path componentsSeparatedByString:@"/"] lastObject];
        if (metaData.thumbnailExists) {
            NSString *imagePath = [NSString stringWithFormat:@"%@/%@",[CLCacheManager getDocumentsDirectory],[[metaData.path componentsSeparatedByString:@"/"] lastObject]];
            cellImage = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    [cell.textLabel setText:titleText];
    [cell.detailTextLabel setText:detailText];
    [cell.imageView setImage:cellImage];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![activityIndicator isAnimating]) {
        switch ([[inputDictionary objectForKey:VIEW_TYPE_STRING] integerValue]) {
            case DROPBOX:
            {
//                DBMetadata *metaData = [tableData objectAtIndex:indexPath.row];
                NSDictionary *metaData = [tableData objectAtIndex:indexPath.row];
                if ([[metaData objectForKey:@"isDirectory"] boolValue]) {
                    NSMutableDictionary *inputDict = [[NSMutableDictionary alloc] init];
                    [inputDict setObject:[metaData objectForKey:@"path"] forKey:PATH];
                    [inputDict setObject:[NSNumber numberWithInteger:DROPBOX]
                                  forKey:VIEW_TYPE_STRING];

                    CLBrowserTableViewController *browserViewController = [[CLBrowserTableViewController alloc] init];
                    [self.navigationController pushViewController:browserViewController animated:YES];
                    [browserViewController setInputDictionary:inputDict];
                } else {
                    NSMutableDictionary *inputDict = [[NSMutableDictionary alloc] init];
                    [inputDict setObject:[metaData objectForKey:@"path"] forKey:FILE_INFO];
                    [inputDict setObject:[NSNumber numberWithInteger:DROPBOX]
                                  forKey:VIEW_TYPE_STRING];

                    CLWebViewController *webViewController = [[CLWebViewController alloc] init];
                    [self.navigationController pushViewController:webViewController animated:YES];
                    [webViewController setInputDictionary:inputDict];
                }
            }
                break;
            case SKYDRIVE:
            {
                NSDictionary *selectedDirectory = [tableData objectAtIndex:indexPath.row];

                NSString *idStr = [selectedDirectory objectForKey:@"id"];
                if ([[selectedDirectory objectForKey:@"type"] isEqualToString:@"folder"] || [[selectedDirectory objectForKey:@"type"] isEqualToString:@"album"]) {
                    NSMutableDictionary *inputDict = [[NSMutableDictionary alloc] init];
                    NSString *path = [NSString stringWithFormat:@"%@/files",idStr];
                    [inputDict setObject:path forKey:PATH];
                    [inputDict setObject:[NSNumber numberWithInteger:SKYDRIVE]
                                  forKey:VIEW_TYPE_STRING];
                    CLBrowserTableViewController *browserViewController = [[CLBrowserTableViewController alloc] init];
                    [self.navigationController pushViewController:browserViewController animated:YES];
                    [browserViewController setInputDictionary:inputDict];
                } else {
                    NSMutableDictionary *inputDict = [[NSMutableDictionary alloc] init];
//                    [inputDict setObject:[NSString stringWithFormat:@"%@/content",[selectedDirectory objectForKey:@"id"]] forKey:FILE_INFO];
                    [inputDict setObject:[selectedDirectory objectForKey:@"source"] forKey:FILE_INFO];
                    [inputDict setObject:[NSNumber numberWithInteger:SKYDRIVE]
                                  forKey:VIEW_TYPE_STRING];
                    
                    CLWebViewController *webViewController = [[CLWebViewController alloc] init];
                    [self.navigationController pushViewController:webViewController animated:YES];
                    [webViewController setInputDictionary:inputDict];
                }
            }
                break;
            default:
                break;
        }
    }
}





#pragma mark - Setter & Getter Methods


-(void) setInputDictionary:(NSDictionary *)aDictionary
{
    inputDictionary = aDictionary;
    NSString *path = [inputDictionary objectForKey:PATH];
    VIEW_TYPE viewType = [[inputDictionary objectForKey:VIEW_TYPE_STRING] integerValue];
    
    switch (viewType) {
        case DROPBOX:
        {
            NSString *userId = [[[DBSession sharedSession] userIds] objectAtIndex:0];
            metaDataRestClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]
                                                        userId:userId];
            metaDataRestClient.delegate = self;
            if (!path) {
                path = @"/";
            }
            NSDictionary *cachedDict = [CLCacheManager metaDataDictionaryForPath:path ForView:DROPBOX];
            NSArray *contents = [cachedDict objectForKey:@"contents"];
            [tableData removeAllObjects];
            [tableData addObjectsFromArray:contents];
            [browserTableView reloadData];
            NSString *hash = [cachedDict objectForKey:@"hash"];
            [metaDataRestClient loadMetadata:path withHash:hash];
            [activityIndicator startAnimating];
        }
            break;
        case SKYDRIVE:
        {
            if (!path) {
                path = @"me/skydrive/files";
            }
            [self.appDelegate.liveConnectClient getWithPath:path
                                                   delegate:self];
            [activityIndicator startAnimating];
        }
            break;
        default:
            break;
    }
}


-(NSDictionary *) inputDictionary
{
    return inputDictionary;
}


@end
