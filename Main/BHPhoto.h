//
//  BHPhoto.h
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHPhoto : NSObject

@property (nonatomic, strong, readonly) NSURL *imageURL;
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, strong, readonly) NSString *caption;

+ (BHPhoto *)photoWithImageURL:(NSURL *)imageURL withCaption:(NSString *)caption;

- (id)initWithImageURL:(NSURL *)imageURL withCaption:caption;

@end
