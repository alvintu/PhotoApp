//
//  DAO.h
//  PhotoApp
//
//  Created by Jo Tu on 8/5/16.
//  Copyright © 2016 Turn To Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import <AFNetworking/AFNetworking.h>
#import "AFHTTPSessionManager.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworking.h"
#import "AFSecurityPolicy.h"
#import "AFURLSessionManager.h"
#import "Post.h"
@interface DAO : NSObject {
    NSString *someProperty;
}

//@property (nonatomic, retain) NSString *someProperty;

+ (id)sharedManager;
@property (nonatomic,strong) FIRStorageReference *storageRef;
@property (nonatomic,strong) FIRStorageReference *imagesRef;
@property(nonatomic,strong) FIRDatabaseReference *ref;
@property(nonatomic,strong)NSMutableArray *downloadURLArray;
@property(nonatomic,strong)NSMutableArray *imageKeyArray;
@property(nonatomic,strong)NSMutableArray<Post*> *posts;


@property(nonatomic,strong)NSMutableArray *defaultImagesDownloadURLArray;
@property(nonatomic,strong)NSString *currentPostImageKey;

-(void)loadInfoIntoDB:(NSString*)downloadURL;
-(void)fetchMetaDataFromStorage;
-(void)getImageDownloadURLForCollectionView;
-(void)updateCommentswithImageKey:(NSString*)imageKey andComments:(NSMutableArray*)comments;
-(void)updateLikeswithImageKey:(NSString*)imageKey andLikes:(NSNumber*)likes;

-(void)deletePhotowithImageKey:(NSString*)imageKey;
-(void)uploadImagetoStorageUsingNSData:(NSData*)data fileName:(NSString*)fileName;
-(void)getNewPostBasedOnImageKey:(NSString*)imageKey;
@end