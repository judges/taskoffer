//
//  ToToolHelper.h
//  TaskOffer
//
//  Created by BourbonZ on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToToolHelper : NSObject<xmppDelegate>

+(ToToolHelper *)sharedHelper;

///检测是否是手机号码
+(BOOL)isMobileNumber:(NSString *)mobileNum;

///检测是否是邮箱
+ (BOOL)isValidateEmail:(NSString *)Email;

///创建隐私设置相关
+(void)createPrivatePlist;
///更改隐私设置
+(void)editPrivatePlistWithDict:(NSDictionary *)dict;
///获取隐私设置
+(void)getPrivtePlist;
///登录事件
-(void)loginWithUserName:(NSString *)username password:(NSString *)password;

///图片裁剪成指定大小
+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourchImage:(UIImage *)sourceImage;

+(NSData *)imageBySize:(float)byteSize andImage:(UIImage *)image;

///检查登录结果
+(BOOL)checkIfLogin;
///保存登录结果
+(void)saveLoginState;
///更改退出登录
+(void)changeLoginState;
@end
