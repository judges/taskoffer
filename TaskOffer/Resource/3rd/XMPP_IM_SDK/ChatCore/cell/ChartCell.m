//
//  ChartCell.m
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import "ChartCell.h"
#import "XMPPHelper.h"
#import "UIImageView+WebCache.h"
@interface ChartCell()<ChartContentViewDelegate>
@end

@implementation ChartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.icon=[[UIImageView alloc]init];
        
        UITapGestureRecognizer *clickIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIcon)];
        self.icon.userInteractionEnabled  = YES;
        [self.icon addGestureRecognizer:clickIcon];
        
        self.icon.layer.cornerRadius = 10.0;
        self.icon.layer.masksToBounds = NO;
        [self.contentView addSubview:self.icon];
        self.chartView =[[ChartContentView alloc]initWithFrame:CGRectZero];
        self.chartView.delegate=self;
        [self.contentView addSubview:self.chartView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:12.0f];
        self.nameLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}
-(void)setCellFrame:(ChartCellFrame *)cellFrame
{
    _cellFrame=cellFrame;
    
    ChartMessage *chartMessage=cellFrame.chartMessage;
    
    self.icon.frame=cellFrame.iconRect;
    self.icon.image=chartMessage.icon;
    
    self.nameLabel.frame = cellFrame.nameRect;
    self.nameLabel.text = chartMessage.name;
    if (cellFrame.chartMessage.messageType == kMessageFrom)
    {
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
    }
    else
    {
        self.nameLabel.text = [[UserInfo sharedInfo] userName];
        [self.nameLabel setTextAlignment:NSTextAlignmentRight];
    }

   
    self.chartView.chartMessage=chartMessage;
    self.chartView.frame=cellFrame.chartViewRect;
    [self setBackGroundImageViewImage:self.chartView from:@"chatfrom_bg_normal.png" to:@"chatto_bg_normal.png"];
    self.chartView.contentLabel.text=chartMessage.content;
    
    if (self.chartView.faceView.subviews.count != 0)
    {
        for (UIView *tmp in self.chartView.faceView.subviews)
        {
            [tmp removeFromSuperview];
        }
    }

    NSURL *url = [NSURL URLWithString:chartMessage.content];
    
    NSDictionary *_tmpDict = [NSJSONSerialization JSONObjectWithData:[chartMessage.content dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
   
    
    if ([[UIApplication sharedApplication] canOpenURL:url] || [[_tmpDict objectForKey:@"type"] intValue] == 1 || [[_tmpDict objectForKey:@"type"] intValue] == 2)
    {
        self.chartView.itemView.hidden = YES;
        [self receiveMediaWithChartMessage:chartMessage withCellFrame:cellFrame];
    }
    else
    {
        [self.chartView.picView setImage:nil];
        
        SeparateByArray *separate = [SeparateByArray shared];
        NSString *content = chartMessage.content;

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[chartMessage.content dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
        if (dict != nil)
        {
            content = [dict objectForKey:@"content"];
            NSString *type = [dict objectForKey:@"type"];
            if (type.intValue != 0)
            {
                //1是图片，2是语音
                self.chartView.itemView.hidden = YES;
                [self receiveMediaWithChartMessage:chartMessage withCellFrame:cellFrame];
                return;
            }
        }
        
        UIView *face = [separate retrunSeparateViewByContent:content];

        [self.chartView.faceView addSubview:face];
        [self.chartView setFrame:CGRectMake(cellFrame.chartViewRect.origin.x, cellFrame.chartViewRect.origin.y, face.frame.size.width+40, cellFrame.chartViewRect.size.height)];
#pragma mark 穿插着表情
        
        if ([chartMessage.itemType isEqualToString:kProject] ||
            [chartMessage.itemType isEqualToString:kCard] ||
            [chartMessage.itemType isEqualToString:kCase] ||
            [chartMessage.itemType isEqualToString:kCompany])
        {
            self.chartView.itemView.hidden = NO;

            self.chartView.itemView.itemContentLabel.text = chartMessage.itemContent;
            self.chartView.itemView.itemNameLabel.text = chartMessage.itemName;
            [self.chartView.itemView.itemPicView sd_setImageWithURL:[NSURL URLWithString:chartMessage.itemPicPath] placeholderImage:kDefaultIcon];
            if ([chartMessage.itemType isEqualToString:kProject])
            {
                self.chartView.itemView.itemTypeLabel.text = @"项目";
            }
            else if ([chartMessage.itemType isEqualToString:kCard])
            {
                self.chartView.itemView.itemTypeLabel.text = @"名片";
            }
            else if ([chartMessage.itemType isEqualToString:kCase])
            {
                self.chartView.itemView.itemTypeLabel.text = @"案例";
            }
            else if ([chartMessage.itemType isEqualToString:kCompany])
            {
                self.chartView.itemView.itemTypeLabel.text = @"企业号";
            }
            [self.chartView.itemView setFrame:CGRectMake(0, 0, self.frame.size.width-100, 65)];
            if (chartMessage.messageType == kMessageTo)
            {
                if (iPhone4S)
                {
                    [self.chartView.itemView setFrame:CGRectMake(-180, 0, self.frame.size.width-100, 65)];
                }
                else if (iPhone5)
                {
                    [self.chartView.itemView setFrame:CGRectMake(-180, 0, self.frame.size.width-100, 65)];
                }
                else if (iPhone6)
                {
                    [self.chartView.itemView setFrame:CGRectMake(-240, 0, self.frame.size.width-100, 65)];
                }
                else
                {
                    [self.chartView.itemView setFrame:CGRectMake(-279, 0, self.frame.size.width-100, 65)];
                }
            }
            [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)]];
        }
        else
        {
            self.chartView.itemView.hidden = YES;
        }
    }
}
///接收到的是多媒体
-(void)receiveMediaWithChartMessage:(ChartMessage *)chartMessage withCellFrame:(ChartCellFrame *)cellFrame
{
    NSDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:[chartMessage.content dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableLeaves) error:nil];
    NSString *content = [contentDict objectForKey:@"content"];
    NSString *lastStr = [content pathExtension];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:chartMessage.content]])
    {
        content = chartMessage.content;
        lastStr = [content pathExtension];
    }
    if ([lastStr isEqualToString:@"wav"] || [lastStr isEqualToString:@"amr"])
    {
        
        NSString *duration = [NSString stringWithFormat:@"%@s",chartMessage.audioDuration];
        SeparateByArray *separate = [SeparateByArray shared];
        UIView *face = [separate retrunSeparateViewByContent:duration];
        [self.chartView.picView setImage:nil];
        [self.chartView.faceView addSubview:face];
        self.chartView.soundWaveImg.hidden = NO;
        
        if (self.chartView.chartMessage.messageType == kMessageFrom)
        {
            CGRect tmpRect = CGRectMake(self.chartView.faceView.frame.origin.x + self.chartView.soundWaveImg.frame.size.width + self.chartView.soundWaveImg.frame.origin.x, self.chartView.faceView.frame.origin.y+3, self.chartView.faceView.frame.size.width, self.chartView.faceView.frame.size.height);
            [self.chartView.faceView setFrame:tmpRect];
        }
        else
        {
            [self.chartView.faceView setFrame:CGRectMake(self.chartView.faceView.frame.origin.x, self.chartView.faceView.frame.origin.y + 5, self.chartView.faceView.frame.size.width, self.chartView.faceView.frame.size.height)];
        }
        
    }
    else if ([lastStr isEqualToString:@"jpg"] ||
             [lastStr isEqualToString:@"png"] ||
             [lastStr isEqualToString:@"jpeg"] ||
             [lastStr isEqualToString:@"tmp"])
    {
        [self.chartView.picView setFrame:CGRectMake(self.chartView.contentLabel.frame.origin.x, self.chartView.contentLabel.frame.origin.y, 50, 50)];
        
        [self.chartView.picView sd_setImageWithURL:[NSURL URLWithString:content]
                                  placeholderImage:[UIImage imageNamed:@"发送名片.png"]
                                           options:(SDWebImageRetryFailed)
                                          progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
         } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             NSString *fileName = [[NSString stringWithFormat:@"%@",imageURL] substringFromIndex:[[NSString stringWithFormat:@"%@",imageURL] rangeOfString:kFILEHOST].length];
             NSData *data = UIImageJPEGRepresentation(image, 1);
             NSString *name = [[fileName componentsSeparatedByString:@"/"] lastObject];
             NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",name];
             if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
             {
                 [data writeToFile:filePath atomically:YES];
             }
             
             float defaultX = 100.0f;
             float defaultY = 100.0f;
             float imageX = defaultX;
             float imageY = defaultY;
             
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
                 imageX = 140;
                 imageY = 140;
             }
             [self.chartView.picView setFrame:CGRectMake(self.chartView.contentLabel.frame.origin.x, self.chartView.contentLabel.frame.origin.y, imageX, imageY)];
             self.chartView.frame=CGRectMake(cellFrame.chartViewRect.origin.x+50, cellFrame.chartViewRect.origin.y, imageX, imageY);
             if (self.chartView.chartMessage.messageType == kMessageFrom)
             {
                 self.chartView.frame=CGRectMake(cellFrame.chartViewRect.origin.x, cellFrame.chartViewRect.origin.y, imageX, imageY);
             }
             
             if (self.delegate != nil && [self.delegate respondsToSelector:@selector(reloadCellInputView:)])
             {
                 [self.delegate reloadCellInputView:self];
             }
         }];
    }
    if (self.chartView.chartMessage.messageType == kMessageTo)
    {
        CGRect rect = CGRectMake(self.chartView.frame.origin.x+50, self.chartView.frame.origin.y, self.chartView.frame.size.width, self.chartView.frame.size.height);
        [self.chartView setFrame:rect];
    }

}
-(void)setBackGroundImageViewImage:(ChartContentView *)chartView from:(NSString *)from to:(NSString *)to
{
    UIImage *normal=nil ;
    if(chartView.chartMessage.messageType==kMessageFrom){
        
        normal = [UIImage imageNamed:from];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        
    }else if(chartView.chartMessage.messageType==kMessageTo){
        
        normal = [UIImage imageNamed:to];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
    }
    chartView.backImageView.image=normal;
}
-(void)chartContentViewLongPress:(ChartContentView *)chartView content:(NSString *)content
{
    [self becomeFirstResponder];

    UIMenuController *menu=[UIMenuController sharedMenuController];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(clickCopyItem:)];
    UIMenuItem *deleItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(clickDeleItem:)];
    UIMenuItem *editItem = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(clickEditItem:)];
    
    if (chartView.picView.image != nil)
    {
        ///这是一张图片
        [menu setMenuItems:@[deleItem,editItem]];
    }
    else if (chartView.chartMessage.audioDuration.integerValue > 0)
    {
        ///这是一条语音
        [menu setMenuItems:@[deleItem,editItem]];
    }
    else
    {
        [menu setMenuItems:@[copyItem,deleItem,editItem]];
    }
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuHide:) name:UIMenuControllerWillHideMenuNotification object:nil];
    self.contentStr=content;
    self.currentChartView=chartView;
}
-(void)chartContentViewTapPress:(ChartContentView *)chartView content:(NSString *)content
{
    if([self.delegate respondsToSelector:@selector(chartCell:tapContent:)]){
    
    
        [self.delegate chartCell:self tapContent:content];
    }
}
-(void)menuShow:(UIMenuController *)menu
{
    [self setBackGroundImageViewImage:self.currentChartView from:@"chatfrom_bg_focused.png" to:@"chatto_bg_focused.png"];
}
-(void)menuHide:(UIMenuController *)menu
{
    [self setBackGroundImageViewImage:self.currentChartView from:@"chatfrom_bg_normal.png" to:@"chatto_bg_normal.png"];
    self.currentChartView=nil;
    [self resignFirstResponder];
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action ==@selector(clickCopyItem:) ||
       action == @selector(clickEditItem:) ||
       action == @selector(clickDeleItem:)){

        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)clickCopyItem:(id)sender
{
    [[UIPasteboard generalPasteboard]setString:self.contentStr];
}
-(void)clickDeleItem:(id)sender
{
#pragma mark 点击删除按钮
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickDeteItemWithLongPress:)])
    {
        [self.delegate clickDeteItemWithLongPress:self];
    }
}
-(void)clickEditItem:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickEditItemWithLongPress:)])
    {
        [self.delegate clickEditItemWithLongPress:self];
    }
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)clickIcon
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickChatIcon:)])
    {
        [self.delegate clickChatIcon:self];
    }
}
#pragma mark 点击事件
-(void)clickItem:(UITapGestureRecognizer *)tapge
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickChartItem:taoContentID:andType:)])
    {
        [self.delegate clickChartItem:self taoContentID:self.chartView.chartMessage.itemID andType:self.chartView.chartMessage.itemType];
    }
}
@end
