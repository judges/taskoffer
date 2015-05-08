//
//  SeparateByArray.h
//  XMPPIM
//
//  Created by BourbonZ on 14/12/24.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SeparateByArray : NSObject
{
    NSMutableArray *faceArray;
}

+(SeparateByArray *)shared;
///将得到的字符串转换成view
-(UIView *)retrunSeparateViewByContent:(NSString *)content;
///将得到的字符串转换成数组
-(NSArray *)returnArrayByContent:(NSString *)content;
@end
