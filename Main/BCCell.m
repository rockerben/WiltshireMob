//
//  BCCell.m
//  CollectionViewTutorial
//
//  Created by rckrbn on 22/07/13.
//  Copyright (c) 2013 Bryan Hansen. All rights reserved.
//

#import "BCCell.h"

@implementation BCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
