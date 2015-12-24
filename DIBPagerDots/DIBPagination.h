//
//  DIBPagination.h
//  Spendr
//
//  Created by Jordan Morgan on 12/2/12.
//  Copyright (c) 2013 Jordan Morgan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIBPagination : UIView

@property int maxRange;

- (id)initWithFrame:(CGRect)frame parentView:(UIView *)viewIn paginationMax:(int)max andColors:(NSArray *)colors;
- (void)animateIn;
- (void)setPageIndexToIndex:(NSUInteger)index;
- (void)removeIndexAndResize:(NSUInteger)index;
- (void)animateOut;

@end
