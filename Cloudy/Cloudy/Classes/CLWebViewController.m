//
//  CLWebViewController.m
//  Cloudy
//
//  Created by Parag Dulam on 26/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import "CLWebViewController.h"

@interface CLWebViewController ()

@end

@implementation CLWebViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id) initWithDictionary:(NSDictionary *) config
{
    if (self = [super init]) {
        self.inputDictionary = config;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    
    UIView *aView = [[UIView alloc] init];
    aView.backgroundColor = [UIColor clearColor];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [aView addSubview:activityIndicator];
    aView.frame = activityIndicator.frame;
    activityIndicator.hidesWhenStopped = YES;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aView];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter & Getter Methods


-(void) setInputDictionary:(NSDictionary *)aDictionary
{
    inputDictionary = aDictionary;
    NSString *fileInfo = [inputDictionary objectForKey:FILE_INFO];
    VIEW_TYPE viewType = [[inputDictionary objectForKey:VIEW_TYPE_STRING] integerValue];
    
    switch (viewType) {
        case DROPBOX:
        {
            NSString *userId = [[[DBSession sharedSession] userIds] objectAtIndex:0];
            restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]
                                                                userId:userId];
            restClient.delegate = self;
            [restClient loadFile:fileInfo
                        intoPath:[NSString stringWithFormat:@"%@/%@",[CLCacheManager getDocumentsDirectory],[[fileInfo componentsSeparatedByString:@"/"] lastObject]]];
            [activityIndicator startAnimating];
        }
            break;
        case SKYDRIVE:
        {
//            [self.appDelegate.liveConnectClient downloadFromPath:fileInfo
//                                                        delegate:self];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fileInfo]]];
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



#pragma mark - DBRestClientDelegate


- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
{
    [activityIndicator stopAnimating];
    NSURL *fileURL = [NSURL fileURLWithPath:destPath];
    [webView loadRequest:[NSURLRequest requestWithURL:fileURL]];
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath contentType:(NSString*)contentType metadata:(DBMetadata*)metadata
{
    
}
- (void)restClient:(DBRestClient*)client loadProgress:(CGFloat)progress forFile:(NSString*)destPath
{
    
}
- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error
{
    [activityIndicator stopAnimating];
}



- (void) liveOperationSucceeded:(LiveOperation *)operation
{
    LiveDownloadOperation *op = (LiveDownloadOperation *)operation;
    [webView loadData:op.data
             MIMEType:nil
     textEncodingName:nil
              baseURL:nil];
    [activityIndicator stopAnimating];
}

- (void) liveOperationFailed:(NSError *)error
                   operation:(LiveOperation*)operation
{
    [activityIndicator stopAnimating];
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
    [activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
}

@end
