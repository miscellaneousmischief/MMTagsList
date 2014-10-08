//
//  MMSpacing.m
//  MMTagsList
//
//  Created by Joshua Martin on 10/7/14.
//  Copyright (c) 2014 Miscellaneous Mischief. All rights reserved.
//

#import "MMSpacing.h"

@implementation MMSpacing

-(void) updateWithLeft: (float) l right: (float) r top: (float) t andBottom: (float) b{
    _left   = l;
    _right  = r;
    _top    = t;
    _bottom = b;
}

+(instancetype) spacingWithLeft: (float) l right: (float) r top: (float) t andBottom: (float) b{
    
    MMSpacing * spacing = [[MMSpacing alloc] init];
    [spacing updateWithLeft:l right:r top:t andBottom:b];

    return spacing;
}

@end