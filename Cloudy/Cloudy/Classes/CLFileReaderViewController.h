//
//  CLFileReaderViewController.h
//  Cloudy
//
//  Created by Parag Dulam on 31/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import "CLBaseViewController.h"
#import "CLCacheManager.h"

@interface CLFileReaderViewController : CLBaseViewController<DBRestClientDelegate,UIWebViewDelegate,LiveDownloadOperationDelegate>
{
    NSDictionary *metaData;
    VIEW_TYPE viewType;
    DBRestClient *downloadClient;
    UIProgressView *progressBar;
    UIWebView *webView;
}

-(id) initWithFileMetaData:(NSDictionary *) mdict
               ForViewType:(VIEW_TYPE) type;

@end
