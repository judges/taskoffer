//
//  ChartCellFrame.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#define kIconMarginX 5
#define kIconMarginY 5

#import "ChartCellFrame.h"
#import "SeparateByArray.h"
#import "XMPPIM-Prefix.pch"
@implementation ChartCellFrame

-(void)setChartMessage:(ChartMessage *)chartMessage
{
    _chartMessage=chartMessage;
    
    CGSize winSize=[UIScreen mainScreen].bounds.size;
    CGFloat iconX=kIconMarginX;
    CGFloat iconY=kIconMarginY;
    CGFloat iconWidth=40;
    CGFloat iconHeight=40;
    
    if(chartMessage.messageType==kMessageFrom){
      
    }else if (chartMessage.messageType==kMessageTo){
        iconX=winSize.width-kIconMarginX-iconWidth;
    }
    self.iconRect=CGRectMake(iconX, iconY, iconWidth, iconHeight);
    
    
    CGFloat contentX=CGRectGetMaxX(self.iconRect)+kIconMarginX;
    CGFloat contentY=iconY;
    CGSize contentSize = CGSizeZero;
    
    NSDictionary *_tmpDict = [NSJSONSerialization JSONObjectWithData:[chartMessage.content dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
    
    if ([chartMessage.content rangeOfString:kFILEHOST].location != NSNotFound || [[_tmpDict objectForKey:@"type"] intValue] == 1 || [[_tmpDict objectForKey:@"type"] intValue] == 2)
    {
        //多媒体,图片或语音
        NSString *content = chartMessage.content;
        if (_tmpDict != nil)
        {
            content = [_tmpDict objectForKey:@"content"];
        }
        
        NSString *lastStr = [content pathExtension];
        if ([lastStr isEqualToString:@"wav"] || [lastStr isEqualToString:@"amr"])
        {
            NSDictionary *dict = [chartMessage dict];
            NSNumber *number = [NSNumber numberWithInt:[[dict objectForKey:@"duration"] intValue]];
            if (number.intValue == 0)
            {
                number = [chartMessage audioDuration];
            }

            float imageX = 20;
   
            imageX = 10 * number.intValue + imageX;
#pragma mark 动态改变声音条的大小
            if (imageX > 230)
            {
                imageX = 230;
            }
            contentSize = CGSizeMake(imageX, 20);
        }
        else if ([lastStr isEqualToString:@"jpg"] || [lastStr isEqualToString:@"png"])
        {
            float defaultX = 100.0f;
            float defaultY = 100.0f;
            float imageX = defaultX;
            float imageY = defaultY;
            NSString *imageURL = content;
            NSString *fileName = [imageURL substringFromIndex:[imageURL rangeOfString:kFILEHOST].length];
            NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",fileName];
            
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            contentSize = CGSizeMake(150, 100);
            if (image)
            {
                if (image.size.width <= defaultX && image.size.height <= defaultY)
                {
                    
                }
                else if (image.size.width > defaultX && image.size.height <= defaultY)
                {
                    imageX = defaultX;
                    imageY = imageX * defaultY / defaultX;
                }
                else if (image.size.height > defaultY && image.size.width <= defaultX)
                {
                    imageY = defaultY;
                    imageX = imageY * defaultX / defaultY;
                }
                else
                {
                    imageX = 200;
                    imageY = 200;
                }
                contentSize = CGSizeMake(imageX-40, imageY);
            }
        }
        if(chartMessage.messageType==kMessageTo)
        {
            contentX=iconX-kIconMarginX-contentSize.width-iconWidth-iconWidth;
        }

        
    }
    else
    {
        //文字
        SeparateByArray *separate = [SeparateByArray shared];
        NSString *string = chartMessage.content;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        if (dict != nil)
        {
            string = [dict objectForKey:@"content"];
        }
        
        UIView *face = [separate retrunSeparateViewByContent:string];
        contentSize = face.frame.size;
      
        if(chartMessage.messageType==kMessageTo)
        {
            contentX=iconX-kIconMarginX-contentSize.width-iconWidth-iconWidth+45;
        }
    }

    if (chartMessage.messageType == kMessageFrom)
    {
        self.nameRect = CGRectMake(iconX+iconWidth+10, contentY, ([[UIApplication sharedApplication] keyWindow].frame.size.width - 2*iconWidth - 2*iconX), 20);
    }
    else
    {
        self.nameRect = CGRectMake(iconWidth, contentY, ([[UIApplication sharedApplication] keyWindow].frame.size.width-2*iconWidth-20), 20);
    }

    self.chartViewRect=CGRectMake(contentX, contentY+20, contentSize.width+35, contentSize.height+30);
    
    self.cellHeight=MAX(CGRectGetMaxY(self.iconRect), CGRectGetMaxY(self.chartViewRect))+kIconMarginX;
}
@end
