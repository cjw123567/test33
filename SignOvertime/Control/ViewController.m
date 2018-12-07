//
//  ViewController.m
//  SignOvertime
//
//  Created by user on 2018/8/3.
//  Copyright © 2018年 user. All rights reserved.
//

#import "ViewController.h"
#import "UIView+FJ.h"
#import "LJsignView.h"
#import <AFNetworking.h>
//#import "NSArray+decription.h"
//#import "NSDictionary+decription.h"

#import "Swipecardtime.h"
#import <MJExtension.h>
#import <MBProgressHUD.h>
#import "LoginStatus.h"
#import "DeatilTableViewController.h"
@interface ViewController ()<UIGestureRecognizerDelegate>
//簽名的image
@property(nonatomic,strong)UIImageView * imageView;

//簽名日期
@property (nonatomic,strong) UILabel *signLabel;

@property(nonatomic,assign)BOOL isSwiping;
@property(nonatomic,assign)CGPoint lastPoint;

@property(nonatomic,assign)CGFloat red;
@property(nonatomic,assign)CGFloat green;
@property(nonatomic,assign)CGFloat blue;
@property(nonatomic,strong)NSMutableArray * xPoints;
@property(nonatomic,strong)NSMutableArray * yPoints;
@property(nonatomic, strong) UIBezierPath *bezier;
//存储Undo出来的线条
@property(nonatomic, strong) NSMutableArray *cancleArray;
//存放模型的數組
@property(nonatomic,strong) NSMutableArray *swipecardtimeArray;
@property(nonatomic,strong) NSMutableArray *swipeArray;

//刷卡時間模型
@property (nonatomic,strong) Swipecardtime *swipecardtime;
//加班時數
@property (nonatomic,strong) UILabel *timelabel;
@property (nonatomic,assign) CGFloat i ;
//提示框
@property (nonatomic,strong) MBProgressHUD *mbHub;

@property (nonatomic,strong) LoginStatus *loginStatus;
@property (nonatomic,assign) NSInteger indexPathSel;
@end


@implementation ViewController
//懶加載數組
- (NSMutableArray *)swipecardtimeArray{
    if (_swipecardtimeArray == nil) {
        _swipecardtimeArray = [NSMutableArray array];
    }
    
    return _swipecardtimeArray;
}

- (NSMutableArray *)swipeArray{
    if (_swipeArray == nil) {
        _swipeArray = [NSMutableArray array];
    }
    
    return _swipeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //self.view.backgroundColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor whiteColor];

   
    //NSLog(@"%@========>>",userName);
    self.navigationItem.title = @"加班時間確認";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick)];
    //強制橫屏
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = UIInterfaceOrientationLandscapeLeft;
    [invocation setArgument:&val atIndex:2];//前两个参数已被target和selector占用
    [invocation invoke];
    
    
    //設置頂部view
    [self setTopView];
    
    //設置刷卡詳細view
    //[self setDeatilView];
    
    //設置簽名view
    [self setSignView];
    
    
    //請求數據
   // [self loaddata];
    
     [self setDeatilView];




    
}
-(void)loaddata{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:@"http://10.64.154.235/Signovertime/swipecardtime.php" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.swipecardtime = [Swipecardtime mj_objectWithKeyValues:responseObject];
        //[self.swipecardtimeArray addObject:swipecardtime];
        //設置刷卡詳細view
       // [self setDeatilView:self.swipecardtime];
        NSLog(@"%@",responseObject);
        NSLog(@"%@",self.swipecardtime.SWIPE_DATE);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败%@",error);
    }];

  
  
}
//保存簽名
-(void)saveButtonClick
{

    if(self.xPoints.count == 0 || self.yPoints.count == 0){
        
        self.mbHub= [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        self.mbHub.label.text = NSLocalizedString(@"請簽名", @"HUD loading title");
        self.mbHub.label.font = [UIFont systemFontOfSize:17.f];
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            
            sleep(2);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.mbHub hideAnimated:YES];
    
            });
            
        });
        return;
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.width, self.view.height), NO, 0.0);    //设置截屏大小
    
    //    UIGraphicsBeginImageContext(CGSizeMake(LCDW,LCDH));
    
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = viewImage.CGImage;
    
    CGRect rect = CGRectMake(2*self.view.frame.origin.x,2*self.view.frame.origin.y-15, 2*self.view.frame.size.width,2*(self.view.frame.size.height) );//这里可以设置想要截图的区域
    
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    //上傳圖片到數據庫
    [self uploadImageToData:sendImage];
    //UIImageWriteToSavedPhotosAlbum(sendImage, self, @selector ( image:didFinishSavingWithError:contextInfo:), nil);//保存图片到照片库
   
}
//上傳圖片到數據庫
- (void)uploadImageToData:(UIImage *)image{
    
    
    NSString *str = @"提示";
    NSString *message = @"請確認加班信息是否正確!!!";
    
    UIAlertController *loginOut = [UIAlertController alertControllerWithTitle:str message:message preferredStyle:UIAlertControllerStyleAlert];
    //NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:str];
    //        [titleAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.f] range:NSMakeRange(0, str.length)];
    //        [titleAtt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, str.length)];
    //        [loginOut setValue:titleAtt forKey:@"attributedTitle"];
    
    NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
    [messageAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.f] range:NSMakeRange(0, message.length)];
    [messageAtt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, message.length)];
    [loginOut setValue:messageAtt forKey:@"attributedMessage"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.tagCtrl == 12) {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 20;
            //2.上传文件
            //NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"userHeader.png", @"userHeader", nil];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            //    NSData *data = UIImageJPEGRepresentation(image, 1.0);
            //    NSData *base64Data = [data base64EncodedDataWithOptions:0];
            //    NSString *pictureDataStr = [[NSString alloc] initWithData:base64Data encoding: NSUTF8StringEncoding];
            //NSData *imageData = UIImagePNGRepresentation(image);
            
            NSString *userName = [userDefault objectForKey:@"userName"];
            //
            NSDictionary *param = @{ @"id":self.employee.ID,@"overtimedate":self.employee.overtimeDate,@"overtimehours":self.timelabel.text,@"login_user":userName,@"confirm_time":self.signLabel.text};
            
            
            [manager POST:@"http://10.64.154.240:8080/RealTime/SignOverTime/upload" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSData *data = UIImagePNGRepresentation(image);
                
                
                // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                // 要解决此问题，
                // 可以在上传时使用当前的系统事件作为文件名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                
                //上传
                /*
                 此方法参数
                 1. 要上传的[二进制数据]
                 2. 对应网站上[upload.php中]处理文件的[字段"file"]
                 3. 要保存在服务器上的[文件名]
                 4. 上传文件的[mimeType]
                 */
                [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
                
                
                
                //[formData  appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
                
                //上传文件参数
                //[formData appendPartWithFileData:data name:@"userHeader" fileName:@"userHeader.png" mimeType:@"image/jpeg"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                self.loginStatus = [LoginStatus mj_objectWithKeyValues:responseObject];
                
                __weak typeof(self) weakself = self;
                NSString *code = @"1";
                if (weakself.confirmCodeBlock) {
                    weakself.confirmCodeBlock(weakself.loginStatus.StatusCode,code);
                    
                }
                NSLog(@"上传成功 %@=====>", self.loginStatus.StatusCode);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"上传失败 %@", error);
            }];
            
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 20;
            //2.上传文件
            //NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"userHeader.png", @"userHeader", nil];
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            //    NSData *data = UIImageJPEGRepresentation(image, 1.0);
            //    NSData *base64Data = [data base64EncodedDataWithOptions:0];
            //    NSString *pictureDataStr = [[NSString alloc] initWithData:base64Data encoding: NSUTF8StringEncoding];
            //NSData *imageData = UIImagePNGRepresentation(image);
            
            NSString *userName = [userDefault objectForKey:@"userName"];
            //
            NSDictionary *param = @{ @"id":self.employee.ID,@"overtimedate":self.employee.overtimeDate,@"overtimehours":self.timelabel.text,@"login_user":userName,@"confirm_time":self.signLabel.text};
            
            
            [manager POST:@"http://10.64.154.240:8080/RealTime/SignOverTime/update" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSData *data = UIImagePNGRepresentation(image);
                
                
                // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                // 要解决此问题，
                // 可以在上传时使用当前的系统事件作为文件名
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                
                //上传
                /*
                 此方法参数
                 1. 要上传的[二进制数据]
                 2. 对应网站上[upload.php中]处理文件的[字段"file"]
                 3. 要保存在服务器上的[文件名]
                 4. 上传文件的[mimeType]
                 */
                [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
                
                
                
                //[formData  appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
                
                //上传文件参数
                //[formData appendPartWithFileData:data name:@"userHeader" fileName:@"userHeader.png" mimeType:@"image/jpeg"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                self.loginStatus = [LoginStatus mj_objectWithKeyValues:responseObject];
                
                __weak typeof(self) weakself = self;
                NSString *code = @"1";
                if (weakself.confirmCodeBlock) {
                    weakself.confirmCodeBlock(weakself.loginStatus.StatusCode,code);
                    
                }
                NSLog(@"上传成功 %@=====>", self.loginStatus.StatusCode);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"上传失败 %@", error);
            }];
            
            
            
            [self.navigationController popViewControllerAnimated:YES];

        }
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        manager.requestSerializer.timeoutInterval = 20;
//        //2.上传文件
//        //NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"userHeader.png", @"userHeader", nil];
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        //    NSData *data = UIImageJPEGRepresentation(image, 1.0);
//        //    NSData *base64Data = [data base64EncodedDataWithOptions:0];
//        //    NSString *pictureDataStr = [[NSString alloc] initWithData:base64Data encoding: NSUTF8StringEncoding];
//        //NSData *imageData = UIImagePNGRepresentation(image);
//
//        NSString *userName = [userDefault objectForKey:@"userName"];
//        //
//        NSDictionary *param = @{ @"id":self.employee.ID,@"overtimedate":self.employee.overtimeDate,@"overtimehours":self.timelabel.text,@"login_user":userName,@"confirm_time":self.signLabel.text};
//
//
//                    [manager POST:@"http://10.64.154.240:8080/RealTime/SignOverTime/upload" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            NSData *data = UIImagePNGRepresentation(image);
//
//
//            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
//            // 要解决此问题，
//            // 可以在上传时使用当前的系统事件作为文件名
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            // 设置时间格式
//            formatter.dateFormat = @"yyyyMMddHHmmss";
//            NSString *str = [formatter stringFromDate:[NSDate date]];
//            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//
//            //上传
//            /*
//             此方法参数
//             1. 要上传的[二进制数据]
//             2. 对应网站上[upload.php中]处理文件的[字段"file"]
//             3. 要保存在服务器上的[文件名]
//             4. 上传文件的[mimeType]
//             */
//            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
//
//
//
//            //[formData  appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
//
//            //上传文件参数
//            //[formData appendPartWithFileData:data name:@"userHeader" fileName:@"userHeader.png" mimeType:@"image/jpeg"];
//        } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//            self.loginStatus = [LoginStatus mj_objectWithKeyValues:responseObject];
//
//            __weak typeof(self) weakself = self;
//            NSString *code = @"1";
//            if (weakself.confirmCodeBlock) {
//                weakself.confirmCodeBlock(weakself.loginStatus.StatusCode,code);
//
//            }
//            NSLog(@"上传成功 %@=====>", self.loginStatus.StatusCode);
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//            NSLog(@"上传失败 %@", error);
//        }];
//
//
//
//        [self.navigationController popViewControllerAnimated:YES];
    }];
    [loginOut addAction:cancelAction];
    [loginOut addAction:okAction];
    //[self presentViewController:loginOut animated:YES completion:nil];
    [self presentViewController:loginOut animated:YES completion:nil];

    
    
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo

{
    
    if (error == nil) {
        
       
        
//        NSString *str = @"提示";
//        NSString *message = @"請確認加班信息是否正確!!!";
//
//        UIAlertController *loginOut = [UIAlertController alertControllerWithTitle:str message:message preferredStyle:UIAlertControllerStyleAlert];
//
//        NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] initWithString:message];
//        [messageAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.f] range:NSMakeRange(0, message.length)];
//        [messageAtt addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, message.length)];
//        [loginOut setValue:messageAtt forKey:@"attributedMessage"];
//
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            self.mbHub= [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//
//            self.mbHub.label.text = NSLocalizedString(@"登錄中...", @"HUD loading title");
//            self.mbHub.label.font = [UIFont systemFontOfSize:17.f];
//            //self.button.userInteractionEnabled = NO;
//            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
//
//                sleep(1.5);
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    [self.mbHub hideAnimated:YES];
//
//                });
//
//            });
//
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//        [loginOut addAction:cancelAction];
//        [loginOut addAction:okAction];
//        [self presentViewController:loginOut animated:YES completion:nil];
//
//
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败,你的设置里的隐私设置,可能拒绝了,XXXXX访问你的照片" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alert show];
        
    }
    
}

//返回
-(void)buttonClick
{
 
    [self.navigationController popViewControllerAnimated:YES];
}
//減加班時數
- (void)minbuttonClick{
    //NSString *timeStr = @"2";
    //CGFloat i ;
    if ([self.timelabel.text isEqualToString:@"0.00"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加班時數不能小於0小時" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
           // [self.navigationController popViewControllerAnimated:YES];
            //return;
        }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    _i -= 0.25;
    self.timelabel.text = [NSString stringWithFormat:@"%.2f",_i];
    
    
}
//加加班時數
- (void)addbuttonClick{
    if ([self.timelabel.text isEqualToString:@"24.00"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"加班時數不能大於24小時" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    
        return;
    }
    _i += 0.25;
    self.timelabel.text = [NSString stringWithFormat:@"%.2f",_i];

    
    
}
//繪製簽名
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isSwiping    = false;
    UITouch * touch = touches.anyObject;
    self.lastPoint = [touch locationInView:self.imageView];
    [self.xPoints addObject:[NSNumber numberWithFloat:self.lastPoint.x]];
    [self.yPoints addObject:[NSNumber numberWithFloat:self.lastPoint.y]];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isSwiping = true;
    UITouch * touch = touches.anyObject;
    CGPoint currentPoint = [touch locationInView:self.imageView];
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    [self.imageView.image drawInRect:(CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height))];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(),kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(),0.0, 0.0, 0.0, 1.0);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.lastPoint = currentPoint;
    [self.xPoints addObject:[NSNumber numberWithFloat:self.lastPoint.x]];
    [self.yPoints addObject:[NSNumber numberWithFloat:self.lastPoint.y]];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(!self.isSwiping) {
        // This is a single touch, draw a point
        UIGraphicsBeginImageContext(self.imageView.frame.size);
        [self.imageView.image drawInRect:(CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height))];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    
}

#pragma mark getter && setter
-(NSMutableArray*)xPoints
{
    if (!_xPoints) {
        _xPoints=[[NSMutableArray alloc]initWithCapacity:0];
    }
    return _xPoints;
}
-(NSMutableArray*)yPoints
{
    if (!_yPoints) {
        _yPoints=[[NSMutableArray alloc]initWithCapacity:0];
    }
    return _yPoints;
}
#pragma mark delegate
- (void)showImage:(UIImage *)image
{
    //检测代理有没有实现代理方法
    
    if([self.delegate respondsToSelector:@selector(showImage:)]){
        [self.delegate showImage:image];
    }else{
        NSLog(@"代理没有实现changeStatus:方法");
    }
}
//重簽
- (void)clearSignature{
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.xPoints =nil;
    self.yPoints = nil;
    self.imageView.image = nil;
    [self.imageView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//設置頂部view
- (void)setTopView{
    
    //頂部view
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64,self.view.width, 45)];
    topView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:topView];
    
    
    titleArray = [[NSMutableArray alloc] initWithObjects:@"姓名",@"工號",@"部門代碼",@"加班日期",@"班別",@"加班時數",nil];
    int x = topView.width / 6 ;
    
    for(int i=0;i<[titleArray count];i++)
    {
        
        UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(x*i, 0, x, 45)];
        //隨機顏色
//         UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
//        tmpLabel.backgroundColor = randomColor;
        
        //tmpLabel.backgroundColor = [UIColor clearColor];
        tmpLabel.font = [UIFont systemFontOfSize:15];
        tmpLabel.text = [titleArray objectAtIndex:i];
        tmpLabel.textColor = [UIColor whiteColor];
        
        //tmpLabel.backgroundColor = [UIColor yellowColor];
        //                 UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
        //                 tmpLabel.backgroundColor = randomColor;
        
        tmpLabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:tmpLabel];
        
        
    }
    
}
//設置詳細view
- (void)setDeatilView{
    //頂部view
    UIView *deatilView = [[UIView alloc] initWithFrame:CGRectMake(0, 105,self.view.width, 45)];
    //deatilView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:deatilView];
    for (Employee *employee in self.employeeArray) {
       // [self.employeeArray addObject:employee];
        self.employee = employee;
        NSLog(@"====%@,======%@",employee.name,employee.ID);
//        self.swipecardtimeArray = [[NSMutableArray alloc] initWithObjects:employee.NAME,employee.ID,swipecardtime.SWIPE_DATE,swipecardtime.CLASS_NO,nil];

    }
    //NSLog(@"%@========%@====%@",self.employee.NAME,self.employee.ID,swipecardtime.SWIPE_DATE);
    self.swipecardtimeArray = [[NSMutableArray alloc] initWithObjects:self.employee.name,self.employee.ID,self.employee.depid,self.employee.overtimeDate,self.employee.class_no,nil];
    
    int x = deatilView.width / 6 ;
    for(int i=0;i<self.swipecardtimeArray.count;i++)
    {
        
        UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(x*i, 0, x, 45)];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i*x, 0, 1, 45)];
        lineView.backgroundColor = [UIColor grayColor];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, deatilView.width, 1)];
        bottomView.backgroundColor = [UIColor blackColor];
        //NSIndexPath *indexPath;
        //隨機顏色
//        UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
//        tmpLabel.backgroundColor = randomColor;
        //tmpLabel.backgroundColor = [UIColor clearColor];
        tmpLabel.font = [UIFont systemFontOfSize:15];
        tmpLabel.text = [self.swipecardtimeArray objectAtIndex:i];
        tmpLabel.textColor = [UIColor blackColor];
        tmpLabel.textAlignment = NSTextAlignmentCenter;
        [deatilView addSubview:tmpLabel];
        [deatilView addSubview:lineView];
        [deatilView addSubview:bottomView];
        
        
    }
    
    UIView *lineview= [[UIView alloc] initWithFrame:CGRectMake(deatilView.width /6 * 5, 0, 1, 45)];
 
    lineview.backgroundColor = [UIColor grayColor];
    //減號button
    UIButton * minbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [minbutton setTitle:@"➖" forState:UIControlStateNormal];
    //button.backgroundColor=[UIColor redColor];
    minbutton.frame=CGRectMake(deatilView.width / 6 * 5,0, deatilView.width /6 * 0.25, 45);
    //[minbutton setBackgroundColor:[UIColor redColor]];
    NSLog(@"%f",deatilView.width*0.2);
    [minbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [minbutton addTarget:self action:@selector(minbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    //加班時數顯示
    self.timelabel = [[UILabel alloc] initWithFrame:CGRectMake(minbutton.x+minbutton.width, 0, deatilView.width /6 * 0.5, 45)];

    NSDate *date = [NSDate date];
   NSString *dateWeek = [self calculateWeek:date];
    if([dateWeek isEqualToString:@"週一"] ||[dateWeek isEqualToString:@"週二"]||[dateWeek isEqualToString:@"週三"]||[dateWeek isEqualToString:@"週四"]||[dateWeek isEqualToString:@"週五"]){
        _i = 2.0;
        
    }else if([dateWeek isEqualToString:@"週六"]||[dateWeek isEqualToString:@"週日"]){
        _i = 10.0;
        }
   
    self.timelabel.text = [NSString stringWithFormat:@"%.2f",_i];
    //self.timelabel.text = @"2";
    self.timelabel.textAlignment = NSTextAlignmentCenter;
   //加號button➕
    UIButton * addbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [addbutton setTitle:@"➕" forState:UIControlStateNormal];
    //button.backgroundColor=[UIColor redColor];
    addbutton.frame=CGRectMake(self.timelabel.x + self.timelabel.width,0, deatilView.width /6 * 0.25, 45);
   // [addbutton setBackgroundColor:[UIColor redColor]];
    NSLog(@"%f",deatilView.width*0.2);
    [addbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addbutton addTarget:self action:@selector(addbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [deatilView addSubview:lineview];
    [deatilView addSubview:minbutton];
    [deatilView addSubview:addbutton];
    [deatilView addSubview:self.timelabel];


}
- (void)setSignView{
    
    
    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 500)];
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.borderColor =[[UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1] CGColor];
    
    
    [self.view addSubview:self.imageView];
    
    self.signLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.width - 200, self.imageView.height-50, 200, 50)];
    //獲取當前時間
    NSDate *date = [NSDate date];
    //self.signLabel.backgroundColor = [UIColor grayColor];
    NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr;
    dateStr = [format1 stringFromDate:date];
    self.signLabel.text = dateStr;
    [self.imageView addSubview:self.signLabel];
    
    //添加阴影
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100, self.imageView.y + self.imageView.height + 20, 75, 75);
    layer.backgroundColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(5, 5);
    layer.shadowOpacity = 0.7;
    layer.cornerRadius = 75*0.5;
    [self.view.layer addSublayer:layer];
    CALayer *layerR = [CALayer layer];
    layerR.frame = CGRectMake(self.view.width-150, self.imageView.y + self.imageView.height + 20, 75, 75);
    layerR.backgroundColor = [UIColor blackColor].CGColor;
    layerR.shadowOffset = CGSizeMake(5, 5);
    layerR.shadowOpacity = 0.7;
    layerR.cornerRadius = 75*0.5;
    [self.view.layer addSublayer:layerR];
    
    UIButton * saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.layer.cornerRadius = 75 * 0.5;
    saveButton.layer.masksToBounds = YES;
    saveButton.layer.shadowOffset = CGSizeMake(1, 1);
    saveButton.layer.shadowOpacity = 0.8;
    saveButton.layer.shadowColor = [UIColor blackColor].CGColor;
    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    //[saveButton setBackgroundImage:[UIImage imageNamed:@"saveBtn.png"] forState:UIControlStateNormal];
    saveButton.backgroundColor=[UIColor greenColor];
    saveButton.frame=CGRectMake(100, self.imageView.y + self.imageView.height + 20, 75, 75);
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    UIButton * returnButton=[UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.layer.cornerRadius = 75 * 0.5;
    returnButton.layer.masksToBounds = YES;
    [returnButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [returnButton setTitle:@"重簽" forState:UIControlStateNormal];
    returnButton.backgroundColor=[UIColor redColor];
    //[returnButton  setBackgroundImage:[UIImage imageNamed:@"resignBtn.png"] forState:UIControlStateNormal];
    returnButton.frame=CGRectMake(self.view.width-150, self.imageView.y + self.imageView.height + 20, 75, 75);
    [returnButton addTarget:self action:@selector(clearSignature) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnButton];

}

//計算週幾
- (NSString *)calculateWeek:(NSDate *)date{
    //计算week数
    
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
    
    NSInteger week = [[myCalendar components:NSCalendarUnitWeekday fromDate:date] weekday];
    
   // NSLog(@"week : %zd",week);
    
    switch (week) {
            
        case 1:
            
        {
            
            return @"週日";
            
        }
            
        case 2:
            
        {
            
            return @"週一";
            
        }
            
        case 3:
            
        {
            
            return @"週二";
            
        }
            
        case 4:
            
        {
            
            return @"週三";
            
        }
            
        case 5:
            
        {
            
            return @"週四";
            
        }
            
        case 6:
            
        {
            
            return @"週五";
            
        }
            
        case 7:
            
        {
            
            return @"週六";
            
        }
            
    }
        return @"";
    
}
@end
