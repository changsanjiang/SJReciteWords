//
//  SJTabBarController.m
//  ReciteWords
//
//  Created by BlueDancer on 2017/7/31.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJTabBarController.h"
#import "SJReciteWordsViewController.h"
#import "SJBaseNavigationController.h"
#import "SJSearchWordsViewController.h"
#import "UIImage+Extension.h"

@interface SJTabBarController ()

@end

@implementation SJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray<UIViewController *> *viewControllersM = [NSMutableArray new];
    viewControllersM[0] = [self controllerWithTitle:@"背单词"
                                       imageNameStr:@"sj_item_recite_word_n"
                                          className:NSStringFromClass([SJReciteWordsViewController class])];
    self.viewControllers = viewControllersM.copy;
    // Do any additional setup after loading the view.
}

- (UIViewController *)controllerWithTitle:(NSString *)title imageNameStr:(NSString *)imageNameStr className:(NSString *)name {
    Class cls = NSClassFromString(name);
    if ( nil == cls ) { NSLog(@"%s-%s-%@: 类名写错!", __FILE__, __func__, name); return nil; }
    UIViewController *vc = [cls new];
    vc.title = title;
    vc.tabBarItem.image = [UIImage csj_originImage:imageNameStr];
    vc.tabBarItem.selectedImage = [UIImage csj_originImage:[NSString stringWithFormat:@"%@h", [imageNameStr substringToIndex:imageNameStr.length - 1]]];
    SJBaseNavigationController *nav = [[SJBaseNavigationController alloc] initWithRootViewController:vc];
    return nav;
}

@end
