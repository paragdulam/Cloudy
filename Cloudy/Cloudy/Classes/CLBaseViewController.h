//
//  CLBaseViewController.h
//  Cloudy
//
//  Created by Parag Dulam on 23/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "LiveConnectClient.h"
#import "CLDictionaryConvertor.h"
#import "CLCacheManager.h"

@class AppDelegate;

@interface CLBaseViewController : UIViewController
{
    __unsafe_unretained AppDelegate *appDelegate;
}

@property (nonatomic,unsafe_unretained)AppDelegate *appDelegate;

@end
