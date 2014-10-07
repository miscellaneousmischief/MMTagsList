//
//  ViewController.h
//  MMTagsList
//
//  Created by Joshua Martin on 10/1/14.
//  Copyright (c) 2014 Miscellaneous Mischief. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMTagsList.h"

@interface ViewController : UIViewController <MMTagsListDataSource, MMTagsListDelegate>
@property (weak, nonatomic) IBOutlet MMTagsList *tagsList;
@property NSArray * tags;

@end

