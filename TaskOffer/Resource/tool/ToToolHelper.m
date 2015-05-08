//
//  ToToolHelper.m
//  TaskOffer
//
//  Created by BourbonZ on 15/3/20.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "ToToolHelper.h"
#import "TOHttpHelper.h"
#import "APService.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "NSDictionary+NullFilter.h"
#import "SLFriendCircleConstant.h"

static ToToolHelper *toToolHelper = nil;
@implementation ToToolHelper

+(ToToolHelper *)sharedHelper
{
    if (toToolHelper == nil)
    {
        toToolHelper = [[ToToolHelper alloc] init];
    }
    return toToolHelper;
}

///检测是否是手机号码
+(BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

///检测是否是邮箱
+ (BOOL)isValidateEmail:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}
///图片裁剪成指定大小
+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourchImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}
///创建隐私设置相关
+(void)createPrivatePlist
{
    NSString *plistPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),@"private.plist"];
    NSMutableDictionary *privateDict = [NSMutableDictionary dictionary];
    [privateDict setObject:@"0" forKey:@"isReceive"];
    [privateDict setObject:@"0" forKey:@"isMsgDetail"];
    [privateDict setObject:@"0" forKey:@"isSearch"];
    [privateDict setObject:@"0" forKey:@"isAlldynamic"];
    [privateDict setObject:@"0" forKey:@"isStrangermsg"];
    
    [privateDict writeToFile:plistPath atomically:YES];
}
///更改隐私设置
+(void)editPrivatePlistWithDict:(NSDictionary *)dict
{
    NSString *plistPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),@"private.plist"];
    NSDictionary *oldDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:plistPath error:nil];
    [dict writeToFile:plistPath atomically:YES];
    
    // 变更
    if([oldDictionary boolForKey:@"isAlldynamic"] != [dict boolForKey:@"isAlldynamic"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:kSLPrivacyDynamicChangeNotification object:nil];
    }
}
///获取隐私设置
+(void)getPrivtePlist
{
    [ToToolHelper saveLoginState];
    
    [TOHttpHelper getUrl:kTOgetPrivate parameters:@{@"userId":[[UserInfo sharedInfo] userID]} showHUD:YES success:^(NSDictionary *dataDictionary) {
       
        
        
        NSDictionary *dict = [dataDictionary objectForKey:@"info"];
        NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
        
        [infoDict setObject:[dict objectForKey:@"isReceive"] forKey:@"isReceive"];
        [infoDict setObject:[dict objectForKey:@"isMsgDetail"] forKey:@"isMsgDetail"];
        [infoDict setObject:[dict objectForKey:@"isSearch"] forKey:@"isSearch"];
        [infoDict setObject:[dict objectForKey:@"isAlldynamic"] forKey:@"isAlldynamic"];
        [infoDict setObject:[dict objectForKey:@"isStrangermsg"] forKey:@"isStrangermsg"];

        
        [self editPrivatePlistWithDict:dict];
        
    }];
}
///登录事件
-(void)loginWithUserName:(NSString *)username password:(NSString *)password
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:username forKeyedSubscript:@"userPhone"];
    [dict setObject:password forKeyedSubscript:@"userPassword"];
    [dict setObject:[APService registrationID] forKey:@"pushId"];
    [dict setObject:@"1" forKeyedSubscript:@"phoneType"];

    
    [TOHttpHelper postUrl:kTOLogin parameters:dict showHUD:NO success:^(NSDictionary *dataDictionary) {
        
        UserInfo *info = [UserInfo sharedInfo];
        [info setInfoDict:[dataDictionary objectForKey:@"info"]];
        
        
        
        [[XMPPHelper sharedHelper] setDelegate:self];
//        [XMPPHelper loginWithJidWithUserName:@"wqz" passWord:@"wqz"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"toPassWord"];

        [XMPPHelper loginWithJidWithUserName:[info userID] passWord:[info userID]];

        
    } failure:^(NSError *error) {
        
        
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
        
        [[UIApplication sharedApplication] keyWindow].rootViewController = navi;
        
    }];
}
#pragma mark XMPP 登录相应事件
-(void)loginWithResult:(resultFromServer)result
{
    if (result == loginError)
    {
        [HUDView showHUDWithText:@"登录IM服务器失败"];
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:login];
        
        [[UIApplication sharedApplication] keyWindow].rootViewController = navi;

    }
    else if (result == loginSuccess)
    {
        [ToToolHelper getPrivtePlist];
    }
}
#pragma mark 限制图片大小
+(NSData *)imageBySize:(float)byteSize andImage:(UIImage *)image
{
    NSData *data = UIImageJPEGRepresentation(image, byteSize);
    

    while (data.length > 10*1024)
    {
        UIImage *tmp = [UIImage imageWithData:data];
        data = UIImageJPEGRepresentation(tmp, 0.5f);

    }
    return data;
}
///检查登录结果
+(BOOL)checkIfLogin
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"ifLogin"];
    if ([value isEqualToString:@"yes"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
///保存登录结果
+(void)saveLoginState
{
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"ifLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
///更改退出登录
+(void)changeLoginState
{
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"ifLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
