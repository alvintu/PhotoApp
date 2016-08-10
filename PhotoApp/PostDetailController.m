//
//  PostDetailController.m
//  PhotoApp
//
//  Created by Jo Tu on 8/8/16.
//  Copyright © 2016 Turn To Tech. All rights reserved.
//

#import "PostDetailController.h"
#import "UIImageView+AFNetworking.h"
#import "DAO.h"
//#import "ASFSharedViewTransition.h"

@interface PostDetailController()<UITextFieldDelegate,UIViewControllerTransitioningDelegate>
@property (nonatomic,strong) DAO *dao;
@property(nonatomic,weak) UIButton *deleteButton;
@property(nonatomic,weak) UIButton *cancelButton;
@property(nonatomic,weak) UIView *blackOverlay;
@property(nonatomic) int likesCounter;

@end



@implementation PostDetailController


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.currentPost.comments count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:14];

    cell.textLabel.text = [self.currentPost.comments
                           objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.preservesSuperviewLayoutMargins=NO;
    
    cell.textLabel.numberOfLines = 0;

    

    return cell;
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.likesLabel.text = [NSString stringWithFormat:@"%@ Likes",self.currentPost.likes];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.dao = [DAO sharedManager];
    
    self.title = @"Photo Detail";
    self.likesCounter = [self.currentPost.likes intValue];
    NSLog(@"likes counter at viewdidload is %i",self.likesCounter);
    

    [self loadImage];
//    self.tableView.layer.borderWidth = 1.0;
//    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self loadHiddenButtons];
//    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

//    [self.dao deletePhotowithImageKey:self.currentPost.imageKey]; //this deletes but i need to find a proper way to align it
//    with UI
    
    CALayer *layer = _tableView.layer;
    [layer setMasksToBounds:YES];
    [layer setCornerRadius: 4.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor colorWithWhite: 0.8 alpha: 1.0] CGColor]];

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.commentFieldContainer.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
    self.commentFieldContainer.hidden = YES;
    [self.commentField setDelegate:self];
    
    self.likesLabel.font = [UIFont fontWithName:@".SFUIText-Medium" size:15];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:sender:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

    

}


- (void)keyboardDidShow: (NSNotification *) notif sender:(id)sender{
//    [self.commentFieldContainer removeFromSuperview];
    self.commentFieldContainer.frame = CGRectMake(0, 355, 600, 88);
    [self startCommentFade:sender];
    // Do something here
}

- (void)keyboardDidHide: (NSNotification *) notif{
    
    self.commentFieldContainer.frame = CGRectMake(0, 575, 600, 88);

    // Do something here
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];

    return YES; // want to hide keyboard
//    return NO; // want keyboard
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)loadImage{
    NSString *tempURL = (NSString*)self.currentPost.downloadURL;

    [self.postImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempURL]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        self.postImageView.image = image;
//        self.postImageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.postImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.postImageView.contentMode = UIViewContentModeScaleToFill;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    

}

- (IBAction)addComment:(id)sender {
    if(self.commentFieldContainer.hidden == YES){
        self.commentFieldContainer.hidden = NO;

    }
    
    else if(self.commentFieldContainer.hidden == NO && [self.commentField.text isEqualToString:@""]){
        //do nothing
        self.commentFieldContainer.hidden = YES;
    }
    
    else{
        
        [self startCommentFade:sender];

    [self.currentPost.comments addObject:self.commentField.text]; //update comments array
    [self.dao updateCommentswithImageKey:self.currentPost.imageKey andComments:self.currentPost.comments];
    self.commentField.text = @"";
        [self.commentField resignFirstResponder];
    [self.tableView reloadData];
    }
    NSLog(@"add comment");
}

- (IBAction)deletePost:(id)sender {
    NSLog(@"delete post");

//    self.postImageView.alpha = 0.6;
//    self.tableView.alpha = 0.3;
//    self.alphaedView.alpha = 0.6;
//
    self.navigationController.navigationBar.alpha = 0.6;
    self.blackOverlay.hidden = NO;
    
 
    self.deleteButton.hidden = NO;
    self.cancelButton.hidden = NO;


}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        CATransition *transition = [CATransition animation];
        [transition setDuration:0.75];
        [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transition setType:@"oglFlip"];
        [transition setSubtype:kCATransitionFromLeft];
        [transition setDelegate:self];
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
    }
    
    [super viewWillDisappear:animated];
}

-(void)removePost{
    self.navigationController.navigationBar.alpha = 1.0;
    self.blackOverlay.hidden = YES;
    [self.dao deletePhotowithImageKey:self.currentPost.imageKey];
    [self.dao.posts removeObject:self.currentPost];
    
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
}
-(void)cancel{
    
    self.navigationController.navigationBar.alpha = 1.0;
    self.blackOverlay.hidden = YES;
    self.deleteButton.hidden = YES;
    self.cancelButton.hidden = YES;
////
//    self.navigationController.navigationBar.translucent = NO;
    

}

-(void)loadHiddenButtons{
    UIButton *but= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [but addTarget:self action:@selector(removePost) forControlEvents:UIControlEventTouchUpInside];
    [but setFrame:CGRectMake(50, 500, 280, 40)];
    but.backgroundColor = [UIColor whiteColor];
    but.tintColor = [UIColor redColor];
    
    but.layer.cornerRadius = 10.0;
//    but.layer.borderWidth = 0.5;
    [but setTitle:@"Delete Photo" forState:UIControlStateNormal];
    [but setExclusiveTouch:YES];
    
    // if you like to add backgroundImage else no need
    //    [but setbackgroundImage:[UIImage imageNamed:@"XXX.png"] forState:UIControlStateNormal];
    UIButton *but1= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [but1 addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [but1 setFrame:CGRectMake(50, 550, 280, 40)];
    but1.backgroundColor = [UIColor whiteColor];
    but1.tintColor = [UIColor blueColor];
    
    but1.layer.cornerRadius = 10.0;
//    but1.layer.borderWidth = 0.5;

    [but1 setTitle:@"Cancel" forState:UIControlStateNormal];
    [but1 setExclusiveTouch:YES];
    
    // if you like to add backgroundImage else no need
    //    [but setbackgroundImage:[UIImage imageNamed:@"XXX.png"] forState:UIControlStateNormal];
    self.deleteButton = but1;
    self.cancelButton = but;
    self.deleteButton.hidden = YES;
    self.cancelButton.hidden = YES;

    
    UIView *blackOverlay = [[UIView alloc] initWithFrame: CGRectMake(0,0,600,700)];
    blackOverlay.layer.backgroundColor = [[UIColor blackColor] CGColor];
    blackOverlay.layer.opacity = 0.5f;
    self.blackOverlay = blackOverlay;
    self.blackOverlay.hidden = YES;
    [self.view addSubview:self.blackOverlay];
    self.activeLike.alpha = 0.0f;
    [self.view addSubview:self.deleteButton];
    
    [self.view addSubview:self.cancelButton];

}
//
//#pragma mark - ASFSharedViewTransitionDataSource
//
//- (UIView *)sharedView
//{
//    return _postImageView;
//}
- (IBAction)likesButton:(id)sender {
    
    [self startFade:sender];
    
    self.likesCounter++;
    self.likesLabel.text = [NSString stringWithFormat:@"%i Likes",self.likesCounter];
    self.currentPost.likes = [NSNumber numberWithInt:self.likesCounter ];
    [self.dao updateLikeswithImageKey:self.currentPost.imageKey andLikes:self.currentPost.likes];
    
}

-(IBAction)startFade:(id)sender{
    [self.inactiveLike setAlpha:0.0f];
    [self.activeLike setAlpha:1.0f];
    
    //fade in
    [UIView animateWithDuration:2.0f animations:^{
        [self.inactiveLike setAlpha:1.0f];

        [self.activeLike setAlpha:0.0f];
        
    } completion:^(BOOL finished) {
        
        //fade out
        [UIView animateWithDuration:2.0f animations:^{
            
            [self.inactiveLike setAlpha:1.0f];
            
        } completion:nil];
        
    }];
}


-(IBAction)startCommentFade:(id)sender{
    [self.commentFieldContainer setAlpha:0.0];
    
    //fade in
    [UIView animateWithDuration:1.0f animations:^{
        [self.commentFieldContainer setAlpha:1.0f];
        
        
    } completion:^(BOOL finished) {
        
        //fade out
        [UIView animateWithDuration:1.0f animations:^{
            
            [self.commentFieldContainer setAlpha:1.0f];
            
        } completion:nil];
        
    }];
}

@end
