//
//  UIViewController+Extension.h
//  UnlimitedRotation
//
//  Created by ya on 1/5/17.
//  Copyright © 2017 ya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AlertType) {
    
    /**
     *  提示
     */
    AlertType_Tips,
    
    /**
     *  确定, 取消
     */
    AlertType_DetermineAndCancel,
    
    /**
     *  删除, 取消
     */
    AlertType_DeleteAndCancel,

};

@interface UIViewController (Extension)

 /// 调节`UINavigationBar`的`leftBarButtonItems`离左边的距离
@property (nonatomic, assign) CGFloat csj_leftNavigationBarItemSpace;
 /// 调节`UINavigationBar`的`rightBarButtonItems`离右边的距离
@property (nonatomic, assign) CGFloat csj_rightNavigationBarItemSpace;

- (void)alertWithTitle:(NSString *)title msg:(NSString *)msg actionTitle:(NSString *)actionTitle actionStyle:(UIAlertActionStyle)style action:(void(^)())handlerBlock;

- (void)alertWithType:(AlertType)type title:(NSString *)title msg:(NSString *)msg action:(void(^ __nullable)())handlerBlock;

- (void)alertWithType:(AlertType)type title:(NSString *)title msg:(NSString *)msg action:(void(^ __nullable)())handlerBlock cancelAction:(void(^ __nullable)())cancelBlock;

- (void)alertSheetWithTitle:(NSString * _Nullable )title msg:(NSString * _Nullable)msg actionTitles:(NSArray<NSString *> *)actionTitles actions:(NSArray<void(^)()> *)actions;

- (void)transitionHandlePanGR:(UIPanGestureRecognizer *)pan;

- (void)alertWithTitle:(NSString *)title textFieldPlaceholder:(NSString *)placeholder action:(void(^)(NSString *inputText))action;

- (void)alertWithTitle:(NSString *)title textFieldText:( NSString * _Nullable )text textFieldPlaceholder:(NSString *)placeholder action:(void(^ _Nullable)(NSString *inputText))action;

- (void)alertWithTitle:(NSString *)title textFieldText:( NSString * _Nullable )text textFieldPlaceholder:(NSString *)placeholder action:(void(^ _Nullable)(NSString *inputText))action cancelAction:(void(^ _Nullable)())cancelAction;


@end

NS_ASSUME_NONNULL_END
