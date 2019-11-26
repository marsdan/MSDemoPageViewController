//
//  ViewController.m
//  MSTestSGPagingView
//
//  Created by peng zhao on 2019/11/26.
//  Copyright © 2019 Mars. All rights reserved.
//

#import "ViewController.h"
#import <SGPagingView/SGPagingView.h>
#import "MSTestTableView.h"
#import "PageBaseVCViewController.h"

#import "MSListViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,PersonalCenterChildBaseVCDelegate,SGPageContentScrollViewDelegate,SGPageTitleViewDelegate>
{
    CGFloat PersonalCenterVCPageTitleViewHeight;
    CGFloat PersonalCenterVCNavHeight;
    CGFloat PersonalCenterVCTopViewHeight;
}
@property (nonatomic, strong) MSTestTableView *tableView;
@property (nonatomic, strong) UIView *headerView;
//菜单
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, copy) NSArray<NSString *> *titles;
@property (nonatomic, strong) UIView *getPageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentView;

@property (nonatomic, strong) UIScrollView *childVCScrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PersonalCenterVCPageTitleViewHeight = 44;
    PersonalCenterVCNavHeight = 60;
    PersonalCenterVCTopViewHeight = 300;
    _titles = [NSMutableArray arrayWithArray:@[@"标题一",@"标题二"]];
    
    [self foundTableView];
}

- (void)foundTableView {
    CGFloat tableViewX = 0;
    CGFloat tableViewY = PersonalCenterVCNavHeight;
    CGFloat tableViewW = self.view.frame.size.width;
    CGFloat tableViewH = self.view.frame.size.height;
    self.tableView = [[MSTestTableView alloc] initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.backgroundColor = [UIColor redColor];
    _tableView.tableHeaderView = self.headerView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.sectionHeaderHeight = PersonalCenterVCPageTitleViewHeight;
    _tableView.rowHeight = self.view.frame.size.height - PersonalCenterVCPageTitleViewHeight;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.view addSubview:_tableView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.childVCScrollView && _childVCScrollView.contentOffset.y > 0) {
        self.tableView.contentOffset = CGPointMake(0, PersonalCenterVCTopViewHeight);
    }
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY < PersonalCenterVCTopViewHeight) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pageTitleViewToTop" object:nil];
    }
}

- (void)personalCenterChildBaseVCScrollViewDidScroll:(UIScrollView *)scrollView {
    self.childVCScrollView = scrollView;
    if (self.tableView.contentOffset.y < PersonalCenterVCTopViewHeight) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    } else {
        self.tableView.contentOffset = CGPointMake(0, PersonalCenterVCTopViewHeight);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
     cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:self.pageContentView];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.getPageTitleView;
}

#pragma mark - - - SGPageTitleViewDelegate - SGPageContentViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex{
    [self.pageContentView setPageContentScrollViewCurrentIndex:selectedIndex];
}
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}


- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView index:(NSInteger)index{
    
}


- (UIView *)getPageTitleView{
    if (!_getPageTitleView) {
        _getPageTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PersonalCenterVCPageTitleViewHeight)];
        [_getPageTitleView addSubview:self.pageTitleView];
    }
    return _getPageTitleView;
}

- (SGPageContentScrollView *)pageContentView {
    if (!_pageContentView) {
        MSListViewController *oneVC = [[MSListViewController alloc] init];
        oneVC.delegatePersonalCenterChildBaseVC = self;
        oneVC.view.backgroundColor = [UIColor magentaColor];
        
        MSListViewController *twoVC = [[MSListViewController alloc] init];
        twoVC.delegatePersonalCenterChildBaseVC = self;
        twoVC.view.backgroundColor = [UIColor linkColor];
        
        NSArray *childArr = @[oneVC, twoVC];
        /// pageContentView
        CGFloat contentViewHeight = self.view.frame.size.height - PersonalCenterVCNavHeight - PersonalCenterVCPageTitleViewHeight-8;
        _pageContentView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(8, 0, self.view.frame.size.width-16, contentViewHeight) parentVC:self childVCs:childArr];
        _pageContentView.delegatePageContentScrollView = self;
        _pageContentView.backgroundColor = [UIColor whiteColor];
//        _pageContentView.isScrollEnabled = YES;
        
        _pageContentView.layer.mask = nil;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _pageContentView.bounds.size.width,  _pageContentView.bounds.size.height) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0,_pageContentView.bounds.size.width, _pageContentView.bounds.size.height);
        maskLayer.path = maskPath.CGPath;
        _pageContentView.layer.mask = maskLayer;
        
    }
    return _pageContentView;
}

- (SGPageTitleView *)pageTitleView {
    if (!_pageTitleView) {
        SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
        configure.indicatorAdditionalWidth = 90;
        configure.bottomSeparatorColor = [UIColor clearColor];
        configure.titleColor = [UIColor lightGrayColor];
        configure.titleSelectedColor = [UIColor orangeColor];
        configure.indicatorColor = [UIColor orangeColor];
        /// pageTitleView
        _pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(8, 0, self.view.frame.size.width-16, PersonalCenterVCPageTitleViewHeight) delegate:self titleNames:_titles configure:configure];
        _pageTitleView.backgroundColor = [UIColor whiteColor];
        
        _pageTitleView.layer.mask = nil;
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _pageTitleView.width,  _pageTitleView.height) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = CGRectMake(0, 0,_pageTitleView.width, _pageTitleView.height);
//        maskLayer.path = maskPath.CGPath;
//        _pageTitleView.layer.mask = maskLayer;
        
    }
    return _pageTitleView;
}


-(UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PersonalCenterVCTopViewHeight)];
        _headerView.backgroundColor = [UIColor orangeColor];
    }
    return _headerView;
}

@end
