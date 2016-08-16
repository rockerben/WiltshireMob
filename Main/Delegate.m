//
//  Delegate.m
//  test
//
//  Created by rckrbn on 8/09/13.
//  Copyright (c) 2013 com.rockerben.Phoenix. All rights reserved.
//

#import "Delegate.h"



@implementation Delegate {
    NSMutableArray *_lines;
    NSMutableArray *_currentLine;
}
- (void)dealloc {

}
- (void)parserDidBeginDocument:(CHCSVParser *)parser {
    _lines = [[NSMutableArray alloc] init];
}
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {
    _currentLine = [[NSMutableArray alloc] init];
}
- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    NSLog(@"%@", field);
    [_currentLine addObject:field];
        
}
- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    [_lines addObject:_currentLine];
 
    _currentLine = nil;
}
- (void)parserDidEndDocument:(CHCSVParser *)parser {
    	NSLog(@"parser ended");
}
- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"ERROR: %@", error);
    _lines = nil;
}
@end