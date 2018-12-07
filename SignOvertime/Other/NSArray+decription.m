//
//  NSArray+decription.m
//  SignOvertime
//
//  Created by user on 2018/8/10.
//  Copyright © 2018年 user. All rights reserved.
//

#import "NSArray+decription.h"

@implementation NSArray (decription)
//- (NSString *)descriptionWithLocale:(id)locale{
//
//    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
//    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [strM appendFormat:@"\t%@ = %ld;\n", obj, idx];
//
//    }];
////        [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
////        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
////    }];
//
//    [strM appendString:@"}\n"];
//    
//    return strM;
//}


- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *string = [NSMutableString string];
    
    // 开头有个[
    [string appendString:@"[\n"];
    
    // 遍历所有的元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [string appendFormat:@"\t%@,\n", obj];
    }];
    
    // 结尾有个]
    [string appendString:@"]"];
    
    // 查找最后一个逗号
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound)
        [string deleteCharactersInRange:range];
    
    return string;
}





@end
