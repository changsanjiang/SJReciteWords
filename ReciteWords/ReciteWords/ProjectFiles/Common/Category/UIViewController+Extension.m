//
//  UIViewController+Extension.m
//  UnlimitedRotation
//
//  Created by ya on 1/5/17.
//  Copyright © 2017 ya. All rights reserved.
//

#import "UIViewController+Extension.h"
#import <objc/message.h>

@implementation UIViewController (Extension)

static const char *leftSpaceKey  = "leftSpaceKey";
static const char *rightSpaceKey = "rightSpaceKey";
- (void)setCsj_leftNavigationBarItemSpace:(CGFloat)csj_leftNavigationBarItemSpace {

    if (self.navigationItem.leftBarButtonItems.count == 0) {
        return;
    }

    UIBarButtonItem *fixedBarButtonItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil
                                           action:nil];

    fixedBarButtonItem.width = csj_leftNavigationBarItemSpace;

    NSMutableArray<UIBarButtonItem *> *leftItems = self.navigationItem.
    leftBarButtonItems.mutableCopy;

    if ([self csj_leftNavigationBarItemSpace] != 0) {
        [leftItems removeObjectAtIndex:0];
    }

    [leftItems insertObject:fixedBarButtonItem atIndex:0];
    self.navigationItem.leftBarButtonItems = leftItems;


    objc_setAssociatedObject(self,
                             leftSpaceKey,
                             @(csj_leftNavigationBarItemSpace),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)csj_leftNavigationBarItemSpace {
    return [objc_getAssociatedObject(self, leftSpaceKey) floatValue];
}

- (void)setCsj_rightNavigationBarItemSpace:(CGFloat)csj_rightNavigationBarItemSpace {

    if (self.navigationItem.rightBarButtonItems.count == 0) {
        return;
    }

    UIBarButtonItem *fixedBarButtonItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil
                                           action:nil];

    fixedBarButtonItem.width = csj_rightNavigationBarItemSpace;
    NSMutableArray<UIBarButtonItem *> *rightItems = self.navigationItem.leftBarButtonItems.mutableCopy;


    if ([self csj_rightNavigationBarItemSpace] != 0) {
        [rightItems removeObjectAtIndex:0];
    }


    [rightItems insertObject:fixedBarButtonItem atIndex:0];
    self.navigationItem.rightBarButtonItems = rightItems;

    objc_setAssociatedObject(self,
                             rightSpaceKey,
                             @(csj_rightNavigationBarItemSpace),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)csj_rightNavigationBarItemSpace {
    return [objc_getAssociatedObject(self, rightSpaceKey) floatValue];
}

- (void)alertWithType:(AlertType)type title:(NSString *)title msg:(NSString *)msg action:(void(^)())handlerBlock {
    [self alertWithType:type title:title msg:msg action:handlerBlock cancelAction:nil];
}

- (void)alertWithTitle:(NSString *)title msg:(NSString *)msg actionTitle:(NSString *)actionTitle actionStyle:(UIAlertActionStyle)style action:(void(^)())handlerBlock {
    [self alertWithTitle:title msg:msg cancelAction:YES actionTitle:actionTitle actionStyle:style action:handlerBlock cancelAction:nil];
}


- (void)alertWithType:(AlertType)type title:(NSString *)title msg:(NSString *)msg action:(void(^)())handlerBlock cancelAction:(void(^)())cancelBlock {
    
    NSString *actionTitle = nil;
    UIAlertActionStyle style = 0;
    
    BOOL cancelActionBool = YES;
    switch ( type ) {
        case AlertType_Tips:
            actionTitle = @"确定";
            cancelActionBool = NO;
            break;
        case AlertType_DetermineAndCancel:
            actionTitle = @"确定";
            break;
        case AlertType_DeleteAndCancel:
            actionTitle = @"删除";
            style = UIAlertActionStyleDestructive;
        default:
            break;
    }

    [self alertWithTitle:title msg:msg cancelAction:cancelActionBool actionTitle:actionTitle actionStyle:style action:handlerBlock cancelAction:cancelBlock];
}

- (void)alertWithTitle:(NSString *)title msg:(NSString *)msg cancelAction:(BOOL)cancelActionBool actionTitle:(NSString *)actionTitle actionStyle:(UIAlertActionStyle)style action:(void(^)())handlerBlock cancelAction:(void(^)())cancelBlock {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action =
    [UIAlertAction actionWithTitle:actionTitle style:style handler:^(UIAlertAction * _Nonnull action) {
        
        if ( handlerBlock ) {
            handlerBlock();
        }
    }];
    
    [alertController addAction:action];
    
    
    if ( cancelActionBool ) {
        /// 取消
        UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if ( cancelBlock ) {
                cancelBlock();
            }
        }];
        
        [alertController addAction:cancelAction];

    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
    
}

- (void)alertSheetWithTitle:title msg:(NSString *)msg actionTitles:(NSArray<NSString *> *)actionTitles actions:(NSArray<void(^)()> *)actions {
    
    if ( actionTitles.count != actions.count ) {
        NSLog(@"动作与title数量不一致");
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:actions[idx]];
        [alertController addAction:action];
    }];
    
    /// 取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    [alertController addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });

}

- (void)transitionHandlePanGR:(UIPanGestureRecognizer *)panGR {
    // 获取移动的偏移
    CGPoint offset = [panGR translationInView:panGR.view];
    
    // 根据距离换算角度
    if ( 0 == panGR.view.bounds.size.width ) return;
    CGFloat angle = offset.x * 0.5 / panGR.view.bounds.size.width * M_PI_2;
    
    // 判断手势的阶段
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:
            
            // 修改旋转点
            panGR.view.layer.anchorPoint = CGPointMake(0.5, 1.5);
            panGR.view.layer.position = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5,[UIScreen mainScreen].bounds.size.height * 1.5);
            
            break;
        case UIGestureRecognizerStateChanged:
            
            // View转动:注意点:因为要判断旋转的角度: 所以make
            panGR.view.transform = CGAffineTransformMakeRotation(angle);
            
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
            
            if(ABS(angle) > 0.25){
                // 销毁控制器
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    panGR.view.transform = CGAffineTransformMakeRotation(M_PI);
                    
                } completion:^(BOOL finished) {
                    
                    [self dismissViewControllerAnimated:NO completion:nil];
                }];
                
            }
            else{
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    panGR.view.transform = CGAffineTransformIdentity;
                    
                } completion:^(BOOL finished) {
                    // 修改完了就改回来
                    panGR.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
                    panGR.view.layer.position = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5,[UIScreen mainScreen].bounds.size.height *0.5);
                }];
            }
            break;
            
        default:
            break;
    }
}

- (void)alertWithTitle:(NSString *)title textFieldPlaceholder:(NSString *)placeholder action:(void(^)(NSString *inputText))actionBlock {
    [self alertWithTitle:title textFieldText:nil textFieldPlaceholder:placeholder action:actionBlock];
}

- (void)alertWithTitle:(NSString *)title textFieldText:(NSString *)text textFieldPlaceholder:(NSString *)placeholder action:(void(^)(NSString *inputText))actionBlock {
    [self alertWithTitle:title textFieldText:text textFieldPlaceholder:placeholder action:actionBlock cancelAction:nil];
}

- (void)alertWithTitle:(NSString *)title textFieldText:( NSString * _Nullable )text textFieldPlaceholder:(NSString *)   placeholder action:(void(^)(NSString *inputText))actionBlock cancelAction:(void(^)())cancelActionBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
        textField.text = text;
    }];
    __weak typeof(alertController) _alertController = alertController;
    UIAlertAction *okActions =
    [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(_alertController) alertController = _alertController;
        if ( !alertController ) return;
        UITextField *textField = alertController.textFields[0];
        if ( actionBlock ) actionBlock(textField.text);
    }];
    [alertController addAction:okActions];
    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ( cancelActionBlock ) cancelActionBlock();
    }];
    [alertController addAction:cancelAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

@end
