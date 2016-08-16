//
//  BHCollectionViewController.m
//
//  Created by Ben Cortez on 11/3/12.
//  Copyright (c) 2013 Ben Cortez. All rights reserved.
//

#import "BHCollectionViewController.h"
#import "BHPhotoAlbumLayout.h"
#import "BHAlbumPhotoCell.h"
#import "BHAlbum.h"
#import "BHPhoto.h"
#import "BHAlbumTitleReusableView.h"

#import "PinchLayout.h"
#import "DetailLabel.h"


static const CGFloat kMinScale = 1.0f;
static const CGFloat kMaxScale = 3.0f;
static NSString * const PhotoCellIdentifier = @"PhotoCell";
static NSString * const AlbumTitleIdentifier = @"AlbumTitle";


@interface BHCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, weak)   BHPhotoAlbumLayout *photoAlbumLayout;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchOutGestureRecognizer;
@property (nonatomic, strong) UICollectionView *currentPinchCollectionView;
@property (nonatomic, strong) UILabel *subHdrLabel; //header label in the element view
@property (nonatomic, strong) NSIndexPath *currentPinchedItem;

@end


@implementation BHCollectionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //ios 7 status bar fix
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeAll;
        
    // CollectionView layout design
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIImage *patternImage = [UIImage imageNamed:@"gray"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    self.currentPinchCollectionView.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    // Add identifiers
    [self.collectionView registerClass:[BHAlbumPhotoCell class]
            forCellWithReuseIdentifier:PhotoCellIdentifier];
    [self.collectionView registerClass:[BHAlbumTitleReusableView class]
            forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind1
                   withReuseIdentifier:AlbumTitleIdentifier];
    
    // Add concurrency
    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
    
    // Add gesture recognizers
    //self.pinchOutGestureRecognizer = [[UIPinchGestureRecognizer alloc]
    //                                  initWithTarget:self action:@selector(handlePinchOutGesture:)];
    //[self.collectionView addGestureRecognizer:self.pinchOutGestureRecognizer];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.photoAlbumLayout.numberOfColumns = 3;
        
        // handle insets for iPhone 4 or 5
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ?
        45.0f : 25.0f;
        
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
        
    } else {
        self.photoAlbumLayout.numberOfColumns = 2;
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}

#pragma mark - Pinch Gestures

- (void)handlePinchOutGesture: (UIPinchGestureRecognizer*)recognizer
{
    // 1
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        // 2
        CGPoint pinchPoint =
        [recognizer locationInView:self.collectionView];
        NSIndexPath *pinchedItem = [self.collectionView
                                    indexPathForItemAtPoint:pinchPoint];
        if (pinchedItem)
        {
            // 3
            self.currentPinchedItem = pinchedItem;
            // 4
            PinchLayout *layout1 = [[PinchLayout alloc] init];
            layout1.itemSize = CGSizeMake(250.0f, 250.0f);
            layout1.minimumInteritemSpacing = 20.0f;
            layout1.minimumLineSpacing = 20.0f;
            layout1.sectionInset = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
            layout1.headerReferenceSize = CGSizeMake(0.0f, 90.0f);
            layout1.pinchScale = 0.0f;
            layout1.isCLicked = NO;
            // 5
            self.currentPinchCollectionView = [[UICollectionView alloc]
                                               initWithFrame:self.collectionView.frame collectionViewLayout:layout1];
            self.currentPinchCollectionView.backgroundColor = [UIColor clearColor];
            self.currentPinchCollectionView.delegate = self;
            self.currentPinchCollectionView.dataSource = self;
            self.currentPinchCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.currentPinchCollectionView registerClass:[BHAlbumPhotoCell class]
                                forCellWithReuseIdentifier:PhotoCellIdentifier];
            [self.currentPinchCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
            // 6
            UIImage *patternImage = [UIImage imageNamed:@"graywood"];
            self.view.backgroundColor = [UIColor colorWithPatternImage:patternImage];
            [self.view addSubview:self.currentPinchCollectionView];
            // 7
            UIPinchGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handlePinchInGesture:)];
            [_currentPinchCollectionView addGestureRecognizer:recognizer];
        }
        
    } else
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            if (self.currentPinchedItem) {
                // 8
                CGFloat theScale = recognizer.scale;
                theScale = MIN(theScale, kMaxScale);
                theScale = MAX(theScale, kMinScale);
                // 9
                CGFloat theScalePct = (theScale - kMinScale) / (kMaxScale - kMinScale);
                // 10
                PinchLayout *layout = (PinchLayout*)_currentPinchCollectionView.collectionViewLayout;
                layout.pinchScale = theScalePct;
                layout.pinchCenter = [recognizer locationInView:self.collectionView];
                // 11
                self.collectionView.alpha = 1.0f - theScalePct;
            }
        } else {
            if (self.currentPinchedItem) {
                // 12
                PinchLayout *layout = (PinchLayout*)_currentPinchCollectionView.collectionViewLayout;
                layout.pinchScale = 1.0f;
                self.collectionView.alpha = 0.0f;
            }
        }
}


- (void)handlePinchInGesture: (UIPinchGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // 1
        self.collectionView.alpha = 0.0f; }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // 2
        CGFloat theScale = 1.0f / recognizer.scale;
        theScale = MIN(theScale, kMaxScale);
        theScale = MAX(theScale, kMinScale);
        CGFloat theScalePct = 1.0f - ((theScale - kMinScale) / (kMaxScale - kMinScale));
        // 3
        PinchLayout *layout = (PinchLayout*)self.currentPinchCollectionView.collectionViewLayout ;
        layout.pinchScale = theScalePct;
        layout.pinchCenter = [recognizer locationInView:self.collectionView];
        // 4
        self.collectionView.alpha = 1.0f - theScalePct; } else {
            // 5
            self.collectionView.alpha = 1.0f;
            [self.currentPinchCollectionView removeFromSuperview];
            self.currentPinchCollectionView = nil;
            self.currentPinchedItem = nil;
        } }


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.currentPinchCollectionView) {
        return 1;
    }
    
    else {
        return self.albums.count;
        
    }
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.currentPinchCollectionView) {
       
        return 1;
    }
    
    else {
        BHAlbum *album = self.albums[0];
        
        return album.photos.count;
        
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BHAlbumPhotoCell *photoCell =
    [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier
                                              forIndexPath:indexPath];
    
    if (collectionView == self.currentPinchCollectionView) {
        
        NSIndexPath * p = self.currentPinchedItem;
        BHAlbum *album = self.albums[p.section];
        BHPhoto *photo = album.photos[p.item];
        
        __weak BHCollectionViewController *weakSelf = self;
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            UIImage *image = [photo image];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // then set them via the main queue if the cell is still visible.
                if ([weakSelf.currentPinchCollectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                    BHAlbumPhotoCell *cell =
                    (BHAlbumPhotoCell *)[weakSelf.currentPinchCollectionView cellForItemAtIndexPath:indexPath];
                    cell.imageView.image = image;
                }
            });
        }];
        
        operation.queuePriority = (indexPath.item == 0) ?
        NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
        
        [self.thumbnailQueue addOperation:operation];
        
    } else {
        
        BHAlbum *album = self.albums[indexPath.section];
        BHPhoto *photo = album.photos[indexPath.item];
        
        // load photo images in the background
        __weak BHCollectionViewController *weakSelf = self;
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            UIImage *image = [photo image];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // then set them via the main queue if the cell is still visible.
                if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                    BHAlbumPhotoCell *cell =
                    (BHAlbumPhotoCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                    cell.imageView.image = image;
                }
            });
        }];
        
        operation.queuePriority = (indexPath.item == 0) ?
        NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
        
        [self.thumbnailQueue addOperation:operation];
    }
    return photoCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    if (collectionView == self.currentPinchCollectionView) {
        
        // This pertains to the header label in the element view
        if (kind == UICollectionElementKindSectionHeader) {
            UICollectionReusableView *headerView = [self.currentPinchCollectionView
                                                    dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                    withReuseIdentifier:@"header"
                                                    forIndexPath:indexPath];
            
            self.subHdrLabel = [[DetailLabel alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
            self.subHdrLabel.textAlignment = NSTextAlignmentCenter;
            self.subHdrLabel.font = [UIFont boldSystemFontOfSize:18.0f];
            
            NSIndexPath * p = self.currentPinchedItem;
            BHAlbum *album = self.albums[p.section];
            BHPhoto *photo = album.photos[p.item];
            
            // Get the photo caption
            self.subHdrLabel.text = photo.caption;
            [headerView addSubview:self.subHdrLabel];
            
            // Retrieve details of the current image
            
            //Take note of the space as all the parsed URL in the CSV contains a leading whitespace
            NSString *urlString = [NSString stringWithFormat:@"%@", photo.imageURL];
            
            // Get the CSV data
            NSMutableArray *linesarray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"Key"]];
            
            // Get the array line start where this URL is
            int i = [linesarray indexOfObjectPassingTest:^BOOL(id element,NSUInteger idx,BOOL *stop)
                     {
                         return [(NSArray *)element containsObject:urlString];
                     }];
            
            // Getting values off array
            NSArray *arrayLine =  linesarray[i];
            
            // PASS EACH ELEMENT TO CORRESPONDING VIEW OBJECT
            
            UITextView * dtlText1 = [[UITextView alloc]initWithFrame:CGRectMake(8, 320, 300, 50)];
            dtlText1.backgroundColor = [UIColor clearColor];
            dtlText1.textAlignment = NSTextAlignmentLeft;
            dtlText1.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0f];
            dtlText1.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
            dtlText1.text = arrayLine[4];
            [headerView addSubview:dtlText1];
            
            DetailLabel * dtlLabel3 =  [[DetailLabel alloc]initWithFrame:CGRectMake(10, 375, 300, 20)];
            dtlLabel3.font = [UIFont fontWithName:@"Helvetica Neue" size:11.0f];
            dtlLabel3.text = [NSString stringWithFormat:@" %@", arrayLine[5]];
            [headerView addSubview:dtlLabel3];
            
            DetailLabel * dtlLabel4 =  [[DetailLabel alloc]initWithFrame:CGRectMake(10, 390, 300, 20)];
            dtlLabel4.text = [NSString stringWithFormat:@" %@", arrayLine[6]];
            dtlLabel4.font = [UIFont fontWithName:@"Helvetica Neue" size:11.0f];
            [headerView addSubview:dtlLabel4];
            
            DetailLabel * dtlLabel5 =  [[DetailLabel alloc]initWithFrame:CGRectMake(10, 405, 300, 20)];
            dtlLabel5.text = [NSString stringWithFormat:@" %@",arrayLine[7]];
            dtlLabel5.font = [UIFont fontWithName:@"Helvetica Neue" size:11.0f];
            [headerView addSubview:dtlLabel5];
            
            DetailLabel * dtlLabel6 =  [[DetailLabel alloc]initWithFrame:CGRectMake(10, 420, 300, 20)];
            dtlLabel6.text = [NSString stringWithFormat:@" %@",arrayLine[8]];
            dtlLabel6.font = [UIFont fontWithName:@"Helvetica Neue" size:11.0f];
            [headerView addSubview:dtlLabel6];
            
            DetailLabel * dtlLabel7 =  [[DetailLabel alloc]initWithFrame:CGRectMake(10, 435, 300, 20)];
            dtlLabel7.text = [NSString stringWithFormat:@" Available at: %@",arrayLine[9]];
            dtlLabel7.font = [UIFont fontWithName:@"Helvetica Neue" size:11.0f];
            [headerView addSubview:dtlLabel7];
            
            DetailLabel * dtlLabel8 =  [[DetailLabel alloc]initWithFrame:CGRectMake(10, 450, 300, 20)];
            dtlLabel8.text = [NSString stringWithFormat:@" Item Code: %@",arrayLine[10]];
            dtlLabel8.font = [UIFont fontWithName:@"Helvetica Neue" size:11.0f];
            [headerView addSubview:dtlLabel8];
            
            DetailLabel * dtlLabel9 =  [[DetailLabel alloc]initWithFrame:CGRectMake(10, 465, 300, 20)];
            dtlLabel9.text = [NSString stringWithFormat:@" Barcode: %@",arrayLine[11]];
            dtlLabel9.font = [UIFont fontWithName:@"Helvetica Neue" size:11.0f];
            [headerView addSubview:dtlLabel9];
            
            return headerView;
        }
        
    } else {
        
        // This is the caption of each cell in the main collection view
        
        BHAlbumTitleReusableView *titleView =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:AlbumTitleIdentifier
                                                  forIndexPath:indexPath];
        
        BHAlbum *album = self.albums[indexPath.section];
        BHPhoto *photo = album.photos[indexPath.item];
        titleView.titleLabel.text = photo.caption;
        
        return titleView;
    }
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // This comes from the pinched or element view, when the image is tapped to display additional details //feature deprecated. maybe a long press will add the record on the order (with prompt)
    
    if (collectionView == self.currentPinchCollectionView) {
     
        
        
        
        
        
    } else {
        
        // This comes from the main UICollectionView. When an image is clicked from the list of photos.
        // 2
        if (indexPath)
       {
            // 3
            self.currentPinchedItem = indexPath;
            // 4
            PinchLayout *layout1 = [[PinchLayout alloc] init];
            layout1.itemSize = CGSizeMake(250.0f, 250.0f);
            layout1.minimumInteritemSpacing = 20.0f;
            layout1.minimumLineSpacing = 20.0f;
            layout1.sectionInset = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
            layout1.headerReferenceSize = CGSizeMake(0.0f, 40.0f);
            layout1.pinchScale = 0.0f;
            layout1.isCLicked = YES;
            // 5
            self.currentPinchCollectionView = [[UICollectionView alloc]
                                               initWithFrame:self.collectionView.frame collectionViewLayout:layout1];
            self.currentPinchCollectionView.delegate = self;
            self.currentPinchCollectionView.dataSource = self;
            self.currentPinchCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.currentPinchCollectionView registerClass:[BHAlbumPhotoCell class]
                                forCellWithReuseIdentifier:PhotoCellIdentifier];
            [self.currentPinchCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
            // 6
            UIImage *patternImage = [UIImage imageNamed:@"graywood"];
            self.currentPinchCollectionView.backgroundColor = [UIColor colorWithPatternImage:patternImage];
            [self.view addSubview:self.currentPinchCollectionView];
            // 7
           
            //when view is swiped down, the  view is removed from superView
            UISwipeGestureRecognizer *down = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipe)];
            [down setDirection:UISwipeGestureRecognizerDirectionDown];
            [_currentPinchCollectionView addGestureRecognizer:down];
           
           
           
        }
    }
}

-(void) downSwipe
{
    [self.currentPinchCollectionView removeFromSuperview];
    self.currentPinchCollectionView = nil;
 
}

@end
