//
//  LoginStatus.h
//  SignOvertime
//
//  Created by user on 2018/8/24.
//  Copyright © 2018年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginStatus : NSObject
//登錄返回信息
@property (nonatomic,copy) NSString *StatusCode;
@property (nonatomic, strong) NSMutableArray *Message;
@property (nonatomic,copy) NSString *Messages;

//@property (nonatomic,copy) NSString *UserName;
//@property (nonatomic,copy) NSString *Password;
//@property (nonatomic,copy) NSString *Role;



@end
