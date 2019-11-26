//
//  PageBaseVCViewController.h
//  MSTestSGPagingView
//
//  Created by peng zhao on 2019/11/26.
//  Copyright © 2019 Mars. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PersonalCenterChildBaseVCDelegate <NSObject>

- (void)personalCenterChildBaseVCScrollViewDidScroll:(UIScrollView *)scrollView;

@end


@interface PageBaseVCViewController : UIViewController
@property (nonatomic, weak) id<PersonalCenterChildBaseVCDelegate> delegatePersonalCenterChildBaseVC;

@end

NS_ASSUME_NONNULL_END
