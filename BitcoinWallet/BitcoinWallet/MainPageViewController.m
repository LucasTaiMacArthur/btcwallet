//
//  MainPageViewController.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/23/16.
//
//

#import <Foundation/Foundation.h>
#import "MainPageViewController.h"

@implementation MainPageViewController


static NSArray* vcArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // allocate the two view controllers
    id page1 = [[[BalanceViewController alloc]init] retain];
    id page2 = [[[MenuViewController alloc]init] retain];
    vcArray = [[NSArray alloc]initWithObjects:page1,page2,nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewDidAppear:(BOOL)animated {
    _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self presentViewController:_pageController animated:NO completion:^{
        //
    }];
    
    _pageController.dataSource = self;
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [vcArray indexOfObject:viewController];
    if(index == 1){
        return nil;
    }
    
    
    return [vcArray objectAtIndex:1];
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [vcArray indexOfObject:viewController];
    if(index == 0){
        return nil;
    }
    
    return [vcArray objectAtIndex:0];
}

@end
