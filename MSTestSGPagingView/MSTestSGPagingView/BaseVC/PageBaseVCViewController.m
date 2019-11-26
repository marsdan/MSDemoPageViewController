//
//  PageBaseVCViewController.m
//  MSTestSGPagingView
//
//  Created by peng zhao on 2019/11/26.
//  Copyright © 2019 Mars. All rights reserved.
//

#import "PageBaseVCViewController.h"

@interface PageBaseVCViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation PageBaseVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageTitleViewToTop) name:@"pageTitleViewToTop" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pageTitleViewToTop {
    _scrollView.contentOffset = CGPointZero;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!_scrollView) {
        _scrollView = scrollView;
    }
    if (self.delegatePersonalCenterChildBaseVC && [self.delegatePersonalCenterChildBaseVC respondsToSelector:@selector(personalCenterChildBaseVCScrollViewDidScroll:)]) {
        [self.delegatePersonalCenterChildBaseVC personalCenterChildBaseVCScrollViewDidScroll:scrollView];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
