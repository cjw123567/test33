//
//  DeatilTableViewController.h
//  SignOvertime
//
//  Created by user on 2018/8/6.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"

@interface DeatilTableViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *employeeArray;
@property (nonatomic,strong) Employee *employee;


/**
 人員信息數組
 */
@property (nonatomic, strong) NSMutableArray *Message;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) NSString *shift;
//簽名成功返回的狀態值
@property (nonatomic,copy) NSString *ConfirmCode;

@end
