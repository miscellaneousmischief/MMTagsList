//
//  MMSpacing.h
//  MMTagList
//
//  Created by Joshua Martin on 10/7/14.
//  Copyright (c) 2014 Miscellaneous Mischief. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSpacing : NSObject

@property float left;
@property float right;
@property float top;
@property float bottom;

+(instancetype) spacingWithLeft: (float) l right: (float) r top: (float) t andBottom: (float) b;

-(void) updateWithLeft: (float) l right: (float) r top: (float) t andBottom: (float) b;

@end
