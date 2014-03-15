//
//  WYAHash.h
//  WhereYouApp
//
//  Created by Timothy Chu on 3/9/14.
//  Copyright (c) 2014 Timothy Chu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface WYAHash : NSObject

+ (NSString *) sha256:(NSString *)inputString;

@end
