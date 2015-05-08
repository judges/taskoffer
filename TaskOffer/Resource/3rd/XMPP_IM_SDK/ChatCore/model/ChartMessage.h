//
//  ChartMessage.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
typedef enum {
  
    kMessageFrom=0,
    kMessageTo
 
}ChartMessageType;
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ChartMessage : NSObject
@property (nonatomic,assign) ChartMessageType messageType;
@property (nonatomic, copy) UIImage *icon;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSDictionary *dict;
@property (nonatomic,strong) NSNumber *audioDuration;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *userID;

///发送的名片，推荐的项目，案例，企业号
@property (nonatomic,copy) NSString *itemID;
@property (nonatomic,copy) NSString *itemContent;
@property (nonatomic,copy) NSString *itemName;
@property (nonatomic,copy) NSString *itemPicPath;
@property (nonatomic,copy) NSString *itemSubject;
@property (nonatomic,copy) NSString *itemType;
@end
