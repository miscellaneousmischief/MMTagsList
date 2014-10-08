//
//  ViewController.m
//  MMTagsList
//
//  Created by Joshua Martin on 10/1/14.
//  Copyright (c) 2014 Miscellaneous Mischief. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tags = @[ @"one two three", @"two", @"three", @"four", @"five", @"six", @"one", @"two", @"three", @"four", @"five", @"six",@"one two three", @"two", @"three", @"four", @"five", @"six", @"one", @"two", @"three", @"four", @"five", @"six" ];
    // self.tags is your data, it does not need to be passed to self.tagsList. MMTagsList manages it's data solely through its datasource
    
//    self.tagsList.tagsListDatasource = self; // These can be set programatically or in the storyboard
//    self.tagsList.tagsListDelegate = self;   // These can be set programatically or in the storyboard
    
    self.tagsList.selectable = true; // If you want to be able to select tags this must be set to true. The default is false.
    
    MMSpacing * margin = [MMSpacing spacingWithLeft:10.0f right:10.0f top:10.0f andBottom:10.0f];
    MMSpacing * padding = [MMSpacing spacingWithLeft:10.0f right:10.0f top:10.0f andBottom:10.0f];
    
    [self.tagsList setTagViewMargin:  margin];
    [self.tagsList setTagViewPadding:  padding];
    

    /*
        View did load is called before the tags list renders for the first time, that means you can set tagViewMargin and padding without significant effect (reloadData is called after here)
        If you want to update them after here consider using one of their update methods in MMTagsList.h, otherwise you will have to manually call reloadData
        Note that it is more efficient to use the batch update method (updateTagViewSpacinWithMargin:andPadding:) than each update method separately because it will only call reloadData one time
    */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(MMTagView *)tagsList:(MMTagsList *)tagsList modifyTagViewForIndex:(NSInteger)index fromTagView:(MMTagView *)tagView{
//    
//    // Add custom styling here
//    
//    tagView.backgroundColor = [UIColor lightGrayColor];
//    tagView.layer.cornerRadius = 3.0f;
//    tagView.layer.borderColor = [UIColor darkGrayColor].CGColor;
//    tagView.layer.borderWidth = 1.0f;
//    [tagView.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    tagView.clipsToBounds = YES;
//    
//    return tagView;
//}

-(NSString *)tagsList:(MMTagsList *)tagsList tagForTagViewAtIndex:(NSInteger)index{
    
    // Return the NSString you want to display in the tagView
    
    // TODO: make this is a convenience method. return @"" if you want to control view more fully in tagsList:modifyTagViewForIndex:fromTagView:

    return [self.tags objectAtIndex:index];
}

-(NSInteger)tagsListNumberOfTags:(MMTagsList *)tagsList{
    
    // Tell the data source how many tags it will need to make
    
    return self.tags.count;
}


//
//-(BOOL)tagsList:(MMTagsList *)tagsList shouldSelectTagViewAtIndex:(NSInteger)index{
//    
//    // Decide whether or not to select that tagView
//    
//    return true;
//}
//
//-(MMTagView *)tagsList:(MMTagsList *)tagList didSelectTagViewAtIndex:(NSInteger)index andOfferTagViewForModifications:(MMTagView *)tagView{
//    
//    // Add custom styling for a selected tag here
//    
//    [UIView beginAnimations:@"colorChange" context:nil];
//        tagView.button.backgroundColor = [UIColor orangeColor];
//    [UIView commitAnimations];
//    return tagView;
//}
//
//-(BOOL)tagsList:(MMTagsList *)tagsList shouldDeselectTagViewAtIndex:(NSInteger)index{
//    
//    // Decide whether or not to deselect that tagView
//    
//    return true;
//}
//
//-(MMTagView *)tagsList:(MMTagsList *)tagList didDeselectTagViewAtIndex:(NSInteger)index andOfferTagViewForModifications:(MMTagView *)tagView{
//    
//    // Add custom styling for a deselected tag here
//    
//    [UIView beginAnimations:@"colorChange" context:nil];
//        tagView.button.backgroundColor = [UIColor clearColor];
//    [UIView commitAnimations];
//    return tagView;
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"selected tags: %@", self.tagsList.indexesForSelectedTags);
}

@end
