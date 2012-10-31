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
    CGRect browserTableViewFrame = self.view.bounds;
    browserTableViewFrame.size.height -= 88.f;
    browserTableView = [[UITableView alloc] initWithFrame:browserTableViewFrame
                                                    style:UITableViewStylePlain];
    browserTableView.backgroundColor = [UIColor clearColor];
    browserTableView.dataSource = self;
    browserTableView.delegate = self;
    [self.view addSubview:browserTableView];
    browserTableView.allowsMultipleSelectionDuringEditing = YES;
    
    tableData = [[NSMutableArray alloc] init];
    
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor clearColor];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [aView addSubview:activityIndicator];
    aView.frame = activityIndicator.frame;
    
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [editButton setTitle:@"Done" forState:UIControlStateSelected];
    [editButton setBackgroundImage:[UIImage imageNamed:@"editButton.png"] forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editButton addTarget:self
                   action:@selector(editButtonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [editButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.f]];
    [editButton setFrame:CGRectMake(CGRectGetMaxX(activityIndicator.frame) + 5.f, 0, 50, 30)];
    [aView addSubview:editButton];
    [aView setFrame:CGRectMake(0, 0, CGRectGetMaxX(editButton.frame), 30.f)];

    activityIndicator.hidesWhenStopped = YES;
    activityIndicator.center = CGPointMake(activityIndicator.center.x, aView.frame.size.height/2);
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aView];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    browserTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    fileOperationsToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(browserTableViewFrame), 320.f, 44.f)];
    fileOperationsToolBar.tintColor = [UIColor blackColor];
    [self.view addSubview:fileOperationsToolBar];
    
    [self deSelectEditMode];
    [self setInputDictionary:inputDictionary];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Helper Methods


-(void) deSelectEditMode
{
    editButton.selected = YES;
    [self editButtonClicked:editButton];
}



#pragma mark - UIImagePickerControllerDelegate


- (void)agImagePickerController:(AGImagePickerController *)picker
  didFinishPickingMediaWithInfo:(NSArray *)info
{
//    for (ALAsset *asset in info) {
//        CGImageRef imageRef = [[asset defaultRepresentation] fullResolutionImage];
//        UIImage *image = [UIImage imageWithCGImage:imageRef];
//        
//    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)agImagePickerController:(AGImagePickerController *)picker
                        didFail:(NSError *)error
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - IBActions

-(void) uploadButtonClicked:(UIButton *) btn
{
    AGImagePickerController *imagePickerController = [[AGImagePickerController alloc] initWithDelegate:self];
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:^{
                         
                     }];
}


-(void) shareButtonClicked:(UIButton *) sender
{
    
}

-(void) copyButtonClicked:(UIButton *) sender
{
    
}


-(void) moveButtonClicked:(UIButton *) sender
{
}

-(void) deleteButtonClicked:(UIButton *) sender
{
}

-(void) editButtonClicked:(UIButton *) sender
{
    sender.selected = !sender.selected;
    [browserTableView setEditing:sender.selected animated:YES];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    if (!sender.selected) {
        UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        uploadButton.frame = CGRectMake(0, 0, 50, 30);
        [uploadButton setTitle:@"Upload"
                      forState:UIControlStateNormal];
        [uploadButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
        [uploadButton setBackgroundImage:[UIImage imageNamed:@"editButton.png"]
                                forState:UIControlStateNormal];
        [uploadButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.f]];
        [uploadButton addTarget:self
                         action:@selector(uploadButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside];
        
        
        [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
        [items addObject:[[UIBarButtonItem alloc] initWithCustomView:uploadButton]];
        fileOperationsToolBar.items = items;
    } else {
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(0, 0, 50, 30);
        [deleteButton setTitle:@"Delete"
                      forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"editButton.png"]
                                forState:UIControlStateNormal];
        [deleteButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.f]];
        deleteButton.exclusiveTouch = YES;
        [deleteButton addTarget:self
                         action:@selector(deleteButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside];

        
        UIButton *moveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moveButton.frame = CGRectMake(0, 0, 50, 30);
        [moveButton setTitle:@"Move"
                      forState:UIControlStateNormal];
        [moveButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
        [moveButton setBackgroundImage:[UIImage imageNamed:@"editButton.png"]
                                forState:UIControlStateNormal];
        [moveButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.f]];
        moveButton.exclusiveTouch = YES;
        [moveButton addTarget:self
                         action:@selector(moveButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        copyButton.frame = CGRectMake(0, 0, 50, 30);
        [copyButton setTitle:@"Copy"
                    forState:UIControlStateNormal];
        [copyButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
        [copyButton setBackgroundImage:[UIImage imageNamed:@"editButton.png"]
                              forState:UIControlStateNormal];
        [copyButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.f]];
        copyButton.exclusiveTouch = YES;
        [copyButton addTarget:self
                       action:@selector(copyButtonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.frame = CGRectMake(0, 0, 50, 30);
        [shareButton setTitle:@"Share"
                    forState:UIControlStateNormal];
        [shareButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
        shareButton.exclusiveTouch = YES;
        [shareButton setBackgroundImage:[UIImage imageNamed:@"editButton.png"]
                              forState:UIControlStateNormal];
        [shareButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.f]];
        [shareButton addTarget:self
                       action:@selector(shareButtonClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
        [items addObject:[[UIBarButtonItem alloc] initWithCustomView:deleteButton]];
        [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
        
        [items addObject:[[UIBarButtonItem alloc] initWithCustomView:moveButton]];
        [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
        
        [items addObject:[[UIBarButtonItem alloc] initWithCustomView:copyButton]];
        [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
        
        [items addObject:[[UIBarButtonItem alloc] initWithCustomView:shareButton]];
        [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    }
    [fileOperationsToolBar setItems:items animated:YES];
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


#pragma mark - Upload Methods


- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath
          metadata:(DBMetadata*)metadata
{
}

- (void)restClient:(DBRestClient*)client uploadProgress:(CGFloat)progress
           forFile:(NSString*)destPath from:(NSString*)srcPath
{
    
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error
{
    
}


#pragma mark - Metadata Methods

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


#pragma mark - Image ThumbNail Methods

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath metadata:(DBMetadata*)metadata
{
    [browserTableView reloadData];
    [activityIndicator stopAnimating];
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error
{
    [activityIndicator stopAnimating];
}


#pragma mark - Deletion Methods

- (void)restClient:(DBRestClient*)client deletedPath:(NSString *)path
{
    
}

- (void)restClient:(DBRestClient*)client deletePathFailedWithError:(NSError*)error
{
    
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
        NSNumber *size = [data objectForKey:@"size"];
        detailText = [NSString stringWithFormat:@"%.2f MB",[size doubleValue]/(1024 * 1024)];
        if ([[data objectForKey:@"type"] isEqualToString:@"folder"] || [[data objectForKey:@"type"] isEqualToString:@"album"]) {
            cellImage = [UIImage imageNamed:@"folder.png"];
        } else if ([[data objectForKey:@"type"] isEqualToString:@"photo"]) {
            cellImage = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[CLCacheManager getTemporaryDirectory],titleText]];
        }
        if (!titleText) {
            titleText = [data objectForKey:@"filename"];
            detailText = [data objectForKey:@"humanReadableSize"];
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
    if (![activityIndicator isAnimating] && !tableView.editing) {
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
                    NSDictionary *metaData = [tableData objectAtIndex:indexPath.row];

                    if ([[metaData objectForKey:@"thumbnailExists"] boolValue]) {
                        
                    } else {
                        CLFileReaderViewController *fileReaderViewController = [[CLFileReaderViewController alloc] initWithFileMetaData:metaData ForViewType:DROPBOX];
                        [self.navigationController pushViewController:fileReaderViewController animated:YES];
                    }
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
                    CLFileReaderViewController *fileReaderViewController = [[CLFileReaderViewController alloc] initWithFileMetaData:selectedDirectory ForViewType:SKYDRIVE];
                    [self.navigationController pushViewController:fileReaderViewController animated:YES];
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
    [self deSelectEditMode];
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
                __block NSMutableArray *computedTableData = [[NSMutableArray alloc] initWithArray:contents];
                [tableData removeAllObjects];
                BOOL hideFiles = [[inputDictionary objectForKey:@"HIDE_FILES"] boolValue];
                if (hideFiles) {
                    [contents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSDictionary *objDict = (NSDictionary *)obj;
                        if (![[objDict objectForKey:@"isDirectory"] boolValue])
                        {
                            [computedTableData removeObject:objDict];
                        }
                    }];
                }
                [tableData addObjectsFromArray:computedTableData];
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
