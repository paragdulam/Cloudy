//
//  CLCacheManager.h
//  Cloudy
//
//  Created by Parag Dulam on 24/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface CLCacheManager : NSObject


+(BOOL) storeAccount:(NSDictionary *) account;
+(NSArray *) accounts;
+(BOOL) deleteAccount:(NSDictionary *) account;
+(NSString *) getDocumentsDirectory;
+(void) initialSetup;
+(NSString *) getLibraryDirectory;
+(NSString *) getFileStructurePath:(VIEW_TYPE) type;
+(NSDictionary *) metaDataDictionaryForPath:(NSString *) path ForView:(VIEW_TYPE) type;
+(BOOL) updateFolderStructure:(NSDictionary *) metaDataDict ForView:(VIEW_TYPE) type;
+(BOOL) deleteFileStructureForView:(VIEW_TYPE) type;
+(NSString *) getTemporaryDirectory;
+(NSDictionary *) getAccountForType:(VIEW_TYPE) type;


@end
