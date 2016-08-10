//
//  DAO.m
//  PhotoApp
//
//  Created by Jo Tu on 8/5/16.
//  Copyright © 2016 Turn To Tech. All rights reserved.
//

#import "DAO.h"

@interface DAO ()
@end

@implementation DAO

#pragma mark Singleton Methods

+ (id)sharedManager {
    static DAO *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        self.ref = [[FIRDatabase database]reference];
        self.downloadURLArray = [[NSMutableArray alloc]init];
        self.posts = [[NSMutableArray alloc]init];


    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}




-(void)fetchMetaDataFromStorage{
    NSMutableArray *photoArray = [@[@"photo_01@3x.jpg",@"photo_02@3x.jpg",@"photo_03@3x.jpg",@"photo_04@3x.jpg",@"photo_05@3x.jpg",@"photo_06@3x.jpg",@"photo_07@3x.jpg",@"photo_08@3x.jpg",@"photo_09@3x.jpg",@"photo_10@3x.jpg",@"photo_11@3x.jpg",@"photo_12@3x.jpg",@"photo_13@3x.jpg",@"photo_14@3x.jpg",@"photo_15@3x.jpg",@"photo_16@3x.jpg"]mutableCopy];
    FIRStorage *storage = [FIRStorage storage];
    self.storageRef = [storage referenceForURL:@"gs://boiling-heat-4086.appspot.com"];
    self.imagesRef = [self.storageRef child:@"images"];


    self.defaultImagesDownloadURLArray = [[NSMutableArray alloc]init];
    
    
    
    for(NSString *photo in photoArray){
        FIRStorageReference *tempRef = [self.imagesRef child:photo];
        // Get metadata properties
        [tempRef metadataWithCompletion:^(FIRStorageMetadata *metadata, NSError *error){
            if (error != nil) {
                NSLog(@"error in fetchmetdatafromstorage");
                // Uh-oh, an error occurred!
            } else {
                
                
                
                
                NSString *tempString = metadata.downloadURL.absoluteString;
                //                    [self.dao.downloadURLArray addObject:tempString];
                //                        [self loadInfoIntoDB:tempString];
//                NSLog(@"%@",tempString);
                
                [self loadInfoIntoDB:tempString];
                
                
                
                // Metadata now contains the metadata for 'images/forest.jpg'
            }
            //                NSLog(@"%@",self.dao.downloadURLArray);
            
        }];
        
    }
    
    
    
    
}



-(void)loadInfoIntoDB:(NSString*)downloadURL{
    
    
    NSString *url = @"https://boiling-heat-4086.firebaseio.com/images.json";
//    NSMutableArray *comments = [@[@"hello",@"whats'up"]mutableCopy];
    NSMutableArray *comments = [@[@""]mutableCopy];
    NSNumber *likes = [NSNumber numberWithInteger:0];

    NSDictionary *parametersDictionary = @{@"downloadURL": downloadURL,@"comments":comments,@"likes":likes};
    //    NSDictionary *parametersDictionary;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    NSString *lastObject = [photoArray lastObject];
    
    
    
    [manager POST:url parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
        
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"error: %@", error);
              
          }];
    
    
    
    
    
}



-(void)getImageDownloadURLForCollectionView{
    
    NSString *url = @"https://boiling-heat-4086.firebaseio.com/images.json";

//    NSDictionary *parametersDictionary = @{@"downloadURL": downloadURL};
        NSDictionary *parametersDictionary;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    NSString *lastObject = [photoArray lastObject];
    
    
    
    [manager GET:url parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
//        NSLog(@"%@",(NSDictionary*)responseObject);
    
        NSDictionary *imageDict = (NSDictionary*)responseObject;
//        tempDict.allKeys

        NSMutableArray *tempImageKeyArray = [[NSMutableArray alloc]init];
        self.imageKeyArray = [[NSMutableArray alloc]init];
        tempImageKeyArray = [imageDict.allKeys mutableCopy]; //take all hash value image keys and put them in an array to dervice downloadurl
        for(NSString *imageKey in tempImageKeyArray){
            
            NSString *downloadURL = [[imageDict objectForKey:imageKey]objectForKey:@"downloadURL"];
            
            
            NSString *comments = [[imageDict objectForKey:imageKey]objectForKey:@"comments"];
            
            NSNumber *likes = [[imageDict objectForKey:imageKey]objectForKey:@"likes"];


            NSArray *temp = (NSArray*)comments;
            NSMutableArray *commentz = [[NSMutableArray alloc]init];
            commentz = [temp mutableCopy];
            
            

            Post *post = [[Post alloc]initWithImageKey:imageKey downloadURL:downloadURL comments:commentz andLikes:likes];
            if(![post.downloadURL isEqualToString:@""]){
                [self.posts addObject:post];

            }
         
//            NSLog(@"self.posts is %@",self.posts);
//            [self.downloadURLArray addObject:tempstring];
//            [self.imageKeyArray addObject:imageKey];
        }
        
        
//        NSLog(@"the download count is %lu",[self.downloadURLArray count]);
//
//        if([self.posts count] == [tempImageKeyArray count]){
        
   
//
//    }
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"error: %@", error);
              
          }];
    
    

}

-(void)updateCommentswithImageKey:(NSString*)imageKey andComments:(NSMutableArray*)comments{
    NSString *url = [NSString stringWithFormat:@"https://boiling-heat-4086.firebaseio.com/images/%@.json",imageKey];
    
    //    NSMutableArray *comments = [@[@"hello",@"whats'up"]mutableCopy];
//    NSMutableArray *comments = [@[@"wtf",@"sup"]mutableCopy];
    
    
    NSDictionary *parametersDictionary = @{@"comments":comments};
    //    NSDictionary *parametersDictionary;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    NSString *lastObject = [photoArray lastObject];
    
    [manager PATCH:url parameters:parametersDictionary success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
    
}


-(void)deletePhotowithImageKey:(NSString*)imageKey{
    NSString *url = [NSString stringWithFormat:@"https://boiling-heat-4086.firebaseio.com/images/%@.json",imageKey];
    
    //    NSMutableArray *comments = [@[@"hello",@"whats'up"]mutableCopy];
    //    NSMutableArray *comments = [@[@"wtf",@"sup"]mutableCopy];
    
    
    NSDictionary *parametersDictionary = @{@"downloadURL":@""};
    //    NSDictionary *parametersDictionary;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    NSString *lastObject = [photoArray lastObject];
    
    [manager PATCH:url parameters:parametersDictionary success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
    
}

-(void)updateLikeswithImageKey:(NSString*)imageKey andLikes:(NSNumber*)likes{
    NSString *url = [NSString stringWithFormat:@"https://boiling-heat-4086.firebaseio.com/images/%@.json",imageKey];
    
    //    NSMutableArray *comments = [@[@"hello",@"whats'up"]mutableCopy];
    //    NSMutableArray *comments = [@[@"wtf",@"sup"]mutableCopy];
    
    
    NSDictionary *parametersDictionary = @{@"likes":likes};
    //    NSDictionary *parametersDictionary;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    NSString *lastObject = [photoArray lastObject];
    
    [manager PATCH:url parameters:parametersDictionary success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
    
}


-(void)uploadImagetoStorageUsingNSData:(NSData*)data fileName:(NSString*)fileName{
    // Create a reference to the file you want to upload
    FIRStorage *storage = [FIRStorage storage];
    self.storageRef = [storage referenceForURL:@"gs://boiling-heat-4086.appspot.com"];
    self.imagesRef = [self.storageRef child:@"images"];
    FIRStorageReference *newImageRef = [self.imagesRef child:[NSString stringWithFormat:@"%@",fileName]];

    
    
    // Create a reference to the file you want to upload
    
    // Upload the file to the path "images/rivers.jpg"
    FIRStorageUploadTask *uploadTask = [newImageRef putData:data metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (error != nil) {
            // Uh-oh, an error occurred!
        } else {
            // Metadata contains file metadata such as size, content-type, and download URL.
//            NSURL *downloadURL = metadata.downloadURL;
            NSLog(@"bucket is %@",metadata.bucket);
        }
        [self fetchPostFromStorageByFileName:fileName];
    }];
    

    
    NSLog(@"uploadtask is %@",uploadTask);
}




-(void)fetchPostFromStorageByFileName:(NSString*)fileName{
 
    FIRStorage *storage = [FIRStorage storage];
    self.storageRef = [storage referenceForURL:@"gs://boiling-heat-4086.appspot.com"];
    self.imagesRef = [self.storageRef child:@"images"];
    
    
    self.defaultImagesDownloadURLArray = [[NSMutableArray alloc]init];
    
    
    
        FIRStorageReference *tempRef = [self.imagesRef child:fileName];
        // Get metadata properties
        [tempRef metadataWithCompletion:^(FIRStorageMetadata *metadata, NSError *error){
            if (error != nil) {
                NSLog(@"error in fetchmetdatafromstorage");
                // Uh-oh, an error occurred!
            } else {
                
                
                
                
                NSString *tempString = metadata.downloadURL.absoluteString;
                //                    [self.dao.downloadURLArray addObject:tempString];
                //                        [self loadInfoIntoDB:tempString];
                //                NSLog(@"%@",tempString);
                
                NSLog(@"metadata is  is %@",metadata);
                [self loadSingleFileIntoDB:tempString];
                
                
                
                // Metadata now contains the metadata for 'images/forest.jpg'
            }
            //                NSLog(@"%@",self.dao.downloadURLArray);
            
        }];
        
    }
    

-(void)loadSingleFileIntoDB:(NSString*)downloadURL{
    
    
    NSString *url = @"https://boiling-heat-4086.firebaseio.com/images.json";
    //    NSMutableArray *comments = [@[@"hello",@"whats'up"]mutableCopy];
    NSMutableArray *comments = [@[@""]mutableCopy];
    NSNumber *likes = [NSNumber numberWithInteger:0];
    
    NSDictionary *parametersDictionary = @{@"downloadURL": downloadURL,@"comments":comments,@"likes":likes};
    //    NSDictionary *parametersDictionary;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    NSString *lastObject = [photoArray lastObject];
    
    
    
    [manager POST:url parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"great success!");

      NSString *imageKey =  [responseObject objectForKey:@"name"];
        self.currentPostImageKey = imageKey;
        [self getNewPostBasedOnImageKey:imageKey];
    }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"error: %@", error);
              
          }];
    
    
    
    
    
}



-(void)getNewPostBasedOnImageKey:(NSString*)imageKey{
    
    NSString *url = [NSString stringWithFormat:@"https://boiling-heat-4086.firebaseio.com/images/%@.json",imageKey];
    
    //    NSDictionary *parametersDictionary = @{@"downloadURL": downloadURL};
    NSDictionary *parametersDictionary;
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    NSString *lastObject = [photoArray lastObject];
    
    
    
    [manager GET:url parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success!");
                NSLog(@"response object is %@",(NSDictionary*)responseObject);
        
        NSDictionary *imageDict = (NSDictionary*)responseObject;
        //        tempDict.allKeys
        
        
            NSString *downloadURL = [imageDict objectForKey:@"downloadURL"];
            
            
            NSString *comments = [imageDict objectForKey:@"comments"];
            
            NSNumber *likes = [imageDict objectForKey:@"likes"];
            
            
            NSArray *temp = (NSArray*)comments;
            NSMutableArray *commentz = [[NSMutableArray alloc]init];
            commentz = [temp mutableCopy];
            
            
            
            Post *post = [[Post alloc]initWithImageKey:imageKey downloadURL:downloadURL comments:commentz andLikes:likes];
                [self.posts addObject:post];
                
            
            
            //            NSLog(@"self.posts is %@",self.posts);
            //            [self.downloadURLArray addObject:tempstring];
            //            [self.imageKeyArray addObject:imageKey];
        
        
        
        //        NSLog(@"the download count is %lu",[self.downloadURLArray count]);
        //
        //        if([self.posts count] == [tempImageKeyArray count]){
        
        
        //
        //    }
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"error: %@", error);
             
         }];
    
    
    
}
    


@end
