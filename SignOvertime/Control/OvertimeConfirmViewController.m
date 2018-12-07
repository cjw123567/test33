//
//  OvertimeConfirmViewController.m
//  OvertimeConfirm
//
//  Created by user on 2018/9/12.
//  Copyright © 2018年 user. All rights reserved.
//

#import "OvertimeConfirmViewController.h"
#import "UIView+FJ.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>

@interface OvertimeConfirmViewController ()
@property (nonatomic,strong) UIImageView *signImageView;
//提示框
@property (nonatomic,strong) MBProgressHUD *mbHub;
@end

@implementation OvertimeConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *loginoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginoutBtn.frame = CGRectMake(50, 20, 50, 50);
    loginoutBtn.layer.cornerRadius = 50 * 0.5;
    loginoutBtn.layer.masksToBounds = YES;
    loginoutBtn.backgroundColor = [UIColor redColor];
    [loginoutBtn setTitle:@"登出" forState:UIControlStateNormal];
    [loginoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginoutBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:loginoutBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick)];
    //查看簽名的imageview
    UIImageView *signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.view.width,self.view.height)];
    // signImageView.backgroundColor = [UIColor greenColor];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(addbuttonClick)];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看員工簽名" style:UIBarButtonItemStylePlain target:self action:@selector(addbuttonClick)];
    
    self.signImageView = signImageView;
    //[self loadImage];
    //    NSString*const imageURLS = [NSString stringWithFormat:@"http://10.64.154.240:8080/RealTime/SignOverTime/getPicture?id=%@&overtimedate=%@",@"133566",@"2018-09-06"];
    //    NSLog(@"請求網址=========>%@",imageURLS);
    //    self.signImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLS]]];
    
    [self.view addSubview:signImageView];
    
    [self addbuttonClick];
}
//登出提示
- (void)buttonClick{
    // [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (void)addbuttonClick{
    //提示框添加文本输入框
//    NSString *message = @"請輸入查看簽名的員工工號,日期格式為20180907";
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
//                                                                   message:message
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
//    [messageAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.f] range:NSMakeRange(18, 8)];
//    [messageAtt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(18, 8)];
//    [alert setValue:messageAtt forKey:@"attributedMessage"];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"工號...";
//    }];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"查詢日期...";
//    }];
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //响应事件
//        //得到文本信息
//        UITextField *idfield = alert.textFields.firstObject;
//        UITextField *datefeild = alert.textFields.lastObject;
//        NSString *yStr = [datefeild.text substringToIndex:4];
//        NSLog(@"年份字符===>>%@",yStr);
//        NSString *mStr = [datefeild.text substringWithRange:NSMakeRange(4, 2)];
//        NSLog(@"月份字符===>>%@",mStr);
//        NSString *dStr = [datefeild.text substringWithRange:NSMakeRange(6, 2)];
//        NSLog(@"日字符===>>%@",dStr);
//        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",yStr,mStr,dStr];
//        NSLog(@"日期=====>%@",dateStr);
    
        NSString*const imageURLS = [NSString stringWithFormat:@"http://10.64.154.240:8080/RealTime/SignOverTime/getPicture?id=%@&overtimedate=%@",self.employee.ID,self.employee.overtimeDate];
        NSData *imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLS]];
        if(imagedata.length > 0){
            
            self.signImageView.image = [UIImage imageWithData:imagedata];
        }else{
            self.mbHub= [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            self.mbHub.label.text = NSLocalizedString(@"該員工沒有簽名信息...", @"HUD loading title");
            self.mbHub.label.font = [UIFont systemFontOfSize:17.f];
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                
                sleep(1.5);
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.mbHub hideAnimated:YES];
                    
                });
                
            });
        }
        NSLog(@"請求網址=========>%@",imageURLS);
        
        //}
   // }];
    
//    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
//
//
//                                                         handler:^(UIAlertAction * action) {
//                                                             //响应事件
//                                                             NSLog(@"action = %@", alert.textFields);
//                                                         }];
//
//
//    [alert addAction:okAction];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
