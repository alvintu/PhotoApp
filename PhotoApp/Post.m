//
//  Post.m
//  PhotoApp
//
//  Created by Jo Tu on 8/7/16.
//  Copyright © 2016 Turn To Tech. All rights reserved.
//

#import "Post.h"

@implementation Post

- (instancetype)initWithImageKey:(NSString*)imageKey downloadURL:(NSString*)downloadURL comments:(NSMutableArray*)comments andLikes:(NSNumber *)likes
{
    self = [super init];
    if (self) {
    
        _imageKey = imageKey;
        _downloadURL = downloadURL;
//        comments = [[NSMutableArray alloc]init];
        _comments = comments;
        _likes = likes;
        
    }
    return self;
}



@end
