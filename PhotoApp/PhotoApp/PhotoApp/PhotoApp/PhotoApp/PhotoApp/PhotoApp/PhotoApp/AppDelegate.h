//
//  AppDelegate.h
//  PhotoApp
//
//  Created by Jo Tu on 7/30/16.
//  Copyright © 2016 Turn To Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAO.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic) DAO *dao;


@end

