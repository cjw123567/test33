//
//  DeatilTableViewCell.h
//  SignOvertime
//
//  Created by user on 2018/8/24.
//  Copyright © 2018年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"
@interface DeatilTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIButton *resignLabel;
@property (nonatomic,strong) Employee *employee;
@property (nonatomic, strong) UILabel *namelabelS;
@property (nonatomic, strong) UILabel *idlabelS;
@property (nonatomic,strong) UIButton *resignBtn;
@property (nonatomic,strong) UIButton *lookBtn;

@property (nonatomic,strong) UIButton *shadowViewOne;
@property (nonatomic,strong) UIView *shadowViewTwo;

@property (nonatomic,strong) UIView *shadowViewThree;

//tableview
@property (nonatomic,strong) UITableView *cellTableView;





//@property (nonatomic,strong)
@end
