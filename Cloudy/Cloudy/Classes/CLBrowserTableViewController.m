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


-(void) viewShownBySlidingAnimation
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    browserTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                    style:UITableViewStylePlain];
    browserTableView.backgroundColor = [UIColor clearColor];
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
//    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
//    [browserTableView addGestureRecognizer:swipeGesture];
//    swipeGesture.delegate = self;
    
    browserTableView.dataSource = self;
    browserTableView.delegate = self;
    [self.view addSubview:browserTableView];
    
    tableData = [[NSMutableArray alloc] init];
    
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor clearColor];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [aView addSubview:activityIndicator];
    aView.frame = activityIndicator.frame;
    activityIndicator.hidesWhenStopped = YES;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aView];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    browserTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setInputDictionary:nil];
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
    for (NSDictionary *mData in [metadataDictionary objectForKey:@"contents"]) {
        if ([[mData objectForKey:@"thumbnailExists"] boolValue]) {
            [metaDataRestClient loadThumbnail:[mData objectForKey:@"path"]
                                       ofSize:@"small"
                                     intoPath:[NSString stringWithFormat:@"%@/%@",[CLCacheManager getTemporaryDirectory],[mData objectForKey:@"filename"]]];
        }
    }
    [tableData removeAllObjects];
    [tableData addObjectsFromArray:[metadataDictionary objectForKey:@"contents"]];
    [browserTableView reloadData];
    [activityIndicator stopAnimating];
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path
{
    for (NSDictionary *mData in tableData) {
        if ([[mData objectForKey:@"thumbnailExists"] boolValue]) {
            [metaDataRestClient loadThumbnail:[mData objectForKey:@"path"]
                                       ofSize:@"small"
                                     intoPath:[NSString stringWithFormat:@"%@/%@",[CLCacheManager getTemporaryDirectory],[mData objectForKey:@"filename"]]];
        }
    }
    [activityIndicator stopAnimating];
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error
{
    [activityIndicator stopAnimating];
}


- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath metadata:(DBMetadata*)metadata
{
    [browserTableView reloadData];
    [activityIndicator stopAnimating];
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error
{
    [activityIndicator stopAnimating];
}


#pragma mark - LiveOperationDelegate


- (void) liveOperationSucceeded:(LiveOperation *)operation 
{
    if (![operation userState]) {
        
//        NSDictionary *result = [parser objectWithString:operation.rawResult];
        NSDictionary *result = operation.result;
        [CLCacheManager updateFolderStructure:result
                                      ForView:SKYDRIVE];
        
        [tableData removeAllObjects];
        NSArray *dataArray = [result objectForKey:@"data"];
        [tableData addObjectsFromArray:dataArray];
        
        for (NSDictionary *data in dataArray) {
            NSArray *images = [data objectForKey:@"images"];
            if ([images count]) {
                NSDictionary *image = [images objectAtIndex:2];
                [self.appDelegate.liveConnectClient downloadFromPath:[image objectForKey:@"source"] delegate:self userState:[data objectForKey:@"name"]];
            }
        }
        
        [browserTableView reloadData];
        [activityIndicator stopAnimating];
    } else if ([operation isKindOfClass:[LiveDownloadOperation class]]) {
        LiveDownloadOperation *downloadOperation = (LiveDownloadOperation *)operation;
        [downloadOperation.data writeToFile:[NSString stringWithFormat:@"%@/%@",[CLCacheManager getTemporaryDirectory],[downloadOperation userState]]
                                 atomically:YES];
        [browserTableView reloadData];
    }
}

- (void) liveOperationFailed:(NSError *)error
                   operation:(LiveOperation*)operation
{
    [activityIndicator stopAnimating];
}

- (void) liveDownloadOperationProgressed:(LiveOperationProgress *)progress
                                    data:(NSData *)receivedData
                               operation:(LiveDownloadOperation *)operation
{
    
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
        } else if ([[data objectForKey:@"type"] isEqualToString:@"photo"]) {
            cellImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[CLCacheManager getTemporaryDirectory],titleText]];
        }
        if (!titleText) {
            titleText = [data objectForKey:@"filename"];
            detailText = [[data objectForKey:@"lastModifiedDate"] description];
            if ([[data objectForKey:@"isDirectory"] boolValue]) {
                cellImage = [UIImage imageNamed:@"folder.png"];
            } else if ([[data objectForKey:@"thumbnailExists"] boolValue]) {
                cellImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[CLCacheManager getTemporaryDirectory],titleText]];
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


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![activityIndicator isAnimating]) {
        switch ([[inputDictionary objectForKey:VIEW_TYPE_STRING] integerValue]) {
            case DROPBOX:
            {
                NSDictionary *metaData = [tableData objectAtIndex:indexPath.row];
                if ([[metaData objectForKey:@"isDirectory"] boolValue]) {
                    NSMutableDictionary *inputDict = [[NSMutableDictionary alloc] init];
                    [inputDict setObject:[metaData objectForKey:@"path"] forKey:PATH];
                    [inputDict setObject:[NSNumber numberWithInteger:DROPBOX]
                                  forKey:VIEW_TYPE_STRING];
                    [inputDict setObject:[metaData  objectForKey:@"filename"]
                                  forKey:@"TITLE"];


                    CLBrowserTableViewController *browserViewController = [[CLBrowserTableViewController alloc] init];
                    [self.navigationController pushViewController:browserViewController animated:YES];
                    [browserViewController setInputDictionary:inputDict];
                } else {
                    NSMutableDictionary *inputDict = [[NSMutableDictionary alloc] init];
                    [inputDict setObject:[metaData objectForKey:@"path"] forKey:FILE_INFO];
                    [inputDict setObject:[NSNumber numberWithInteger:DROPBOX]
                                  forKey:VIEW_TYPE_STRING];
                    [inputDict setObject:[metaData  objectForKey:@"filename"]
                                  forKey:@"TITLE"];

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
                    [inputDict setObject:[selectedDirectory  objectForKey:@"name"]
                                  forKey:@"TITLE"];
                    CLBrowserTableViewController *browserViewController = [[CLBrowserTableViewController alloc] init];
                    [self.navigationController pushViewController:browserViewController animated:YES];
                    [browserViewController setInputDictionary:inputDict];
                } else {
                    NSMutableDictionary *inputDict = [[NSMutableDictionary alloc] init];
//                    [inputDict setObject:[NSString stringWithFormat:@"%@/content",[selectedDirectory objectForKey:@"id"]] forKey:FILE_INFO];
                    [inputDict setObject:[selectedDirectory objectForKey:@"source"] forKey:FILE_INFO];
                    [inputDict setObject:[NSNumber numberWithInteger:SKYDRIVE]
                                  forKey:VIEW_TYPE_STRING];
                    [inputDict setObject:[selectedDirectory  objectForKey:@"name"]
                                  forKey:@"TITLE"];

                    
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
    if ([inputDictionary count]) {
        browserTableView.tableHeaderView = nil;
        NSString *path = [inputDictionary objectForKey:PATH];
        VIEW_TYPE viewType = [[inputDictionary objectForKey:VIEW_TYPE_STRING] integerValue];
        [self.navigationItem setTitle:[inputDictionary objectForKey:@"TITLE"]];
        switch (viewType) {
            case DROPBOX:
            {
                NSString *userId = [[[DBSession sharedSession] userIds] objectAtIndex:0];
                metaDataRestClient = [[DBRestClient alloc] initWithSession:self.appDelegate.dropboxSession
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
                [tableData removeAllObjects];
                NSDictionary *cachedData = [CLCacheManager metaDataDictionaryForPath:path
                                                                             ForView:SKYDRIVE];
                [tableData addObjectsFromArray:[cachedData objectForKey:@"data"]];
                [browserTableView reloadData];
                [activityIndicator startAnimating];
            }
                break;
            default:
                break;
        }
    } else {
        if (![[CLCacheManager accounts] count]) {
            UILabel *addAccountLabel = [[UILabel alloc] init];
            addAccountLabel.text = @"Tap here to add an account";
            [addAccountLabel setFont:[UIFont boldSystemFontOfSize:16.f]];
            addAccountLabel.backgroundColor = [UIColor clearColor];
            addAccountLabel.textColor = [UIColor whiteColor];
            [addAccountLabel sizeToFit];
            
            UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1351499593_arrow_up.png"]];
            [headerView addSubview:addAccountLabel];
            addAccountLabel.center = CGPointMake(roundf(headerView.center.x + 150.f), roundf(headerView.center.y));
            headerView.frame = CGRectMake(0, 0, 320.f, 64.f);
            headerView.contentMode = UIViewContentModeLeft;
            browserTableView.tableHeaderView = headerView;
        }
        [tableData removeAllObjects];
        [browserTableView reloadData];
    }
}


-(NSDictionary *) inputDictionary
{
    return inputDictionary;
}


@end
