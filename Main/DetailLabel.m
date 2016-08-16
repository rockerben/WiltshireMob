//
//  DetailLabel.m
//  WiltshireMob
//
//  Created by rckrbn on 4/10/13.
//
//

#import "DetailLabel.h"




@implementation DetailLabel

- (id)initWithFrame:(CGRect)frame
{
self = [super initWithFrame:frame];
    if (self) {
       
        // Initialization code
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentLeft;
        self.font = [UIFont boldSystemFontOfSize:10.0f];
        self.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        self.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
        self.shadowOffset = CGSizeMake(0.0f, 1.0f);
       

       
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
