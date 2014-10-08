//
//  MMTagView.h
//  MMTagsList
//
//  Created by Joshua Martin on 10/1/14.
//  Copyright (c) 2014 Miscellaneous Mischief. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMTagView : UIView

@property (weak, nonatomic) IBOutlet UIButton *button;
@property BOOL selected;
@property NSInteger tagListIndex;

@end
