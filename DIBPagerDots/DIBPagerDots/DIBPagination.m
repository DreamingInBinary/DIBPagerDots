//
//  DIBPagination.m
//  Spendr
//
//  Created by Jordan Morgan on 12/2/12.
//  Copyright (c) 2013 Jordan Morgan. All rights reserved.
//

#import "DIBPagination.h"
#import "AppDelegate.h"

#define kSpacing 10.0f
#define kAllowablePages 15

@implementation DIBPagination{
    CGRect pRect;
    UIView *pView;
    UIColor *secondaryColor;
    UIColor *tertiaryColor;
    NSMutableArray *dots;
    NSMutableArray *dotRects;
    UILabel *lblPages;
}

- (id)initWithFrame:(CGRect)frame parentView:(UIView *)viewIn paginationMax:(int)max andColors:(NSArray *)colors
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.0f;
        pView = viewIn;
        pRect = pView.frame;
        self.maxRange = max;
        [pView addSubview:self];
        
        //Set colors, indexes aren't like most because we just send two colors
        secondaryColor = colors[0];
        tertiaryColor = colors[1];
        
        self.frame = CGRectMake(0, pRect.size.height + 15, pRect.size.width, 15);
        
        dots = [[NSMutableArray alloc] init];
        dotRects = [[NSMutableArray alloc] init];
        
        [self createPagerDots];
        [self lineOutDots];
    }
    return self;
}

#pragma mark - SETUP UI METHODS

-(void)createPagerDots{
    if (self.maxRange <= 1) {
        return;
    }else if(self.maxRange > kAllowablePages){
        lblPages = [[UILabel alloc] initWithFrame:self.frame];
        lblPages.text = [NSString stringWithFormat:@"1 of 15"];
        lblPages.font = [UIFont systemFontOfSize:2.0f];
        lblPages.textColor = tertiaryColor;
        lblPages.textAlignment = NSTextAlignmentCenter;
        lblPages.adjustsFontSizeToFitWidth = YES;
        [self addSubview:lblPages];
        return;
    }
    
    //normal paging scenario
    for (int counter = 0; counter < self.maxRange; counter++) {
        CALayer *dot = [CALayer layer];
        dot.frame = CGRectMake((self.frame.size.width/2) - 3, (self.frame.size.height/2) - 3, 6, 6);
        dot.backgroundColor = [secondaryColor CGColor];
        dot.cornerRadius = 3.0f;
        [dot setBorderColor:[tertiaryColor CGColor]];
        [dot setBorderWidth:0.5f];
        [dot setMasksToBounds:YES];
        [dots addObject:dot];
        [self.layer addSublayer:[dots lastObject]];
    }
    
}

//Must call after createPagerDots, or dots will be nil
-(void)lineOutDots{
    if(self.maxRange > kAllowablePages){
        return;
    }
    
    CGRect lastRect;
    
    //Only called if there is more than one dot
    for(int counter = 0; counter < dots.count; counter++){
        //First dot
        if(counter < 1){
            lastRect = [(CALayer *)[dots objectAtIndex:counter] frame];
            [(CALayer *)[dots objectAtIndex:counter] setFrame:CGRectMake(lastRect.origin.x - kSpacing, lastRect.origin.y, lastRect.size.width, lastRect.size.height)];
        }else if (counter == 1){
            lastRect = [(CALayer *)[dots objectAtIndex:counter -1] frame];
            [(CALayer *)[dots objectAtIndex:counter] setFrame:CGRectMake(lastRect.origin.x + (kSpacing * 2), lastRect.origin.y, lastRect.size.width, lastRect.size.height)];
        }else{
            //Nudge them all back
            for (int count = 0; count < counter; count++) {
                lastRect = [(CALayer *)[dots objectAtIndex:count] frame];
                [(CALayer *)[dots objectAtIndex:count] setFrame:CGRectMake(lastRect.origin.x - kSpacing, lastRect.origin.y, lastRect.size.width, lastRect.size.height)];
            }
            
            lastRect = [(CALayer *)[dots objectAtIndex:counter - 1] frame];
            [(CALayer *)[dots objectAtIndex:counter] setFrame:CGRectMake(lastRect.origin.x + (kSpacing * 2), lastRect.origin.y, lastRect.size.width, lastRect.size.height)];
        }
        
        
    }
    
    //Clear it out if we are resizing
    if (dotRects.count != 0) {
        dotRects = nil;
        dotRects = [[NSMutableArray alloc] init];
    }
    
    //For the love of all that is good and decent fix this
    //This fils out the dotRects array
    //Also, C++ HAHA!
    for (int c = 0; c < dots.count; c++) {
        [dotRects addObject:[NSValue valueWithCGRect:[(CALayer *)[dots objectAtIndex:c] frame]]];
        //Recent them to fly out
        [(CALayer *)[dots objectAtIndex:c] setFrame:CGRectMake((self.frame.size.width/2) - 3, (self.frame.size.height/2) - 3, 6, 6)];
    }
    
    //If one pager set it right in the middle
    if (dots.count == 1 && dotRects.count == 1) {
        [dotRects replaceObjectAtIndex:0 withObject:[NSValue valueWithCGRect:CGRectMake((self.frame.size.width/2) - 3, (self.frame.size.height/2) - 3, 6, 6)]];
    }

}

#pragma mark - Utils
//Animates the whole pager, used typically in setup and called outside the class
-(void)animateIn{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1.0f;
        self.frame = CGRectMake(0, pRect.size.height - 15, pRect.size.width, 15);
    }completion:^(BOOL finished){
        [self animatePagerDots];
    }];
}

- (void)animateOut{
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0f;
    }completion:nil];
}

//Spreads the dots out
-(void)animatePagerDots{
    for(int counter = 0; counter < dotRects.count; counter++){
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect rect = [[dotRects objectAtIndex:counter] CGRectValue];
            [(CALayer *)[dots objectAtIndex:counter] setFrame:rect];
            
            if(counter > 0){
                [(CALayer *)[dots objectAtIndex:counter] setOpacity:0.50f];
            }
        }completion:nil];
    }
}

- (void)setPageIndexToIndex:(NSUInteger)index{
    //Bring opacity down
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25f];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    for (CALayer *layers in dots) {
        layers.opacity = 0.50f;
        layers.frame = CGRectMake(layers.frame.origin.x, layers.frame.origin.y, 4, 4);
    }
    [CATransaction commit];
    
    CALayer *curDot = (CALayer *)[dots objectAtIndex:index];
    curDot.opacity = 1.0f;
    curDot.frame = CGRectMake(curDot.frame.origin.x, curDot.frame.origin.y, 6, 6);
                       
}

-(void)removeIndexAndResize:(NSUInteger)index{
    //Remove from view and datasource
    [[dots objectAtIndex:index] removeFromSuperlayer];
    [dots removeObjectAtIndex:index];
    
    for (CALayer *layers in dots) {
        layers.frame = CGRectMake((self.frame.size.width/2) - 3, (self.frame.size.height/2) - 3, 6, 6);
    }
    
    [self lineOutDots];
    [self animatePagerDots];
}
@end
