//
//  FirstViewController.m
//  PhotoApp
//
//  Created by Jo Tu on 7/30/16.
//  Copyright © 2016 Turn To Tech. All rights reserved.
//

#import "FirstViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Post.h"
#import "ProductCell.h"
//#import "ASFSharedViewTransition.h"

@interface FirstViewController ()
//@property (nonatomic,strong) FIRStorageReference *storageRef;
//@property (nonatomic,strong) FIRStorageReference *imagesRef;
//@property(nonatomic,strong) FIRDatabaseReference *ref;
@property (nonatomic,strong) NSIndexPath *passIndexedPath;
@property (nonatomic,strong) PostDetailController *postDetailController;
@property (nonatomic,strong) UIImageView *sharedImageView;



@end

@implementation FirstViewController



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"clicked");

    self.postDetailController = [[PostDetailController alloc]init];
       self.postDetailController.currentPost = [self.dao.posts objectAtIndex:indexPath.row];[UIView  beginAnimations:nil context:NULL];
    
    NSLog(@"likes is %@",self.postDetailController.currentPost.likes);
//    [self.navigationController pushViewController:self.postDetailController animated:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:self.postDetailController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"demoCell" forIndexPath:indexPath]; //guarantees instantiated object
//    UIImageView *chImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.backgroundView.frame.size.width,cell.backgroundView.frame.size.height)];
    
    NSString *tempURL = (NSString*)[[self.dao.posts objectAtIndex:indexPath.row]downloadURL];
    
    
    
    [cell.cellImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempURL]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        cell.cellImageView.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
//    cell.tag = indexPath.row;
    
    
//    NSURL *imageUrl = [NSURL URLWithString:[self.dao.posts objectAtIndex:indexPath.row].downloadURL];
//    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
//    chImage.image = image;
    
//    NSLog(@"%@",[self.dao.posts objectAtIndex:indexPath.row].downloadURL); //Here can show Img's values correctly
    
    
    [cell.backgroundView addSubview:cell.cellImageView];
//    self.sharedImageView = cell.cellImageView;
    
    return cell;
}




-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    

    return [self.dao.posts count];
    
    
}

-(void)loadCollectionView{
    
//    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
//    flow.itemSize = CGSizeMake(100, 100); //override collection viewsize
//    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
//    flow.minimumInteritemSpacing = 0;
//    flow.minimumLineSpacing = 0;
//    

    [self.collectionView reloadData];
//    self.collectionView.collectionViewLayout = flow;


}




-(void)fetchInfoAfterOneSecLoad{
//    [self.dao getImageDownloadURLForCollectionView];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
//    self.title = @"Moments"; // TabBarItem.title inherits the viewController's self.title
    
    self.navigationItem.title = @"Moments";

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.44 green:0.44 blue:0.57 alpha:1.0];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    

    
    self.dao = [DAO sharedManager];

//    [NSTimer scheduledTimerWithTimeInterval:1.0                                     target:self
//                                   selector:@selector(fetchInfoAfterOneSecLoad)
//                                   userInfo:nil
//                                    repeats:NO];
//    
    
//    [self.dao getImageDownloadURLForCollectionView];
//    [self.collectionView reloadData];
    [NSTimer scheduledTimerWithTimeInterval:4.5                                     target:self
                                   selector:@selector(loadCollectionView)
                                   userInfo:nil
                                    repeats:YES];
    
    
    
    
//
//    [self.dao getImageDownloadURLForCollectionView];

//
//    [NSTimer scheduledTimerWithTimeInterval:4.0                                     target:self
//                                   selector:@selector(storageTest)
//                                   userInfo:nil
//                                    repeats:NO];//


//    [self storageTest];
//
//    [self.dao fetchMetaDataFromStorage]; //uncomment this
//     [self loadInfoIntoDB:@"whatever" withDownloadURL:@"Whatever"];
//    self.tabBarItem.image = [UIImage imageNamed:@"inactivehome.png"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






//-(void)setImagewith

-(void)storageTest{
    
//    NSString *url = [NSString stringWithFormat:@"https://boiling-heat-4086.firebaseio.com/images/%@.json",self.dao.posts[3].imageKey];
//    
//    //    NSMutableArray *comments = [@[@"hello",@"whats'up"]mutableCopy];
//    NSMutableArray *comments = [@[@"wtf",@"sup"]mutableCopy];
//    
//    
//    NSDictionary *parametersDictionary = @{@"comments":comments};
//    //    NSDictionary *parametersDictionary;
//    
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//    [manager setResponseSerializer:responseSerializer];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
//    
//    
//    
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    //    NSString *lastObject = [photoArray lastObject];
//    
//    [manager PATCH:url parameters:parametersDictionary success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"success!");
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error: %@", error);
//    }];
//    

    
    
    
//    NSLog(@"self.dao.posts count is %lu",[self.dao.posts count]);
//    
//    NSLog(@"self.dao.posts  is %@",self.dao.posts);

//    FIRStorage *storage = [FIRStorage storage];
//     self.storageRef = [storage referenceForURL:@"gs://boiling-heat-4086.appspot.com"];
//    self.imagesArray = [[NSMutableArray alloc]init];
//    FIRStorageReference *firstPhotoRef = [self.storageRef child:@"images/photo_02@3x.jpg"];
//
//    NSLog(@"bucket storageref %@",self.storageRef.bucket);
//    [firstPhotoRef dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData *data, NSError *error) {
//        
//        if (error != nil) {
//            NSLog(@"%@",error);
//            // Uh-oh, an error occurred!
//        } else {
//
//        UIImage *image = [UIImage imageWithData:data];
//        [self.imagesArray addObject:image];

//    NSString *tempURL = (NSString*)[[self.dao.posts objectAtIndex:0]downloadURL];
//    
//    
//    [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempURL]] placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
//        self.imageView.image = image;
//    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
//    
    
//    NSString *url = [NSString stringWithFormat:@"https://boiling-heat-4086.firebaseio.com/images/%@.json",self.dao.imageKeyArray[0]];
//    NSDictionary *parametersDictionary = @{@"comment check": comments};
//    //    NSDictionary *parametersDictionary;
//    NSLog(@"%@",self.dao.imageKeyArray[0]);
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//    [manager setResponseSerializer:responseSerializer];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
//    
//    
//    
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    //    NSString *lastObject = [photoArray lastObject];
//    
//    
//    
//    [manager POST:url parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"success!");
//    }
//          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//              NSLog(@"error: %@", error);
//              
//          }];
    

//        NSLog(@"number of images is %lu",(unsigned long)[self.imagesArray count]);
//            
//        }
//    }];
    
//    
//    FIRStorageReference *tempRef = [self.dao.imagesRef child:@"photo_01@3x.jpg"];
//    // Get metadata properties
//    [tempRef metadataWithCompletion:^(FIRStorageMetadata *metadata, NSError *error){
//        if (error != nil) {
//            // Uh-oh, an error occurred!
//        } else {
//         
////            NSURL *downloadURL = metadata.downloadURL;
//            
//            NSDictionary *tempData =  @{
//                                       @"1": @{
//                                               @"comments": @"Hey, this is really cool!",
//                                               @"downloadURL": metadata.downloadURL
//                                        
//                                               }
//                                       };
//            
//            metadata = (FIRStorageMetadata*)tempData;
//            
//            NSLog(@"%@",metadata);
//            
    
            
            
//            // Metadata now contains the metadata for 'images/forest.jpg'
//        }
//    }];


}

//#pragma mark - ASFSharedViewTransitionDataSource
//
//- (UIView *)sharedView
//{
//    
//    return self.sharedImageView;
//}
//
//

@end
