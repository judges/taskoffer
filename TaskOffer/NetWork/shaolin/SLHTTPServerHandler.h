//
//  SLHTTPServerHandler.h
//  TaskOffer
//
//  Created by wshaolin on 15/4/1.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

// #define SLHTTPServerAddressHeader @"http://192.168.1.198:8080"
// #define SLDynamicHTTPServerAddressHeader @"http://192.168.1.206:9090"

#define SLHTTPServerAddressHeader @"http://123.57.137.163:8080" // 托付地址
#define SLDynamicHTTPServerAddressHeader @"http://123.57.137.163:9090" // 动态地址

typedef NS_ENUM(NSInteger, SLHTTPServerImageKind){ // 图片类型
    SLHTTPServerImageKindUserAvatar, // 用户头像图片
    SLHTTPServerImageKindProjectPicture, // 项目图片
    SLHTTPServerImageKindCaseLogo, // 案例LOGO
    SLHTTPServerImageKindCasePicture, // 案例图片
    SLHTTPServerImageKindEnterpriseLogo, // 企业LOGO
    SLHTTPServerImageKindEnterpriseQualification, // 企业资质
    SLHTTPServerImageKindSystemMessage // 系统消息
};

// 根据图片名和图片类型返回图片（缩略图）完整的URL
static inline NSString *SLHTTPServerImageURL(NSString *imageName, SLHTTPServerImageKind imageKind){
    NSString *imageURL = @"";
    if(imageName != nil && imageName.length > 0){
        // thumb/
        NSArray *array = @[@"/toserver/uploads/user_head_picture/",
                           @"/toserver/uploads/project_picture/",
                           @"/toserver/uploads/case_logo_picture/",
                           @"/toserver/uploads/case_picture/",
                           @"/toserver/uploads/company_logo_picture/",
                           @"/toserver/uploads/company_qualification_picture/",
                           @"/toserver/uploads/system_message_picture/"];
        if(imageKind >= SLHTTPServerImageKindUserAvatar && imageKind <= SLHTTPServerImageKindSystemMessage){
            imageURL = [NSString stringWithFormat:@"%@%@%@", SLHTTPServerAddressHeader, array[imageKind], imageName];
        }
    }
    
    return imageURL;
}

// 根据图片（缩略图）完整URL返回图片（原图的）完整的URL
static inline NSString *SLHTTPServerLargeImageURL(NSString *imageURL){
    return [imageURL stringByReplacingOccurrencesOfString:@"thumb/" withString:@""];
}
