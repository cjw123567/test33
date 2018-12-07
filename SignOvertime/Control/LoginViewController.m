//
//  LoginViewController.m
//  SignOvertime
//
//  Created by user on 2018/8/23.
//  Copyright © 2018年 user. All rights reserved.
//

#import "LoginViewController.h"
#import "UIView+FJ.h"
#import "ViewController.h"
#import "DeatilTableViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "LoginStatus.h"
#import <MBProgressHUD.h>
#import "Employee.h"
#import "ZZZKeyChainHelper.h"
#import "DeatilTableViewCell.h"

@interface LoginViewController ()<UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
//賬號filed
@property (nonatomic,strong) UITextField *userFiled;
//密碼filed
@property (nonatomic,strong) UITextField *passwordFiled;
//登錄信息
@property (nonatomic,strong) LoginStatus *loginStatus;
//提示框
@property (nonatomic,strong) MBProgressHUD *mbHub;
@property (weak, nonatomic)  UISwitch *rmbPwdSwitch;
@property (weak, nonatomic)  UISwitch *autoLoginSwitch;
@property (nonatomic,strong) DeatilTableViewController *deatilCtrl;
@property (nonatomic,strong) UILabel *DnLabel;
//登錄butto
@property (strong,nonatomic) UIButton * button ;
//登錄view
@property (nonatomic,strong) UIView *loginView;

//pickerview數組
@property (nonatomic,strong) NSArray *teams;

//選擇白夜班
@property (nonatomic,strong) UIPickerView *DnPickerView;
@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.delegate = self;
    //self.view.backgroundColor = [UIColor grayColor];
    
   

    //強制橫屏
//    SEL selector = NSSelectorFromString(@"setOrientation:");
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//    [invocation setSelector:selector];
//    [invocation setTarget:[UIDevice currentDevice]];
//    int val = UIInterfaceOrientationLandscapeLeft;
//    [invocation setArgument:&val atIndex:2];//前两个参数已被target和selector占用
//    [invocation invoke];

    //設置登錄框
    [self setLoginView];
    
    
    //http://10.64.154.240:8080/RealTime/SignOverTime/test.show
}

- (void)setLoginView{
    
    
    CGFloat width= 300;
    CGFloat height = 170;
    CGFloat x = self.view.centerX - width * 0.5;
    CGFloat y = self.view.centerY - height * 0.5 ;
    
//    //挑選白夜班
//    UIView *classView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width-170 , 45, 130, 45)];
//   // classView.backgroundColor = [UIColor redColor];
//    classView.layer.masksToBounds = YES;
//    classView.layer.borderWidth = 1;
//    classView.layer.borderColor = [UIColor blackColor].CGColor;
//    [self.view addSubview:classView];
//    //白班
//    UIButton *dayClassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    dayClassBtn.layer.masksToBounds = YES;
//    dayClassBtn.layer.borderWidth = 1;
//    dayClassBtn.layer.borderColor = [UIColor blackColor].CGColor;
//    dayClassBtn.frame = CGRectMake(0, 0, 65, 45);
//    [dayClassBtn setTitle:@"D" forState:UIControlStateNormal];
//    [dayClassBtn setBackgroundColor:[UIColor whiteColor]];
//    [dayClassBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [classView addSubview:dayClassBtn];
//    //夜班
//    UIButton *nightClassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    nightClassBtn.layer.masksToBounds = YES;
//    nightClassBtn.layer.borderWidth = 1;
//    nightClassBtn.layer.borderColor = [UIColor blackColor].CGColor;
//    nightClassBtn.frame = CGRectMake(65, 0, 65, 45);
//    [nightClassBtn setTitle:@"N" forState:UIControlStateNormal];
//    [nightClassBtn setBackgroundColor:[UIColor blackColor]];
//    [nightClassBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [classView addSubview:nightClassBtn];
    self.loginView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    //self.loginView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.loginView];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSString *userName = [userDefault objectForKey:@"userName"];
                NSString *password = [userDefault objectForKey:@"password"];
    
                self.userFiled.text = userName;
                self.passwordFiled.text = password;

    //賬號label
    UILabel *userLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 35)];
    userLable.text = @"賬號:";
    userLable.textAlignment = NSTextAlignmentCenter;
    //userLable.backgroundColor = [UIColor blackColor];
    userLable.textColor = [UIColor blackColor];
    [self.loginView addSubview:userLable];
    
    
    //賬號textfiled
    self.userFiled = [[UITextField alloc] initWithFrame:CGRectMake(userLable.width, 0, self.loginView.width-userLable.width, 35)];
    self.userFiled.text = @"129548";
    self.userFiled.layer.borderColor = [UIColor grayColor].CGColor;
    self.userFiled.layer.borderWidth = 1.0f;
    self.userFiled.placeholder = @"輸入賬號...";
    [self.loginView addSubview:self.userFiled];
    
    //密碼label
    UILabel *passwordLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 75, 35)];
    //passwordLable.backgroundColor = [UIColor greenColor];
    passwordLable.text = @"密碼:";
    passwordLable.textAlignment = NSTextAlignmentCenter;
     //passwordLable.backgroundColor = [UIColor greenColor];
    passwordLable.textColor = [UIColor blackColor];
    [self.loginView addSubview:passwordLable];
    
    //密碼textfiled
    self.passwordFiled = [[UITextField alloc] initWithFrame:CGRectMake(userLable.width, 65, self.loginView.width-userLable.width, 35)];
    self.passwordFiled.text = @"123456";
    self.passwordFiled.secureTextEntry = YES;
    self.passwordFiled.layer.borderColor = [UIColor grayColor].CGColor;
    self.passwordFiled.layer.borderWidth = 1.0f;
    self.passwordFiled.placeholder = @"輸入密碼...";
    [self.loginView addSubview:self.passwordFiled];
    
    UIButton *DnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    DnBtn.frame = CGRectMake(0, 120, 200, 35);
    [DnBtn setTitle:@"挑選班別" forState:UIControlStateNormal];
    [DnBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [DnBtn addTarget:self action:@selector(selClassBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView addSubview:DnBtn];
//    //挑選之後
    self.DnLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 120, 75, 35)];
    self.DnLabel.backgroundColor= [UIColor grayColor];
    self.DnLabel.text = @"D";
    self.DnLabel.textAlignment = NSTextAlignmentCenter;
    //passwordLable.backgroundColor = [UIColor greenColor];
    self.DnLabel.textColor = [UIColor blackColor];
    [self.loginView addSubview:self.DnLabel];
    //image
    UIImageView *loginImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"foxlinkLogin.png"]];
    loginImageView.backgroundColor = [UIColor purpleColor];
    CGFloat imagex = self.view.centerX - 500 * 0.5;

    loginImageView.frame = CGRectMake(imagex, 100, 500, 100);
    [self.view addSubview:loginImageView];
    //加班簽核系統
    UILabel *signLabel = [[UILabel alloc] initWithFrame:CGRectMake(loginImageView.x, loginImageView.y+loginImageView.height +20, loginImageView.width, 75)];
    signLabel.text = @"加班確認系統";
    //signLabel.backgroundColor = [UIColor redColor];
    //signLabel.font = [UIFont systemFontOfSize:25.f];
    [signLabel setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:33.f]];
    signLabel.textColor = [UIColor blackColor];
    signLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:signLabel];
    
    //
    //登錄button
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.layer.cornerRadius = 20;
    self.button.layer.masksToBounds = YES;
    [self.button setTitle:@"登錄" forState:UIControlStateNormal];
    self.button.backgroundColor=[UIColor blueColor];
    self.button.frame=CGRectMake(self.loginView.x+30, self.loginView.y +50 + self.loginView.height, self.loginView.width-30, 40);
    [self.button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];



}

- (void)DnBtnClick{
    
    //選擇白夜班
    self.DnPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(self.loginView.x, self.loginView.y+self.loginView.height, 300, 45)];
    self.DnPickerView.backgroundColor = [UIColor whiteColor];
    
    //    DnPickerView.layer.masksToBounds = YES;
    //    DnPickerView.layer.borderWidth = 1;
    //    DnPickerView.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    self.teams = [NSArray arrayWithObjects:@"白班", @"夜班",nil];
    self.DnPickerView.delegate = self;
    self.DnPickerView.dataSource = self;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.DnPickerView];
   

    
}
- (void)selClassBtnClick{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"選擇班別" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"白班" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        //NSLog(@"点击取消");
        self.DnLabel.text = @"D";
    }]];
    
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"夜班" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.DnLabel.text = @"N";
        //NSLog(@"点击确认");
        
    }]];
    
    
    // 由于它是一个控制器 直接modal出来就好了
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)setloaddata{
    //http://m.weather.com.cn/data/101010100.html
    //http://10.64.154.240:8080/RealTime/SignOverTime/test.show
    //@"http://10.64.154.235/Signovertime/login.php"
    //[ZZZKeyChainHelper addAccountInfoToKeyChainWithAccountIdentifier:self.userFiled.text accountPassword:self.passwordFiled.text];
    if([self.userFiled.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"請輸入賬號"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
       
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;

            }
    if([self.passwordFiled.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"請輸入密碼"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];

        return;
    }
      self.button.userInteractionEnabled = NO;


    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
  
    session.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
   //manager.requestSerializer.timeoutInterval = 20;
    NSDictionary *param = @{ @"username":self.userFiled.text, @"password":self.passwordFiled.text,@"shift":self.DnLabel.text };
    NSLog(@"%@",param);
    [session GET:@"http://10.64.154.240:8080/RealTime/SignOverTime/test.show" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"返回數據%@",responseObject);
        
        self.loginStatus = [LoginStatus mj_objectWithKeyValues:responseObject];

        if ([self.loginStatus.StatusCode isEqualToString:@"500" ]) {

             self.mbHub= [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            NSString *message = [NSString stringWithFormat:@"%@",self.loginStatus.Messages];
                            self.mbHub.label.text = NSLocalizedString(message, @"HUD loading title");
                            self.mbHub.label.font = [UIFont systemFontOfSize:17.f];
            
            self.button.userInteractionEnabled = YES;
                            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
                                sleep(1.5);
                                dispatch_async(dispatch_get_main_queue(), ^{
            
                                    [self.mbHub hideAnimated:YES];
            
                                });
            
                            });
            
                           // return;

            
        }else if ([self.loginStatus.StatusCode isEqualToString:@"200" ]){
            
             NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:self.userFiled.text forKey:@"userName"];
            [userDefault setObject:self.passwordFiled.text forKey:@"password"];

            for (Employee *employee in self.loginStatus.Message) {
           self.deatilCtrl  = [[DeatilTableViewController alloc] init];
                self.deatilCtrl.employee = employee;
                self.deatilCtrl.button = self.button;
                self.deatilCtrl.shift = self.DnLabel.text;
                self.deatilCtrl.Message = self.loginStatus.Message;
                DeatilTableViewCell *cell = [[DeatilTableViewCell alloc] init];
                cell.employee = employee;
            }

            [self.navigationController pushViewController:self.deatilCtrl animated:YES];


            }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.button.userInteractionEnabled = YES;
        NSLog(@"请求失败%@",error);
    }];

}
#pragma mark - PickerView data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return self.teams.count;
}
- (void)buttonClick{
    //請求數據
    NSLog(@"========>點擊了登錄");
    [self setloaddata];
   
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [self.teams objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //選擇后的班別label
//    UILabel *seldnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 75, 35)];
//    seldnLabel.backgroundColor= [UIColor redColor];
//    seldnLabel.text = [self.teams objectAtIndex:row];;
//    seldnLabel.textAlignment = NSTextAlignmentCenter;
//    //passwordLable.backgroundColor = [UIColor greenColor];
//    seldnLabel.textColor = [UIColor blackColor];
//    [loginView addSubview:DnLabel];
    
    self.DnLabel.text = [self.teams objectAtIndex:row];

    if ([self.DnLabel.text isEqualToString:@"白班" ]) {
        self.DnLabel.text = @"D";
    }else if ([self.DnLabel.text isEqualToString:@"夜班" ]){
        self.DnLabel.text = @"N";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"你選的是%@",[self.teams objectAtIndex:row]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.DnPickerView.hidden = YES;
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];

}
//將要顯示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.userFiled resignFirstResponder];
    [self.passwordFiled resignFirstResponder];
}

@end
