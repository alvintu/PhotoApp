//
//  Post.h
//  PhotoApp
//
//  Created by Jo Tu on 8/7/16.
//  Copyright © 2016 Turn To Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic,strong) NSString *downloadURL;
@property (nonatomic,strong) NSString *imageKey;
@property (nonatomic,strong) NSMutableArray *comments;
@property (nonatomic,strong) NSNumber *likes;

- (instancetype)initWithImageKey:(NSString*)imageKey downloadURL:(NSString*)downloadURL comments:(NSMutableArray*)comments andLikes:(NSNumber*)likes;


@end
