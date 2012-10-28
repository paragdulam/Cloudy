//
//  CLCacheManager.m
//  Cloudy
//
//  Created by Parag Dulam on 24/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import "CLCacheManager.h"

@implementation CLCacheManager


#pragma mark - Get Folder Paths


+(NSString *) getAppCacheFolderPath
{
    return [NSString stringWithFormat:@"%@/%@",[CLCacheManager getDocumentsDirectory],CACHE_FOLDER_NAME];
}


+(NSString *) getDropboxCacheFolderPath
{
    return [NSString stringWithFormat:@"%@/%@",[CLCacheManager getAppCacheFolderPath],DROPBOX_STRING];
}


+(NSString *) getSkyDriveCacheFolderPath
{
    return [NSString stringWithFormat:@"%@/%@",[CLCacheManager getAppCacheFolderPath],SKYDRIVE_STRING];
}


+(NSString *) getFileStructurePath:(VIEW_TYPE) type
{
    switch (type) {
        case DROPBOX:
            return [NSString stringWithFormat:@"%@/%@",[CLCacheManager getDropboxCacheFolderPath],FILE_STRUCTURE_PLIST];
            break;
        case SKYDRIVE:
            return [NSString stringWithFormat:@"%@/%@",[CLCacheManager getSkyDriveCacheFolderPath],FILE_STRUCTURE_PLIST];
            break;
        default:
            break;
    }
    return nil;
}



+(NSString *) getLibraryDirectory
{
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                   NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    return docsDir;
}


+(NSString *) getDocumentsDirectory
{
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    return docsDir;
}


#pragma mark - Helper Methods


+(NSMutableArray *) removeEmptyStringsForArray:(NSMutableArray *) array
{
    NSMutableArray *retVal = [[NSMutableArray alloc] init];
    for (NSString *string in array) {
        if ([string length]) {
            [retVal addObject:string];
        }
    }
    return retVal;
}


#pragma mark - Accounts


+(NSArray *) accounts
{
    NSDictionary *accountsDictionary = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[CLCacheManager getAppCacheFolderPath],ACCOUNTS_PLIST]];
    return [accountsDictionary objectForKey:ACCOUNTS];
}

+(BOOL) storeAccount:(NSDictionary *) account
{
    NSMutableArray *accounts = [NSMutableArray arrayWithArray:[CLCacheManager accounts]];
    if ([accounts containsObject:account]) {
        return NO;
    } else {
        [accounts addObject:account];
    }
    NSDictionary *accountsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:accounts,ACCOUNTS, nil];
    return [accountsDictionary writeToFile:[NSString stringWithFormat:@"%@/%@",[CLCacheManager getAppCacheFolderPath],ACCOUNTS_PLIST] atomically:YES];
}


+(BOOL) deleteAccount:(NSDictionary *) account
{
    NSMutableArray *accounts = [NSMutableArray arrayWithArray:[CLCacheManager accounts]];
    [accounts removeObject:account];
    NSDictionary *accountsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:accounts,ACCOUNTS, nil];
    if (![accountsDictionary count])
    {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[CLCacheManager getAppCacheFolderPath],ACCOUNTS_PLIST]
                                                   error:nil];
        return NO;
    }
    return [accountsDictionary writeToFile:[NSString stringWithFormat:@"%@/%@",[CLCacheManager getDocumentsDirectory],ACCOUNTS_PLIST] atomically:YES];
}


#pragma mark - Initial Setup


+(void) initialSetup
{
    NSError *error = nil;
    NSString *dropBoxFolderCachePath = [CLCacheManager getDropboxCacheFolderPath];
    BOOL aBool = YES;
    BOOL isDropboxFolderAlreadyPresent = [[NSFileManager defaultManager] fileExistsAtPath:dropBoxFolderCachePath isDirectory:&aBool];
    if (!isDropboxFolderAlreadyPresent) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dropBoxFolderCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
    }
    if (error) {
        NSLog(@"error creating Dropbox Folder %@",error);
    }
    
    NSString *skyDriveFolderCachePath = [CLCacheManager getSkyDriveCacheFolderPath];
    BOOL anBool = YES;
    BOOL isSkyDriveFolderAlreadyPresent = [[NSFileManager defaultManager] fileExistsAtPath:skyDriveFolderCachePath isDirectory:&anBool];
    
    if (!isSkyDriveFolderAlreadyPresent) {
        [[NSFileManager defaultManager] createDirectoryAtPath:skyDriveFolderCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        
    }
    if (error) {
        NSLog(@"error creating SkyDrive Folder %@",error);
    }
}



#pragma mark - File Structure Operations


+(NSDictionary *) metaDataDictionaryForPath:(NSString *) path ForView:(VIEW_TYPE) type
{
    switch (type) {
        case DROPBOX:
        {
            NSDictionary *fileStructure = [[NSDictionary alloc] initWithContentsOfFile:[CLCacheManager getFileStructurePath:DROPBOX]];
            NSMutableArray *components = [CLCacheManager removeEmptyStringsForArray:[NSMutableArray arrayWithArray:[path componentsSeparatedByString:@"/"]]];
            NSDictionary *traversingDict = fileStructure;
            for (int j = 0;j < [components count] ;j++) {
                NSString *component = [components objectAtIndex:j];
                NSMutableArray *contents = [traversingDict objectForKey:@"contents"];
                for (int i = 0 ; i < [contents count] ; i++) {
                    traversingDict = [contents objectAtIndex:i];
                    if ([[traversingDict objectForKey:@"filename"] isEqualToString:component]) {
                        if (j == [components count] - 1) {
                            return traversingDict;
                        }
                        break;
                    }
                }
            }
            return traversingDict;
        }
            break;
            
        case SKYDRIVE:
        {
            
        }
            break;

        default:
            break;
    }
    return nil;
}


+(BOOL) updateFolderStructure:(NSDictionary *) metaDataDict
                      ForView:(VIEW_TYPE) type
{
    BOOL retVal = NO;
    switch (type) {
        case DROPBOX:
        {
            NSString *path = [metaDataDict objectForKey:@"path"];
            NSDictionary *fileStructure = [[NSDictionary alloc] initWithContentsOfFile:[CLCacheManager getFileStructurePath:DROPBOX]];
            NSMutableDictionary *mutableFileStructure = (__bridge NSMutableDictionary *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFDictionaryRef)fileStructure, kCFPropertyListMutableContainers);
            
            NSMutableDictionary *traversingDict = mutableFileStructure;
            NSMutableArray *components = [CLCacheManager removeEmptyStringsForArray:[NSMutableArray arrayWithArray:[path componentsSeparatedByString:@"/"]]];
            
            for (int j = 0;j < [components count] ;j++) {
                NSString *component = [components objectAtIndex:j];
                NSMutableArray *contents = [traversingDict objectForKey:@"contents"];
                for (int i = 0 ; i < [contents count] ; i++) {
                    traversingDict = [contents objectAtIndex:i];
                    if ([[traversingDict objectForKey:@"filename"] isEqualToString:component]) {
                        if (j == [components count] - 1) {
                            [contents replaceObjectAtIndex:i
                                                withObject:metaDataDict];
                        }
                        break;
                    }
                }
            }
            NSString *filePath = [CLCacheManager getFileStructurePath:type];
            if (!traversingDict) {
                mutableFileStructure = [NSMutableDictionary dictionaryWithDictionary:metaDataDict];
            }
            retVal = [mutableFileStructure writeToFile:filePath atomically:YES];
        }
            break;
            
        case SKYDRIVE:
        {
            NSDictionary *fileStructure = [[NSDictionary alloc] initWithContentsOfFile:[CLCacheManager getFileStructurePath:SKYDRIVE]];
            NSMutableDictionary *mutableFileStructure = (__bridge NSMutableDictionary *)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFDictionaryRef)fileStructure, kCFPropertyListMutableContainers);
            
            NSMutableDictionary *traversingDict = mutableFileStructure;
            NSString *filePath = [CLCacheManager getFileStructurePath:type];
            if (!traversingDict) {
                mutableFileStructure = [NSMutableDictionary dictionaryWithDictionary:metaDataDict];
            }
            retVal = [mutableFileStructure writeToFile:filePath atomically:NO];
        }
            break;
        default:
            break;
    }
    return retVal;
}



@end
