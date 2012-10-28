//
//  CLWebViewController.h
//  Cloudy
//
//  Created by Parag Dulam on 26/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import "CLBaseViewController.h"
#import "AppDelegate.h"
#import "CLCacheManager.h"

@interface CLWebViewController : CLBaseViewController<UIWebViewDelegate,DBRestClientDelegate,LiveOperationDelegate>
{
    UIWebView *webView;
    NSDictionary *inputDictionary;
    DBRestClient *restClient;
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic,strong) NSDictionary *inputDictionary;

-(id) initWithDictionary:(NSDictionary *) config;

@end
