//
//  XMPPFileHelper.h
//  XMPPIM
//
//  Created by BourbonZ on 15/1/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TURNSocket.h"
@protocol XMPPFileHelperDelegate <NSObject>

///查询到的服务器代理
-(void)allServerProxy:(NSArray *)proxyArray;

@end

@interface XMPPFileHelper : NSObject<TURNSocketDelegate>

@property (nonatomic,weak) id<XMPPFileHelperDelegate>delegate;

+(XMPPFileHelper *)shared;

///检测服务器代理
-(void)checkServerProxy;



#pragma mark 私有方法
-(void)_serverProxy:(NSArray *)proxyArray;

@end
