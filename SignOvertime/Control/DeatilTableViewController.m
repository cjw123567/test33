//
//  DeatilTableViewController.m
//  SignOvertime
//
//  Created by user on 2018/8/6.
//  Copyright © 2018年 user. All rights reserved.
//

#import "DeatilTableViewController.h"
#import "OverTimeTableViewController.h"
#import "ViewController.h"
#import <AFNetworking.h>
#import "Swipecardtime.h"
#import <MJExtension.h>
#import "Employee.h"
#import "Swipecardtime.h"

#import "OverTimeViewController.h"
#import "UIView+FJ.h"
#import "DeatilTableViewCell.h"
#import "LoginStatus.h"
#import <MBProgressHUD.h>
#import "OverTimeViewController.h"
#import "OvertimeConfirmViewController.h"
//#import "NSArray+decription.h"

@interface DeatilTableViewController ()

//存放模型的數組

//@property (nonatomic,strong) Employee *employee;
@property (nonatomic,strong) DeatilTableViewCell *deatilcell;
//登錄信息
@property (nonatomic,strong) LoginStatus *loginStatus;
//提示框
@property (nonatomic,strong) MBProgressHUD *mbHub;

//保存選中的indexPath
@property (nonatomic,strong) NSMutableArray *indexArray;

//選中的indexPath
@property (nonatomic,strong) NSMutableArray *selectArray;

//每行的index
@property (nonatomic,strong) NSIndexPath *index;

@end

@implementation DeatilTableViewController
//懶加載數組
- (NSMutableArray *)employeeArray{
    if (_employeeArray == nil) {
        _employeeArray = [NSMutableArray array];
    }
    
    return _employeeArray;
}
-(NSMutableArray *)selectArray{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    
    return _selectArray;
}

-(NSMutableArray *)indexArray{
    if (_indexArray == nil) {
        _indexArray = [NSMutableArray array];
    }
    
    return _indexArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // self.tableView.subviews[0].frame = CGRectMake(0, 64, self.view.width, self.view.height);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    


    
}
- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"加班人員詳情";
    

    //登出操作
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登出" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick)];
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 45)];

    //itemView.backgroundColor = [UIColor redColor];
    
    UIButton *loginoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginoutBtn.frame = CGRectMake(0, 0, 50, 45);
    [loginoutBtn setTitle:@"登出" forState:UIControlStateNormal];
    [loginoutBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [loginoutBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:loginoutBtn];
    
    UIButton *seePictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seePictureBtn.frame = CGRectMake(50, 0, 150, 45);
    [seePictureBtn setTitle:@"查看歷史簽名" forState:UIControlStateNormal];
    [seePictureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [seePictureBtn addTarget:self action:@selector(seePictureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:seePictureBtn];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:itemView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addbuttonClick)];
//self.navigationItem.leftBarButtonItems
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //[self.tableView registerNib:[UINib nibWithNibName:@"DeatilTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DeatilTableViewCell"];
    [self loaddata];
    


    

}
-(void)loaddata{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
   
    [session GET:@"http://10.64.154.240:8080/RealTime/SignOverTime/test.show" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               NSArray *modelArray = [Employee mj_objectArrayWithKeyValuesArray:responseObject];
        for (Employee *employee in modelArray) {
            [self.employeeArray addObject:employee];
            NSLog(@"%@,%@,",employee.ID,employee.name);
        }
        


        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       // NSLog(@"请求失败%@",error);
    }];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // NSLog(@"數組條數=%ld",self.employeeArray.count);
    return self.Message.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifire = @"DeatilTableViewCell";
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifire];

    
    DeatilTableViewCell *deatilcell = [tableView dequeueReusableCellWithIdentifier:identifire];
    //_deatilcell.tag = indexPath.row;
    if (!deatilcell) {
        //_deatilcell = [[[NSBundle mainBundle] loadNibNamed:@"DeatilTableViewCell" owner:nil options:nil] firstObject];
        deatilcell = [[DeatilTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifire];
            }
    Employee *employee =self.Message[indexPath.row];
    self.deatilcell = deatilcell;
        //deatilcell.nameLabel.text = employee.name;
        //deatilcell.idLabel.text = employee.ID;
       deatilcell.employee = employee;
    #warning cell可以查看簽名記錄
    
    if ([employee.status isEqualToString: @"1"]) {
        deatilcell.idlabelS.textColor = [UIColor blueColor];
        deatilcell.namelabelS.textColor = [UIColor blueColor];
        deatilcell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }


    [deatilcell.lookBtn addTarget:self action:@selector(lookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [deatilcell.resignBtn addTarget:self action:@selector(resignClick:) forControlEvents:UIControlEventTouchUpInside];
    [deatilcell.shadowViewOne addTarget:self action:@selector(shadowViewOneClick:) forControlEvents:UIControlEventTouchUpInside];


    deatilcell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return deatilcell;
}

- (void)shadowViewOneClick:(UIButton *)sender{
    
    

    //sender.tag = 12;
    NSLog(@"點擊的cell!!!===========>>");
    ViewController *Ctrl = [[ViewController alloc] init];
    Ctrl.tagCtrl = 12;
    NSIndexPath *index = [self.tableView indexPathForCell:(DeatilTableViewCell *)[sender superview]];
    //OverTimeViewController *overCtrl = [[OverTimeViewController alloc] init];
    Employee *employee =self.Message[index.row];
    Ctrl.employee = employee;
    Ctrl.confirmCodeBlock = ^(NSString *confirmCode,NSString *statusCode){
        NSLog(@"簽名后返回的狀態值===========>%@",confirmCode);
        if ([confirmCode isEqualToString:@"200"]) {
            
            DeatilTableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            employee.status = statusCode;
            NSLog(@"員工狀態值=====>%@",employee.status);
            
            cell.namelabelS.textColor = [UIColor blueColor];
            cell.idlabelS.textColor = [UIColor blueColor];
            cell.shadowViewOne.userInteractionEnabled = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell.userInteractionEnabled = NO;
        }
    };
    
    [self.navigationController pushViewController:Ctrl animated:YES];


}
- (void)lookBtnClick:(UIButton *)sender{
    NSLog(@"點擊的查看!!!===========>>");
    OvertimeConfirmViewController *overCtrl = [[OvertimeConfirmViewController alloc] init];
    
    NSIndexPath *index = [self.tableView indexPathForCell:(DeatilTableViewCell *)[sender superview]];
    //OverTimeViewController *overCtrl = [[OverTimeViewController alloc] init];
    Employee *employee =self.Message[index.row];
    overCtrl.employee = employee;
    [self.navigationController pushViewController:overCtrl animated:YES];
    
    
}
- (void)resignClick:(UIButton *)sender{
    NSLog(@"點擊的重簽!!!===========>>");
    ViewController *Ctrl = [[ViewController alloc] init];
    
    NSIndexPath *index = [self.tableView indexPathForCell:(DeatilTableViewCell *)[sender superview]];
    //OverTimeViewController *overCtrl = [[OverTimeViewController alloc] init];
    Employee *employee =self.Message[index.row];
    Ctrl.employee = employee;
    Ctrl.confirmCodeBlock = ^(NSString *confirmCode,NSString *statusCode){
        NSLog(@"簽名后返回的狀態值===========>%@",confirmCode);
        if ([confirmCode isEqualToString:@"200"]) {
            
            DeatilTableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
            employee.status = statusCode;
            NSLog(@"員工狀態值=====>%@",employee.status);
            
            cell.namelabelS.textColor = [UIColor blueColor];
            cell.idlabelS.textColor = [UIColor blueColor];
            
            //cell.userInteractionEnabled = NO;
        }
    };
    
    [self.navigationController pushViewController:Ctrl animated:YES];

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
//    ViewController *Ctrl = [[ViewController alloc] init];
//
//    //OverTimeViewController *overCtrl = [[OverTimeViewController alloc] init];
//    Employee *employee =self.Message[indexPath.row];
//    Ctrl.employee = employee;
//    Ctrl.confirmCodeBlock = ^(NSString *confirmCode,NSString *statusCode){
//        NSLog(@"簽名后返回的狀態值===========>%@",confirmCode);
//        if ([confirmCode isEqualToString:@"200"]) {
//
//            DeatilTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            employee.status = statusCode;
//            NSLog(@"員工狀態值=====>%@",employee.status);
//
//            cell.namelabelS.textColor = [UIColor blueColor];
//            cell.idlabelS.textColor = [UIColor blueColor];
//
//            cell.userInteractionEnabled = NO;
//        }
//    };
//
//    [self.navigationController pushViewController:Ctrl animated:YES];
//
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 89.5;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //
    cell.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1);
    [UIView animateWithDuration:1 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];

    //從左到右,由小變大
//    CATransform3D transfrom = CATransform3DIdentity;
//    transfrom = CATransform3DRotate(transfrom, 0, 0, 0, 1); //漸變
//    transfrom = CATransform3DTranslate(transfrom, -200, 0, 0); //左邊水平移動
//    transfrom = CATransform3DScale(transfrom, 0, 0, 0);
//
//    cell.layer.transform = transfrom;
//    cell.layer.opacity = 0.0;
//    [UIView animateWithDuration:0.6 animations:^{
//        cell.layer.transform = CATransform3DIdentity;
//        cell.layer.opacity = 1.0;
//    }];
    
    //旋轉動畫
    //CATransform3D transfrom;
   // transfrom = CATransform3DMakeRotation((), <#CGFloat x#>, <#CGFloat y#>, <#CGFloat z#>)
    
    
    
    
    
}
//登出提示
- (void)buttonClick{
    UIAlertController *loginOut = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否登出!!!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.button.userInteractionEnabled = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [loginOut addAction:cancelAction];
    [loginOut addAction:okAction];
    [self presentViewController:loginOut animated:YES completion:nil];
    
    
}

- (void)seePictureBtnClick{
    
    OverTimeViewController *overCtrl = [[OverTimeViewController alloc] init];
    //[self presentViewController:overCtrl animated:YES completion:nil];
    [self.navigationController pushViewController:overCtrl animated:YES];
    
}
- (void)addbuttonClick{
    
    //提示框添加文本输入框
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"請輸入加班員工工號"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //响应事件
        //得到文本信息
        for(UITextField *text in alert.textFields){
            
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSInteger row = self.employeeArray.count;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [indexPaths addObject: indexPath];
            //必须向tableView的数据源数组中相应的添加一条数据
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            
            session.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
            
            NSDictionary *param = @{ @"id":text.text,@"shift":self.shift};
            
            [session GET:@"http://10.64.154.240:8080/RealTime/SignOverTime/FindOneRecord.show" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                self.loginStatus = [LoginStatus mj_objectWithKeyValues:responseObject];

                NSLog(@"工號=======>%@",self.Message);
                
                
              
                for (__strong Employee *employee in self.loginStatus.Message) {
                    //Employee *employee = [[Employee alloc] init];
                    //for (Employee *employeeOne in self.Message) {
                    BOOL isExist = true;
                    //[text.text isEqualToString:self.employee.ID]
                    if(self.Message.count > 0){


                        for (int i= 0; i < self.Message.count; i++) {
                            Employee *emp = [[Employee alloc] init];
                            emp = [self.Message objectAtIndex:i];
                            if ([employee.ID isEqualToString:emp.ID]) {
                                isExist = false;

                                self.mbHub= [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                                
                                self.mbHub.label.text = NSLocalizedString(@"員工已在列表內...", @"HUD loading title");
                                self.mbHub.label.font = [UIFont systemFontOfSize:17.f];
                                
                                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                                    
                                    sleep(1.5);
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.mbHub hideAnimated:YES];
                                        
                                    });
                                    
                                });

                            }
                            
                        }


                    }
                    

                    if(isExist){
                        [self.Message insertObject:employee atIndex:0];
                       // [self.Message addObject:employee];
                        [self.tableView beginUpdates];
                        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                        [self.tableView endUpdates];

                        [self.tableView reloadData];
                        self.mbHub= [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        
                        self.mbHub.label.text = NSLocalizedString(@"員工信息已添加", @"HUD loading title");
                        self.mbHub.label.font = [UIFont systemFontOfSize:17.f];
                        
                        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                            
                            sleep(1.5);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [self.mbHub hideAnimated:YES];
                                
                            });
                            
                        });

                        NSLog(@"text = %@", text.text);
                    }
                    }
               
                if([self.loginStatus.StatusCode isEqualToString: @"500"]){
                    self.mbHub= [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    
                    self.mbHub.label.text = NSLocalizedString(@"找不到該人員加班記錄", @"HUD loading title");
                    self.mbHub.label.font = [UIFont systemFontOfSize:17.f];
                    
                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                        
                        sleep(1.5);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.mbHub hideAnimated:YES];
                            
                        });
                        
                    });

                    
                }
                NSLog(@"%@========>>",responseObject);
                
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"请求失败%@",error);
            }];

            
            
        }
    }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 //响应事件
                                                                 NSLog(@"action = %@", alert.textFields);
                                                             }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"工號...";
        }];
        
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
}
        

@end
