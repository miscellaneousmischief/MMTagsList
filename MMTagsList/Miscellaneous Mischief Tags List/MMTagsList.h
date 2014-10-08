//
//  MMTagsList.h
//  MMTagsList
//
//  Created by Joshua Martin on 10/1/14.
//  Copyright (c) 2014 Miscellaneous Mischief. All rights reserved.
//
// TODO: shouldn't scroll when reloadData is called
// TODO: make tags UITableView style (e.g.reusable cells)
// TODO: make it suck less.

#import <UIKit/UIKit.h>
#import "MMTagView.h"
#import "MMSpacing.h"

@class MMTagsList;

@protocol MMTagsListDataSource <NSObject>
@optional
-(MMTagView *) tagsList: (MMTagsList *) tagsList modifyTagViewForIndex: (NSInteger) index fromTagView: (MMTagView *) tagView;
@required
-(NSInteger)   tagsListNumberOfTags: (MMTagsList *) tagsList;
-(NSString *)  tagsList: (MMTagsList *) tagsList tagForTagViewAtIndex: (NSInteger) index;
@end

@protocol MMTagsListDelegate <NSObject>

@optional

- (BOOL) tagsList: (MMTagsList *) tagsList   shouldSelectTagViewAtIndex: (NSInteger) index;
- (MMTagView *) tagsList: (MMTagsList *) tagsList   didSelectTagViewAtIndex: (NSInteger) index andOfferTagViewForModifications: (MMTagView *) tagView;

- (BOOL) tagsList: (MMTagsList *) tagsList   shouldDeselectTagViewAtIndex: (NSInteger) index;
- (MMTagView *) tagsList: (MMTagsList *) tagsList didDeselectTagViewAtIndex: (NSInteger) index andOfferTagViewForModifications: (MMTagView *) tagView;


// TODO: consider adding highlight and unhighlight delegate methods

@end


@interface MMTagsList : UIScrollView{
    // This bool allows the tag views to be displayed initially without user intervention, but prevents them from reloading everytime the view scrolls
    BOOL wasLaidOutPreviously;
}

@property NSMutableArray * tagViews;
@property NSMutableArray * indexesForSelectedTags;

@property BOOL selectable;

@property (nonatomic, retain) MMSpacing* tagViewMargin; // Note: if you update this manually you must call reload Data, call the update instead
@property (nonatomic, retain) MMSpacing* tagViewPadding; // Note: if you update this manually you must call reload Data, call the update instead

-(void) updateTagViewSpacingWithMargin: (MMSpacing *) margin andPadding: (MMSpacing *) padding; // this method is faster than calling the two below
-(void) updateTagViewMarginWithLeft: (float) left right: (float) right top: (float) top andBottom: (float) bottom; // this calls reloadData (slow)
-(void) updateTagViewPaddingWithLeft: (float) left right: (float) right top: (float) top andBottom: (float) bottom; // this calls reloadData (slow)

@property (weak, nonatomic) IBOutlet id<MMTagsListDataSource> tagsListDatasource;
@property (weak, nonatomic) IBOutlet id<MMTagsListDelegate>   tagsListDelegate;


-(void) reloadData;
@end
