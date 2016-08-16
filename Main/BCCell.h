//
//  BCCell.h
//  CollectionViewTutorial
//
//  Created by rckrbn on 22/07/13.
//  Copyright (c) 2013 Bryan Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageField;
@property (weak, nonatomic) IBOutlet UILabel *labelField;
@property (weak, nonatomic) IBOutlet UIImageView *imageLine;
@property (weak, nonatomic) IBOutlet UILabel *labelDetailField;

@end
