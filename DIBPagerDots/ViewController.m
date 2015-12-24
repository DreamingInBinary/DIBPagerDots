//
//  ViewController.m
//  DIBPagerDots
//
//  Created by Jordan Morgan on 12/24/15.
//  Copyright © 2015 Dreaming In BInary LLC. All rights reserved.
//

#import "ViewController.h"
#import "DIBPagination.h"

@interface ViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) DIBPagination *pager;
@end

@implementation ViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupScrollview];
    
    //First, add the pager
    self.pager = [[DIBPagination alloc] initWithFrame:self.view.bounds parentView:self.view paginationMax:8 andColors:@[[UIColor blueColor], [UIColor purpleColor]]];
    
    //Animate in - i.e. when you display the scrollview and it's content has been set
    [self.pager animateIn];
}

#pragma mark - Add this code to your Scrollview Delegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        [self.pager setPageIndexToIndex:page];
        previousPage = page;
    }
}

#pragma mark - Unrelated code to DIBPagerDots
- (void)setupScrollview
{
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    sv.delegate = self;
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:sv];
    
    CGFloat viewX = self.view.bounds.size.width/2 - 150;
    for (NSUInteger i = 0; i < 8; i++)
    {
        UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(viewX, self.view.bounds.size.height/2 - 150, 300, 300)];
        vw.backgroundColor = [UIColor blueColor];
        [sv addSubview:vw];
        viewX += self.view.bounds.size.width;
    }
    
    sv.contentSize = CGSizeMake(2400, self.view.bounds.size.height);
}
@end
