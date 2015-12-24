# DIBPagerDots
Add animated pagination easily to any `UIScrollView`.

![Demo](/demo.gif?raw=true "Demo")

No auto layout or frame manipulation required.

####Installation

**Cocoapods**:

    pod 'DIBPagerDots'
    
**Old Way:**

Drag one source file into your project:
- DIBPagination.h and .m

####Using It

**1:** Import `DIBPagination.h`:

    #import 'DIBPagination.h'
    
**2:** Add a property for a pager instance:

    @property(strong, nonatomic) DIBPagination *pager;
    
**3:** Initialize it whenever you'd like. Call `animateIn` to show it:

    //First, add the pager
    self.pager = [[DIBPagination alloc] initWithFrame:self.view.bounds parentView:self.view paginationMax:8 andColors:@[[UIColor blueColor], [UIColor purpleColor]]];
    
    //Animate in - i.e. when you display the scrollview and it's content has been set
    [self.pager animateIn];
    
    //When you are done
    [self.pager animateOut];
    
    //You can also dynamically remove indices
    [self.pager removeIndexAndResize:1];

**4:** On your `UIScrollView`, you'll need to change a few properties like so:

    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO; //Optional, looks better without it

**5:** Lastly, add this code to your implementation of `scrollViewDidEndDecelerating:`

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
    
####A Bit More
This is part of some old code I am open sourcing for fun since the projects they are used in are about to be deleted or 
entirely refactored. This particular code was some of the first iOS code I ever wrote several years ago. That said,
it's very scattered and not very structured, so feel free to hack away at it as you see fit.

This was originially built for my first iOS app, [Spend Stack](https://itunes.apple.com/us/app/spend-stack/id825371644?mt=8), which reached #18 in paid apps under Finance when it released.

###Can I tweet at you?
Please do, [@jordanmorgan10](https://twitter.com/jordanmorgan10). As the mantra goes - pull requests welcome (it needs a lot of love).
