//
//  FLNetworkManager.h
//  OvertimeConfirm
//
//  Created by user on 2018/9/11.
//  Copyright © 2018年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
typedef NS_ENUM(NSUInteger,HTTPMethod) {
    
    HTTPMethodGET,  //獲取資源,不會改動資源
    HTTPMethodPOST, //創建記錄
    HTTPMethodPUT,  //改變資源狀態或更新部分屬性
    HTTPMethodPATCH, //更新全部屬性
    HTTPMethodDELETE, //刪除資源
    
};



@interface FLNetworkManager : NSObject

//單例
+ (nonnull instancetype)defaultManager;

#pragma mark 常用網絡請求方式
/**
 常用网络请求方式
 
 @param requestMethod 請求方式
 @param serverUrl 服務器地址
 @param apiPath 方法的鏈接
 @param parameters 參數
 @param progress 進度
 @param success 成功
 @param failure 失敗
 @return return value description
 */
- (nullable NSURLSessionDataTask *)sendRequestMethod:(HTTPMethod)requestMethod
                                           serverUrl:(nonnull NSString *)serverUrl
                                             apiPath:(nonnull NSString *)apiPath
                                          parameters:(nullable id)parameters
                                            progress:(nullable void (^)(NSProgress * _Nullable progress))progress
                                             success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success
                                             failure:(nullable void(^) (NSString * _Nullable errorMessage))failure ;




#pragma mark POST 上傳圖片
/**
 上传图片
 
 @param serverUrl 服務器的地址
 @param apiPath 方法的鏈接
 @param parameters 參數
 @param imageArray 圖片
 @param width 圖片的寬度
 @param progress 進度
 @param success 成功
 @param failure 失敗
 @return return value description
 */
- (nullable NSURLSessionDataTask *)sendPOSTRequestWithserverUrl:(nonnull NSString *)serverUrl
                                                        apiPath:(nonnull NSString *)apiPath
                                                     parameters:(nullable id)parameters
                                                     imageArray:(NSArray *_Nullable)imageArray
                                                    targetWidth:(CGFloat )width
                                                       progress:(nullable void (^)(NSProgress * _Nullable progress))progress
                                                        success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success
                                                        failure:(nullable void(^) (NSString *_Nullable error))failure ;







@end
