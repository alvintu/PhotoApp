//
//  FirstViewController.h
//  PhotoApp
//
//  Created by Jo Tu on 7/30/16.
//  Copyright © 2016 Turn To Tech. All rights reserved.
//
#import "DAO.h"
#import <UIKit/UIKit.h>
#import "PostDetailController.h"

@class Post;

@interface FirstViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITabBarDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(strong,nonatomic) DAO *dao;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

