//
//  BHPhoto.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "BHPhoto.h"

@interface BHPhoto ()

@property (nonatomic, strong, readwrite) NSURL *imageURL;
@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, strong, readwrite) NSString *caption;


@end

@implementation BHPhoto

#pragma mark - Properties

- (UIImage *)image
{
    if (!_image && self.imageURL) {
        NSData *imageData = [NSData dataWithContentsOfURL:self.imageURL];
        UIImage *image = [UIImage imageWithData:imageData scale:[UIScreen mainScreen].scale];
        
        _image = image;
    }
    
    return _image;
    ;
}

#pragma mark - Lifecycle

+ (BHPhoto *)photoWithImageURL:(NSURL *)imageURL withCaption:(NSString *)caption    
{
    return [[self alloc] initWithImageURL:imageURL withCaption:caption];
}

- (id)initWithImageURL:(NSURL *)imageURL withCaption:caption;
{
    self = [super init];
    if (self) {
        self.imageURL = imageURL;
        self.caption = caption;
    }
    return self;
}

@end
