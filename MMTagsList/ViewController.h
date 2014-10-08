//
//  ViewController.h
//  MMTagList
//
//  Created by Joshua Martin on 10/1/14.
//  Copyright (c) 2014 Miscellaneous Mischief. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMTagList.h"

@interface ViewController : UIViewController <MMTagListDataSource, MMTagListDelegate>
@property (weak, nonatomic) IBOutlet MMTagList *tagList;
@property NSArray * tags;

@end

