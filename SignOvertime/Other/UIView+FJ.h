//
//  UIView+FJ.h
//  SignOvertime
//
//  Created by user on 2018/8/6.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FJ)
@property (nonatomic, assign)CGFloat x;
@property (nonatomic, assign)CGFloat y;
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)CGFloat centerX;
@property (nonatomic, assign)CGFloat centerY;
@property (nonatomic, assign)CGSize size;
@property(nonatomic, assign) IBInspectable CGFloat borderWidth;
@property(nonatomic, assign) IBInspectable UIColor *borderColor;
@property(nonatomic, assign) IBInspectable CGFloat cornerRadius;


/**
  *  水平居中
  */
- (void)alignHorizontal;
 /**
    22  *  垂直居中
    23  */
 - (void)alignVertical;
 /**
    26  *  判断是否显示在主窗口上面
    27  *
    28  *  @return 是否
    29  */
 - (BOOL)isShowOnWindow;

 - (UIViewController *)parentController;
@end
