//
//  RedViewInfo.m
//  XMPPIM
//
//  Created by BourbonZ on 15/1/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "RedViewInfo.h"


@implementation RedViewInfo

@dynamic showRed;
@dynamic bardJidStr;
@dynamic streamJidStr;
@dynamic type;

-(NSString *)description
{
    return [NSString stringWithFormat:@"发送人:%@ 是否显示红点%@ 类型:%@",self.bardJidStr,self.showRed,self.type];
}

@end
