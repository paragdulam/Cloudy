//
//  Constants.h
//  SkyBox
//
//  Created by Parag Dulam on 18/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#ifndef SkyBox_Constants_h
#define SkyBox_Constants_h

#define DROPBOX_STRING @"Dropbox"
#define SKYDRIVE_STRING @"SkyDrive"
#define GOOGLE_DRIVE_STRING @"Google Drive"
#define BOX_STRING @"Box"


#define DROPBOX_APP_KEY @"4mk4cldk8wu2emp"
#define DROPBOX_APP_SECRET_KEY @"0sc12t7lzttseoi"

#define SKYDRIVE_CLIENT_ID @"000000004C0C6832"
#define SCOPE_ARRAY [NSArray arrayWithObjects:@"wl.signin",@"wl.basic",@"wl.skydrive",@"wl.offline_access", nil]


#define GOOGLE_DRIVE_KEYCHAIN_ITEM_NAME @"Drive-Box"
#define GOOGLE_DRIVE_CLIENT_ID @"1029215508929.apps.googleusercontent.com"
#define GOOGLE_DRIVE_CLIENT_SECRET @"oinsnnJl1zr7TwfBhcsQrL-E"
#define GOOGLE_DRIVE_API_KEY @"AIzaSyCi42dmunvLaXMsIm1Y8ws0KhN0R9W4Txc"


#define ACCOUNTS_PLIST @"Accounts.plist"
#define OFFSET 40.f

#define ACCOUNTS @"Accounts"
#define ACCOUNT_DATA @"ACCOUNT_DATA"
#define ACCOUNT_TYPE @"ACCOUNT_TYPE"
#define PDF @"pdf"
#define PATH_SEPARATOR @"/"

#define PATH @"PATH"
#define VIEW_TYPE_STRING @"VIEW_TYPE"
#define THUMBNAIL_REQUEST_CLIENT @"THUMBNAIL_REQUEST_CLIENT"
#define FILE_INFO @"FILE_INFO"
#define CACHE_FOLDER_NAME @"APP_CACHE"
#define FILE_STRUCTURE_PLIST @"FILE_STRUCTURE.plist"
#define FILE_STRUCTURE_STRING @"File_Structure"


typedef enum CLOUD_PROVIDERS {
    DROPBOX = 0,
    SKYDRIVE
} VIEW_TYPE;

typedef enum FILE_TYPE {
    PDF_FILE,
    PPT_FILE,
    PLAIN_TEXT_FILE,
    AUDIO_FILE,
    VIDEO_FILE,
    IMAGE_FILE
} FILE_TYPE;

typedef enum FILE_FOLDER_OPERATIONS {
    MOVE,
    CREATE,
    DELETE,
    SHARE
} FILE_FOLDER_OPERATION;





#define ROOT_DROPBOX_PATH @"/"
#define ROOT_SKYDRIVE_PATH @"me/skydrive/files"


#define AUTH_SUCCESS_DROPBOX_TAG 100000
#define AUTH_SUCCESS_SKYDRIVE_TAG 100001


#define IMAGE_EXTENTION_ARRAY [NSArray arrayWithObjects:@"tiff",@"tif",@"jpg",@"jpeg",@"gif",@"png",@"bmp",@"bmpf",@"ico",@"cur",@"xbm",nil]


#endif
