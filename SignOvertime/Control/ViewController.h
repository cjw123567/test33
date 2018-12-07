//
//  ViewController.h
//  SignOvertime
//
//  Created by user on 2018/8/3.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"

//代理传值
@protocol ImageDalegate <NSObject>
@optional
//代理方法
- (void)showImage:(UIImage *)image;

@end

typedef void (^ConfirmCodeBlock)(NSString *confirmCode,NSString *statusCode);
;
@interface ViewController : UIViewController
{
    NSArray *titleArray;
}
//设置代理  弱引用
@property (nonatomic,assign) id <ImageDalegate> delegate;
@property(nonatomic,strong) Employee *employee;
@property (nonatomic,strong) NSMutableArray *employeeArray;
//返回的數據
@property (nonatomic,copy) ConfirmCodeBlock confirmCodeBlock;

@property (nonatomic,assign) NSInteger indexPathSelCrtl;
@property (nonatomic,assign) NSInteger tagCtrl;

@end




