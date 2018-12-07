//
//  OverTimeViewController.h
//  SignOvertime
//
//  Created by user on 2018/8/22.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"
@interface OverTimeViewController : UIViewController
{
    NSMutableArray *titleArray;
    
}
@property(nonatomic,strong) Employee *employee;

@end
