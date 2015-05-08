//
//  SeparateByArray.m
//  XMPPIM
//
//  Created by BourbonZ on 14/12/24.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SeparateByArray.h"
#import "RegexKitLite.h"
#define biaoqingHeight 20
#define biaoqingWeight 20
#define MAX_Width 220


static SeparateByArray *_separate;
@implementation SeparateByArray
+(SeparateByArray *)shared
{
    if (_separate == nil)
    {
        _separate = [[SeparateByArray alloc] init];
    }
    return _separate;
}
-(UIView *)retrunSeparateViewByContent:(NSString *)content
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    //聊天信息坐标
    CGFloat chatX=0;
    CGFloat chatY=0;
    //view的坐标
    CGFloat X=0;
    CGFloat Y=0;
    
    ///取出字典
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"facemap" ofType:@"json"]];
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
    
    NSArray *array = [self returnArrayByContent:content];
    for (int i = 0; i < array.count; i++)
    {
        NSString *chatString = [array objectAtIndex:i];
        
        ///判断是否是表情
        if ([[dataDict allKeys] containsObject:chatString])
        {
            NSInteger num = [[dataDict allKeys] indexOfObject:chatString];
            NSString *name = [[dataDict allValues] objectAtIndex:num];
            
            UIImage *image = [UIImage imageNamed:name];
            
            UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
            imageView.frame=CGRectMake(chatX, chatY, biaoqingWeight, biaoqingHeight);
            [view addSubview:imageView];
            chatX=chatX+biaoqingWeight;
            if (chatX>=200)
            {
                chatY=chatY+biaoqingHeight;
                chatX=0;
                X=MAX_Width;
                Y=chatY;
            }
            if (X<200)
            {
                X=chatX;
            }
        }
        else
        {
            ///不是表情
            for (int j=0; j<[chatString length]; j++)
            {
                NSString *temp=[chatString substringWithRange:NSMakeRange(j, 1)];
                CGSize labelSize;
                if ([[[UIDevice currentDevice] systemVersion] floatValue ] >= 7)
                {
                    labelSize=[temp sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
                    
                }
                else
                {
                    labelSize=[temp sizeWithFont:[UIFont systemFontOfSize:15]];
                }
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(chatX, chatY, labelSize.width, labelSize.height)];
                // UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(chatX, chatY, labelSize.width, biaoqingHeight)];
                
                label.textColor=[UIColor blackColor];
                label.text=temp;
                label.textAlignment=NSTextAlignmentCenter;
                label.font=[UIFont systemFontOfSize:15];
                //                label.backgroundColor=[UIColor redColor];
                label.backgroundColor = [UIColor clearColor];
                [view addSubview:label];
                chatX=chatX+labelSize.width;
                if (chatX>=200)
                {
                    chatY=chatY+biaoqingHeight;
                    chatX=0;
                    X=MAX_Width;
                    Y=chatY;
                    //label.frame=CGRectMake(chatX, chatY, labelSize.width, labelSize.height);
                }
                if (X<200)
                {
                    X=chatX;
                }
            }
        }
    }
    
    view.frame=CGRectMake(0, 15, X,Y+biaoqingHeight);
    view.backgroundColor = [UIColor clearColor];
    [faceArray removeAllObjects];
    return view;
}
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        faceArray = [[NSMutableArray alloc] init];
    }
    return self;
    
}
-(NSArray *)returnArrayByContent:(NSString *)content
{
    NSString *regax = @"\\[(\\S+?)\\]";

    NSRange firstRange = [content rangeOfRegex:regax];
    if (firstRange.location == NSNotFound)
    {
        [faceArray addObject:content];
        return faceArray;
    }
    else
    {
        NSString *string = [content substringToIndex:firstRange.location];
        NSString *face = [content substringWithRange:firstRange];
        if (string.length > 0)
        {
            [faceArray addObject:string];
        }
        if (face.length > 0)
        {
            [faceArray addObject:face];
        }
        
        NSString *lastString = [content substringFromIndex:(firstRange.location + firstRange.length)];
        if (lastString.length > 0)
        {
            [self returnArrayByContent:lastString];
        }
        else
        {
        }
        return faceArray;
    }
}
@end
