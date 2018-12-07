//
//  DeatilTableViewCell.m
//  SignOvertime
//
//  Created by user on 2018/8/24.
//  Copyright © 2018年 user. All rights reserved.
//

#import "DeatilTableViewCell.h"
#import "UIView+FJ.h"
#import "ViewController.h"

@implementation DeatilTableViewCell
//{
//    UILabel *namelabelS;
//    UILabel *idlabelS;
//    
//    
//}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //姓名
    
        //self.backgroundColor = [UIColor yellowColor];
        //89.5   h:71  w:138
       
        UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(70, (89.5-71) * 0.5, 138, 71)];
        namelabel.textColor = [UIColor blackColor];
       // namelabel.text = self.employee.name;
        //namelabel.backgroundColor = [UIColor redColor];
        self.namelabelS = namelabel;
        self.namelabelS.textAlignment = NSTextAlignmentCenter;
        self.namelabelS.font = [UIFont systemFontOfSize:22.f];

        //NSLog(@"姓名=====>>>%@",namelabel.text);
        [self addSubview:namelabel];
        
        
        ///zhush
        UILabel *idlabel = [[UILabel alloc] initWithFrame:CGRectMake(namelabel.x + namelabel.width + 70, namelabel.y, namelabel.width, namelabel.height)];
        //idlabel.text = self.employee.ID;
        //idlabel.backgroundColor  =[UIColor redColor];
        idlabel.textColor = [UIColor blackColor];
        self.idlabelS = idlabel;
        self.idlabelS.textAlignment = NSTextAlignmentCenter;
        self.idlabelS.font = [UIFont systemFontOfSize:22.f];
        [self addSubview:idlabel];
        UIButton *shadowViewOne = [UIButton buttonWithType:UIButtonTypeCustom] ;
        shadowViewOne.frame = CGRectMake(0, 0, idlabel.x + idlabel.width + 60  , 89.5);
                                   
               // shadowViewOne.backgroundColor = [UIColor greenColor];
        [self addSubview:shadowViewOne];
       // UITapGestureRecognizer *tapGestur = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowViewOneClick)];
        
        self.shadowViewOne = shadowViewOne;
        
        UIButton *resignBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        resignBtn.frame = CGRectMake(idlabel.x + idlabel.width + 60, self.centerY, 50, 50);
       // resignBtn.backgroundColor = [UIColor redColor];
        [resignBtn setTitle:@"重簽" forState:UIControlStateNormal];
        [resignBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [resignBtn setBackgroundImage:[UIImage imageNamed:@"resignBtn.png"] forState:UIControlStateNormal];
        resignBtn.userInteractionEnabled = YES;
        //[resignBtn addTarget:self action:@selector(resignClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:resignBtn];
        resignBtn.layer.cornerRadius = 50 * 0.5;
        resignBtn.layer.masksToBounds = YES;
        self.resignBtn = resignBtn;
        
        UIView *shadowViewTwo = [[UIView alloc] initWithFrame:CGRectMake(resignBtn.x+resignBtn.width, 0, 25  , 89.5)];
        //shadowViewTwo.backgroundColor = [UIColor greenColor];
        //[self addSubview:shadowViewTwo];
        self.shadowViewTwo = shadowViewTwo;

        UIButton *lookBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        lookBtn.frame = CGRectMake(resignBtn.x + resignBtn.width + 25, self.centerY, 50, 50);
        lookBtn.backgroundColor = [UIColor redColor];
        [lookBtn setTitle:@"查看" forState:UIControlStateNormal];
        [lookBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [lookBtn setBackgroundImage:[UIImage imageNamed:@"saveBtn.png"] forState:UIControlStateNormal];
        lookBtn.userInteractionEnabled = YES;
        //[lookBtn addTarget:self action:@selector(lookBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:lookBtn];
        lookBtn.layer.cornerRadius = 50 * 0.5;
        lookBtn.layer.masksToBounds = YES;
        self.lookBtn = lookBtn;
        
        UIView *shadowViewThree = [[UIView alloc] initWithFrame:CGRectMake(lookBtn.x+lookBtn.width, 0,  lookBtn.x+lookBtn.width  , 89.5)];
        //shadowViewThree.backgroundColor = [UIColor greenColor];
        //[self addSubview:shadowViewThree];
        self.shadowViewThree = shadowViewThree;

    }
    
    
    
    return  self;
}
- (void)setEmployee:(Employee *)employee{
    self.idlabelS.text = employee.ID;
    self.namelabelS.text = employee.name;
    
    if ([employee.status isEqualToString: @"1"]) {
        self.idlabelS.textColor = [UIColor blueColor];
        self.namelabelS.textColor = [UIColor blueColor];
        //self.selectionStyle = UITableViewCellSelectionStyleDefault;
//        for (UIButton *reBtn in self.subviews) {
//
//            if ([reBtn isKindOfClass:[self.resignBtn class]]) {
//
//                self.userInteractionEnabled = YES;
//            }else{
        self.shadowViewOne.userInteractionEnabled = NO;
//        self.shadowViewTwo.userInteractionEnabled = NO;
//        self.shadowViewThree.userInteractionEnabled = NO;

                //self.userInteractionEnabled = NO;
//            }
       // }
        
    }else{

        self.idlabelS.textColor = [UIColor blackColor];
        self.namelabelS.textColor = [UIColor blackColor];
        self.shadowViewOne.userInteractionEnabled = YES;
//        self.shadowViewOne.userInteractionEnabled = YES;
//        self.shadowViewTwo.userInteractionEnabled = YES;
//        self.shadowViewThree.userInteractionEnabled = YES;


    }

    
}

//- (void)resignClick{
//    NSLog(@"點擊的重簽!!!===========>>");
//
//}
//- (void)lookBtnClick:(UIButton *)sender{
//    NSLog(@"點擊的查看!!!===========>>");
//
//
//
//
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
