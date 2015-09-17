//
//  Manacher.m
//  tests
//
//  Created by Philip Bernstein on 9/17/15.
//  Copyright © 2015 Philip Bernstein. All rights reserved.
//

#import "Manacher.h"

@implementation Manacher


+(NSString *)longestPalindromeInString:(NSString *)string {
    NSString *toReturn = [Manacher processedString:string];
    toReturn = [self findLargestPalindrome:toReturn];
    
    return toReturn;
}
+(NSString *)findLargestPalindrome:(NSString *)string { // finds largest palindrome
    
    NSMutableArray *p = [[NSMutableArray alloc] initWithCapacity:string.length];
    
    for (int i = 0; i < string.length; i++) {
        [p addObject:@0];
    }
    
    int center = 0, right = 0;
    for (int i = 1; i < string.length-1; i++) {
        int mirror = 2*center - i;
        
        if (right > i)
            [p setObject:[NSNumber numberWithInt:MIN(right - i, [[p objectAtIndex:mirror] intValue])] atIndexedSubscript:i];
        
        NSString *comp1 = [string substringWithRange:NSMakeRange(i + (1 + [[p objectAtIndex:i] intValue]), 1)];
        NSString *comp2 = [string substringWithRange:NSMakeRange(i - (1 + [[p objectAtIndex:i] intValue]), 1)];
        
        // attempt to expand palindrome centered at i
        while ([comp1 isEqualToString:comp2]) {
            [p setObject:[NSNumber  numberWithInt:[[p objectAtIndex:i] intValue] + 1] atIndexedSubscript:i];
            comp1 = [string substringWithRange:NSMakeRange(i + (1 + [[p objectAtIndex:i] intValue]), 1)];
            comp2 = [string substringWithRange:NSMakeRange(i - (1 + [[p objectAtIndex:i] intValue]), 1)];
        }
        
        // if palindrome centered at i expands past right,
        // adjust center based on expanded palindrome.
        if (i + [[p objectAtIndex:i] intValue] > right) {
            center = i;
            right = i + [[p objectAtIndex:i] intValue];
        }
    }
    
    return [Manacher longestPalindrome:string array:p];
}

+(NSString *)longestPalindrome:(NSString *)string array:(NSArray *)p {
    
    
    int length = 0;   // length of longest palindromic substring
    int center = 0;   // center of longest palindromic substring
    for (int i = 1; i < p.count-1; i++) {
        if ([[p objectAtIndex:i] intValue] > length) {
            length = [[p objectAtIndex:i] intValue];
            center = i;
        }
    }
    
    NSInteger start = (center - 1 - length) / 2 + 1;
    NSInteger end = (center - 1 + length) / 2 + 1;
    
    string = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    return [[string substringToIndex:end] substringFromIndex:start];
    
}

+(NSString *)processedString:(NSString *)string { // preprocess string
    NSMutableString *mutableString = [NSMutableString stringWithString:@"$#"];
    
    for (int i = 0; i < string.length; i++) {
        NSString *next = [string substringWithRange:NSMakeRange(i, 1)];
        [mutableString appendString:next];
        [mutableString appendString:@"#"];
    }
    
    
    [mutableString appendString:@"@"];
    
    return mutableString;
}

@end
