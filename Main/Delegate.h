//
//  Delegate.h
//  test
//
//  Created by rckrbn on 8/09/13.
//  Copyright (c) 2013 com.rockerben.Phoenix. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "CHCSVParser.h"

@interface Delegate : NSObject <CHCSVParserDelegate>
@property (readonly) NSArray *lines;


@end