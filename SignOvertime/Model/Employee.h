//
//  Employee.h
//  SignOvertime
//
//  Created by user on 2018/8/20.
//  Copyright © 2018年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject
////工號
//@property (nonatomic,copy) NSString *ID;
////姓名
//@property (nonatomic,copy) NSString *NAME;
////部門代碼
//@property (nonatomic,copy) NSString *DEPID;
////部門名稱
//@property (nonatomic,copy) NSString *DEPNAME;
////直接間接
//@property (nonatomic,copy) NSString *DIRECT;
////直接間接
//@property (nonatomic,copy) NSString *EmpName;

//工號
@property (nonatomic,copy) NSString *ID;
//姓名
@property (nonatomic,copy) NSString *name;
//部門代碼
@property (nonatomic,copy) NSString *depid;
//班別
@property (nonatomic,copy) NSString *class_no;
//加班日期
@property (nonatomic,copy) NSString *overtimeDate;

//是否簽名  0是沒簽  1是簽名
@property (nonatomic,copy) NSString *status;

//
////部門名稱
//@property (nonatomic,copy) NSString *DEPNAME;
////直接間接
//@property (nonatomic,copy) NSString *DIRECT;
////直接間接
//@property (nonatomic,copy) NSString *EmpName;
////直接間接
//@property (nonatomic,copy) NSString *EmpNo;


@end
