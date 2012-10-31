//
//  CLFileReaderViewController.m
//  Cloudy
//
//  Created by Parag Dulam on 31/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import "CLFileReaderViewController.h"
#import "AppDelegate.h"

@interface CLFileReaderViewController ()
{
    LiveDownloadOperation *downloadOperation;
}
@end

@implementation CLFileReaderViewController

-(id) initWithFileMetaData:(NSDictionary *) mdict
               ForViewType:(VIEW_TYPE) type
{
    if (self = [super init]) {
        metaData = mdict;
        viewType = type;
    }
    return self;
}

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
    
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [self.view addSubview:progressBar];
    progressBar.center = self.view.center;
    
    switch (viewType) {
        case DROPBOX:
        {
            NSString *path = [metaData objectForKey:@"path"];
            NSString *fileName = [metaData objectForKey:@"filename"];
            [self.navigationItem setTitle:fileName];
            downloadClient = [[DBRestClient alloc] initWithSession:self.appDelegate.dropboxSession userId:[[self.appDelegate.dropboxSession userIds] objectAtIndex:0]];
            downloadClient.delegate = self;
            [downloadClient loadFile:path
                            intoPath:[NSString stringWithFormat:@"%@/%@",[CLCacheManager getTemporaryDirectory],fileName]];
        }
            break;
        case SKYDRIVE:
        {
            NSString *path = [metaData objectForKey:@"source"];
            NSString *fileName = [metaData objectForKey:@"name"];
            [self.navigationItem setTitle:fileName];
            [self.appDelegate.liveConnectClient downloadFromPath:path
                                                        delegate:self];
        }
            break;
            
        default:
            break;
    }
    
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [downloadOperation cancel];
    downloadOperation = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
{
    progressBar.hidden = YES;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:destPath]]];
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath contentType:(NSString*)contentType metadata:(DBMetadata*)metadata
{
    
}

- (void)restClient:(DBRestClient*)client loadProgress:(CGFloat)progress forFile:(NSString*)destPath
{
    progressBar.progress = progress;
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error
{
    
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}


#pragma mark - LiveDownloadOperationDelegate


- (void) liveOperationSucceeded:(LiveDownloadOperation *)operation
{
    downloadOperation = operation;
    progressBar.hidden = YES;
    NSString *destPath = [NSString stringWithFormat:@"%@%@",[CLCacheManager getTemporaryDirectory],[metaData objectForKey:@"name"]];
    [operation.data writeToFile:destPath atomically:YES];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:destPath]]];
}

- (void) liveOperationFailed:(NSError *)error
                   operation:(LiveDownloadOperation *)operation
{
    downloadOperation = operation;
}


- (void) liveDownloadOperationProgressed:(LiveOperationProgress *)progress
                                    data:(NSData *)receivedData
                               operation:(LiveDownloadOperation *)operation
{
    downloadOperation = operation;
    progressBar.progress = progress.progressPercentage;
}


@end
