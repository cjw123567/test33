//
//  OverTimeTableViewController.m
//  SignOvertime
//
//  Created by user on 2018/8/6.
//  Copyright © 2018年 user. All rights reserved.
//

#import "OverTimeTableViewController.h"
#import "UIView+FJ.h"
@interface OverTimeTableViewController ()

@end

@implementation OverTimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //強制橫屏
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = UIInterfaceOrientationLandscapeLeft;
    [invocation setArgument:&val atIndex:2];//前两个参数已被target和selector占用
    [invocation invoke];
    
    //頂部view
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.height+20, 45)];
    topView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:topView];

    
    titleArray = [[NSArray alloc] initWithObjects:@"姓名",@"工號",@"上班刷卡",@"下班刷卡",@"白/晚班",nil];
    
    for(int i=0;i<[titleArray count];i++)
    {
        UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(130*i+20, 5, 130, 45)];
        //隨機顏色
        // UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
        //tmpLabel.backgroundColor = randomColor;
        tmpLabel.backgroundColor = [UIColor clearColor];
        tmpLabel.font = [UIFont systemFontOfSize:15];
        tmpLabel.text = [titleArray objectAtIndex:i];
        tmpLabel.textColor = [UIColor whiteColor];
        //tmpLabel.backgroundColor = [UIColor yellowColor];
        // UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
       // tmpLabel.backgroundColor = randomColor;

        tmpLabel.textAlignment = NSTextAlignmentCenter;
        [topView addSubview:tmpLabel];
        
        //禁止滑動
        self.tableView.scrollEnabled = NO;
        //[tmpLabel release];
    }

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    //if([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]){
//        SEL selector = NSSelectorFromString(@"setOrientation");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationLandscapeLeft;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
        
        

        
        
   // }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
