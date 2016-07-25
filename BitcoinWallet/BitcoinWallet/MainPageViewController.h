//
//  MainPageViewController.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/23/16.
//
//

#ifndef MainPageViewController_h
#define MainPageViewController_h
#import <UIKit/UIKit.h>
#import "BalanceViewController.h"
#import "MenuViewController.h"

@interface MainPageViewController : UIPageViewController<UIPageViewControllerDataSource>

@property (strong,nonatomic) UIPageViewController *pageController;

@end

#endif /* MainPageViewController_h */
