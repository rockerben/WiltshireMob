//
//  PinchLayout.h
//  CollectionViewTutorial
//
//  Created by rckrbn on 18/07/13.
//  Copyright (c) 2013 Bryan Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinchLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) CGFloat pinchScale;
@property (nonatomic, assign) CGPoint pinchCenter;
@property (nonatomic, assign) BOOL isCLicked;
@end
