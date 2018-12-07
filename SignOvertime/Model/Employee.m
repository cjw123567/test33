//
//  Employee.m
//  SignOvertime
//
//  Created by user on 2018/8/20.
//  Copyright © 2018年 user. All rights reserved.
//

#import "Employee.h"

@implementation Employee
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end
