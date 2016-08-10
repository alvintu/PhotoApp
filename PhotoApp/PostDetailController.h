//
//  PostDetailController.h
//  PhotoApp
//
//  Created by Jo Tu on 8/8/16.
//  Copyright © 2016 Turn To Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@interface PostDetailController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) Post *currentPost;
- (IBAction)addComment:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deletePost;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *commentFieldContainer;
@property (weak, nonatomic) IBOutlet UITextField *commentField;
- (IBAction)deletePost:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *alphaedView;
- (IBAction)likesButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activeLike;
@property (weak, nonatomic) IBOutlet UIImageView *inactiveLike;

@end
