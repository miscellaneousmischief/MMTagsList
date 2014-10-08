//
//  MMTagList.m
//  MMTagList
//
//  Created by Joshua Martin on 10/1/14.
//  Copyright (c) 2014 Miscellaneous Mischief. All rights reserved.
//

#import "MMTagList.h"

@implementation MMTagList

-(void)awakeFromNib{
    self.tagViewMargin = [[MMSpacing alloc] init];
    self.tagViewPadding = [[MMSpacing alloc] init];
    self.indexesForSelectedTags = [NSMutableArray array];
    self.selectable = false;
    wasLaidOutPreviously = false;
}

-(void) layoutSubviews{
    if(!wasLaidOutPreviously){ // This allows the tag views to be displayed initially without user intervention, but prevents them from reloading everytime the view scrolls
        [self reloadData];
        wasLaidOutPreviously = true;
    }
}

-(void) reloadData{
    
    if(!self.tagListDatasource){ return; }
    
    NSInteger tagsCount = [self.tagListDatasource tagListNumberOfTags:self];

    if(!self.tagViews){   self.tagViews = [NSMutableArray arrayWithCapacity:tagsCount];   }
    NSMutableArray * updatedTagViews = [NSMutableArray arrayWithCapacity:tagsCount];
    
    for (NSInteger i = 0; i < tagsCount; i++) {
        NSString * text = [self.tagListDatasource tagList:self tagForTagViewAtIndex:i];
        
        MMTagView * tagView = [self.tagViews firstObject];
        if (!tagView) {
            
            tagView = [[[NSBundle mainBundle] loadNibNamed:@"MMTagView" owner:self options:nil] firstObject]; // TODO: allow a custom .xib that can style both default and selected states
            
            // Attach handler to Button
            [tagView.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            [self.tagViews removeObjectAtIndex:0];
        }
        
        
        // Style Tag View.
        if(self.tagListDatasource && [self.tagListDatasource respondsToSelector:@selector(tagList:modifyTagViewForIndex:fromTagView:)]){
            tagView = [self.tagListDatasource tagList:self modifyTagViewForIndex:i fromTagView:tagView];
        }else{
            // Layout Default View
            [self applyDefaultTagStyleTo:tagView];
        }
        
        
        // Set text Attributes and determine size based on text TODO: runtime attr determination
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize: 18]};
        // Prevent the Tag View from exceeding it's expected height or the width of it's container (self)
        CGSize boundingSize = CGSizeMake(self.frame.size.width - (self.tagViewMargin.left + self.tagViewPadding.left + self.tagViewPadding.right), CGFLOAT_MAX);
        CGRect stringRect =[text boundingRectWithSize: boundingSize
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
        CGSize stringSize = stringRect.size;
        //        [text sizeWithAttributes:attributes];
        
        // Set the Buttons frame according to the string's size, taking into account padding
        tagView.button.frame = CGRectMake(0.0f, 0.0f, stringSize.width + self.tagViewPadding.left + self.tagViewPadding.right, stringSize.height + self.tagViewPadding.top + self.tagViewPadding.bottom);
        // Set the button's title
        [tagView.button setTitle:text forState:UIControlStateNormal];
        
        // Set the Tag Views Frame according to the string's size
        tagView.frame = tagView.button.frame;
        
        // Set the tag on the button so we can determine its index during a control event
        [tagView.button setTag:updatedTagViews.count];

        
        // Add Tag View to array of tag views and as a subview of this view
        [updatedTagViews addObject:tagView];
        [self addSubview:tagView];
    }
    
    // If the number of tags decreases with a reload, you need to remove the extra views
    for (UIView * view in self.tagViews) {  [view removeFromSuperview]; }
    
    self.tagViews = [NSMutableArray arrayWithArray:updatedTagViews];
    
    [self layoutTagViews];
    
}

-(void) layoutTagViews{
    CGPoint offset = CGPointMake(self.tagViewMargin.left, self.tagViewMargin.top);
    
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[MMTagView class]]) {
            
            CGFloat w = view.frame.size.width;
            CGFloat h = view.frame.size.height;
            
            // if you've hit the end of a line, \n\r taking into account margins
            if(offset.x + w > self.frame.size.width){ offset = CGPointMake(self.tagViewMargin.left, offset.y + h + self.tagViewMargin.top + self.tagViewMargin.bottom); }
            
            // Set the Tag Views frame to a top left floating position
            [view setFrame:CGRectMake(offset.x, offset.y, w, h)];
            
            // Increase the offset for the next view to reference
            offset.x += w;
            offset.x += self.tagViewMargin.left;
            offset.x += self.tagViewMargin.right;
            
            // Increase the content size of this view so that it will scroll
            self.contentSize = CGSizeMake(self.frame.size.width, offset.y + h + self.tagViewMargin.top + self.tagViewMargin.bottom );
        }
    }
    
}

-(void) buttonPressed: (UIButton *) sender{
    NSInteger tagViewIndex = sender.tag; // If for some reason the tags don't match the index, this will cause problems
    MMTagView * tagView = [self.tagViews objectAtIndex:sender.tag]; // If for some reason the tags don't match the index, this will cause problems

    if(self.selectable){
        
        /* notify delegate of updated tagView */
        if (self.tagListDelegate) {

            if(!tagView.selected){ // The view will be selected
                SEL shouldSelect = @selector(tagList:shouldSelectTagViewAtIndex:);
                SEL didSelect = @selector(tagList:didSelectTagViewAtIndex:andOfferTagViewForModifications:);
                
                BOOL willSelect = TRUE; // allows the user to cancel selection
                
                if([self.tagListDelegate respondsToSelector:shouldSelect]){
                    // ask the user if they wish to cancel selection
                    willSelect = [self.tagListDelegate tagList:self shouldSelectTagViewAtIndex:tagViewIndex];
                }
                
                // if the user did not cancel selection, set the tagView's selected state to selected
                if(willSelect){
                    [self.indexesForSelectedTags addObject:[NSNumber numberWithLong: tagViewIndex]];
                    tagView.selected = true;
                }
                
                if(willSelect && [self.tagListDelegate respondsToSelector:didSelect]){
                    // notify user of selection and allow them to edit the tagview
                    [self.tagListDelegate tagList:self didSelectTagViewAtIndex:sender.tag andOfferTagViewForModifications:tagView];
                    // TODO: consider resetting the frame (layout) here
                }else if(willSelect){
                    [self applyDefaultSelectedTagStyleTo:tagView];
                }
                
            } else
                if(tagView.selected){ // The view will be deselected
                
                    SEL shouldDeselect = @selector(tagList:shouldDeselectTagViewAtIndex:);
                    SEL didDeselect = @selector(tagList:didDeselectTagViewAtIndex:andOfferTagViewForModifications:);
                    
                    BOOL willDeselect = TRUE; // allows the user to cancel deselection
                    
                    if([self.tagListDelegate respondsToSelector:shouldDeselect]){
                        // ask the user if they wish to cancel deselection
                        willDeselect = [self.tagListDelegate tagList:self shouldDeselectTagViewAtIndex:tagViewIndex];
                    }
                    
                    // if the user did not cancel deselection, set the tagView's selected state to deselected
                    if(willDeselect){
                        [self.indexesForSelectedTags removeObject: [NSNumber numberWithLong: tagViewIndex]];
                        tagView.selected = false;
                    }
                    
                    if(willDeselect && [self.tagListDelegate respondsToSelector:didDeselect]){
                        // notify user of deselection and allow them to edit the tagview
                        [self.tagListDelegate tagList:self didDeselectTagViewAtIndex:sender.tag andOfferTagViewForModifications:tagView];
                        // TODO: consider resetting the frame (layout) here
                    }else if(willDeselect){
                        [self applyDefaultTagStyleTo:tagView];
                    }
                
                
                
            } // if tagView.selected
            
        } // if self.tagListDelegate
        
    } // if self.selectable
    
}

-(void) applyDefaultTagStyleTo: (MMTagView *) tagView{
    
    // TODO: default styling for unselected items

    tagView.backgroundColor = [UIColor lightGrayColor];
    [tagView.button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}


-(void) applyDefaultSelectedTagStyleTo: (MMTagView *) tagView{
    
    // TODO: default styling for selected items
    
    tagView.backgroundColor = [UIColor darkGrayColor];
    [tagView.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
}

-(void) updateTagViewSpacingWithMargin: (MMSpacing *) margin andPadding: (MMSpacing *) padding{
    self.tagViewMargin  = margin;
    self.tagViewPadding = padding;
    [self reloadData];
}

-(void) updateTagViewMarginWithLeft: (float) left right: (float) right top: (float) top andBottom: (float) bottom{
    [self.tagViewMargin updateWithLeft:left right:right top:top andBottom:bottom];
    [self reloadData];
}

-(void) updateTagViewPaddingWithLeft: (float) left right: (float) right top: (float) top andBottom: (float) bottom{
    [self.tagViewPadding updateWithLeft:left right:right top:top andBottom:bottom];
    [self reloadData];
}


@end



