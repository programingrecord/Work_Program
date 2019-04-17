//
//  LCTabBarController.m
//  LCTabBarControllerDemo
//
//  Created by Leo on 15/12/2.
//  Copyright © 2015年 Leo. All rights reserved.
//

#import "LCTabBarController.h"
#import "LCTabBar.h"
#import "LCTabBarCONST.h"
#import "LCTabBarItem.h"
#import "BaseNavigationViewController.h"




@interface LCTabBarController () <LCTabBarDelegate>
{
    LCTabBar *lcTabBar;
}
//@property (nonatomic, strong) LCTabBar *lcTabBar;

@end

@implementation LCTabBarController

#pragma mark -

- (UIColor *)itemTitleColor {
    
    if (!_itemTitleColor) {
        
        _itemTitleColor = LCColorForTabBar(117, 117, 117);
    }
    return _itemTitleColor;
}

- (UIColor *)selectedItemTitleColor {
    
    if (!_selectedItemTitleColor) {
        
        _selectedItemTitleColor = [UIColor colorWithHex:0xFB6337];
    }
    return _selectedItemTitleColor;
}

- (UIFont *)itemTitleFont {
    
    if (!_itemTitleFont) {
        
        _itemTitleFont = [UIFont systemFontOfSize:10.0f];
    }
    return _itemTitleFont;
}

- (UIFont *)badgeTitleFont {
    
    if (!_badgeTitleFont) {
        _badgeTitleFont = [UIFont systemFontOfSize:11.0f];
    }
    return _badgeTitleFont;
}


#pragma mark -

- (void)loadView {
    
    [super loadView];
    
    self.itemImageRatio = 0.70f;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self.tabBar addSubview:({
        
        LCTabBar *tabBar = [[LCTabBar alloc] init];
        tabBar.frame     = self.tabBar.bounds;
        tabBar.delegate  = self;
        
        lcTabBar = tabBar;
    })];
    

}

-(void) removeTabBarButton {
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self removeOriginControls];
    [self removeTabBarButton];
}




- (void)removeOriginControls {
    
    [self.tabBar.subviews enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIControl class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [obj removeFromSuperview];
            });
        }
    }];
    
}

- (void)setViewControllers:(NSArray *)viewControllers {
    lcTabBar.badgeTitleFont         = self.badgeTitleFont;
    lcTabBar.itemTitleFont          = self.itemTitleFont;
    lcTabBar.itemImageRatio         = self.itemImageRatio;
    lcTabBar.itemTitleColor         = self.itemTitleColor;
    lcTabBar.selectedItemTitleColor = self.selectedItemTitleColor;
    lcTabBar.tabBarItemCount = viewControllers.count;

    [viewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UIViewController *VC = (UIViewController *)obj;
        
        UIImage *selectedImage = VC.tabBarItem.selectedImage;
        VC.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self addChildViewController:VC];
        
        [lcTabBar addTabBarItem:VC.tabBarItem];
    }];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    [super setSelectedIndex:selectedIndex];
    
    lcTabBar.selectedItem.selected = NO;
    lcTabBar.selectedItem = lcTabBar.tabBarItems[selectedIndex];
    lcTabBar.selectedItem.selected = YES;
}

#pragma mark - XXTabBarDelegate Method

- (void)tabBar:(LCTabBar *)tabBarView didSelectedItemFrom:(NSInteger)from to:(NSInteger)to {
    self.selectedIndex = to;
}

@end
