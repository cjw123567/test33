//
//  OvertimeConfirmViewController.h
//  OvertimeConfirm
//
//  Created by user on 2018/9/12.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"

@interface OvertimeConfirmViewController : UIViewController
{
    NSMutableArray *titleArray;
    
}
@property(nonatomic,strong) Employee *employee;

@end
