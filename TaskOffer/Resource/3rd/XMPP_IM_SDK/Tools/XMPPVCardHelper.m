//
//  XMPPVCardHelper.m
//  XMPPIM
//
//  Created by BourbonZ on 14/12/30.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "XMPPVCardHelper.h"
#import "XMPPDataHelper.h"
#import "XMPPvCardCoreDataStorageObject.h"

static XMPPVCardHelper *_helper = nil;
@implementation XMPPVCardHelper

+(XMPPVCardHelper *)sharedHelper
{
    @synchronized(self)
    {
        if (_helper == nil)
        {
            _helper = [[XMPPVCardHelper alloc] init];
        }
        return _helper;
    }
}
///获取个人信息
-(XMPPUserInfo *)myInfo
{
    XMPPUserInfo *temp = (XMPPUserInfo *)[[[XMPPDataHelper shareHelper] xmppvCardTempModule] myvCardTemp];
    return temp;
}

///获取某人的个人信息
-(XMPPvCardTemp *)friendVcardWithName:(NSString *)friendName
{
    XMPPJID *jid = [XMPPJID jidWithUser:friendName domain:kDOMAIN resource:kRESOURCE];
    XMPPvCardTemp *temp = [[[XMPPDataHelper shareHelper] xmppvCardTempModule] vCardTempForJID:jid shouldFetch:YES];
    
    return temp;
}

///在线更新某人的信息
//-(void)updateFriendInfo:(XMPPvCardTemp *)temp
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//       
//        NSManagedObjectContext *moc = [[[XMPPDataHelper shareHelper] xmppvCardStorage] mainThreadManagedObjectContext];
//        
//        NSString *entityName = NSStringFromClass([XMPPvCardCoreDataStorageObject class]);
//        
//        XMPPvCardCoreDataStorageObject *vCard = (XMPPvCardCoreDataStorageObject *)[NSEntityDescription insertNewObjectForEntityForName:entityName
//                                                                              inManagedObjectContext:moc];
//        
//        //    vCard.jidStr = [jid bare];
//        vCard.vCardTemp = temp;
//        
//        NSError *error = nil;
//        BOOL success = [moc save:&error];
//        if (!success)
//        {
//            DLog(@"%@",error.localizedDescription);
//            return;
//        }
//        DLog(@"存储失败");
//        
//    });
//}

///从数据库中查找某人信息
-(XMPPvCardInfo *)searchFriendFromDB:(NSString *)friendName
{
    NSManagedObjectContext *context = [[[XMPPDataHelper shareHelper] xmppvCardStorage] mainThreadManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([XMPPvCardCoreDataStorageObject class]) inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSString *sql = [NSString stringWithFormat:@"jidStr = '%@@%@'",friendName,kDOMAIN];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sql];
    [request setPredicate:predicate];
    NSArray *array = [context executeFetchRequest:request error:nil];
    XMPPvCardInfo *object = (XMPPvCardInfo *)[array firstObject];
    
    return object;
}


///修改头像
-(void)changeMyIcon:(UIImage *)icon
{
    NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard" xmlns:
                              @"vcard-temp"];
    NSXMLElement *photoXML = [NSXMLElement elementWithName:@"PHOTO"];
    NSXMLElement *typeXML = [NSXMLElement elementWithName:@"TYPE"
                                              stringValue:@"image/jpeg"];

    NSData *dataFromImage =UIImageJPEGRepresentation(icon, 1.0f);
    NSXMLElement *binvalXML = [NSXMLElement elementWithName:@"BINVAL"
                                                stringValue:[dataFromImage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    [photoXML addChild:typeXML];
    [photoXML addChild:binvalXML];
    [vCardXML addChild:photoXML];
    XMPPvCardTemp *myvCardTemp = [[[XMPPDataHelper shareHelper] xmppvCardTempModule]
                                  myvCardTemp];
    if (myvCardTemp) {
        [myvCardTemp setPhoto:dataFromImage];
        [[[XMPPDataHelper shareHelper] xmppvCardTempModule] updateMyvCardTemp
         :myvCardTemp];
    }
    else{
        XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement
                                       :vCardXML]; 
        [[[XMPPDataHelper shareHelper] xmppvCardTempModule] updateMyvCardTemp
         :newvCardTemp];
    }
}

///修改头像成功
-(void)changeSuccess:(XMPPvCardTempModule *)module
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(myInfoChangeSuccess:)])
        {
            [self.delegate myInfoChangeSuccess:(XMPPUserInfo *)module.myvCardTemp];
        }
    });
}
///修改名字
-(void)changeMyVcard:(NSString *)value byType:(NSString *)type
{
    NSXMLElement *vCardXML = [NSXMLElement elementWithName:@"vCard" xmlns:@"vcard-temp"];
    NSXMLElement *nickXML = [NSXMLElement elementWithName:type stringValue:value];

    [vCardXML addChild:nickXML];
    
    XMPPvCardTemp *myvCardTemp = [[[XMPPDataHelper shareHelper] xmppvCardTempModule] myvCardTemp];
    if (myvCardTemp)
    {
        if ([type isEqualToString:kNickName])
        {
            [myvCardTemp setNickname:value];
        }
        else if ([type isEqualToString:kAdr])
        {
            [myvCardTemp setAddresses:@[value]];
        }
        else if ([type isEqualToString:kNote])
        {
            [myvCardTemp setNote:value];
        }
        else if ([type isEqualToString:kEmail])
        {
            [myvCardTemp setEmailAddresses:@[value]];
        }
        else if ([type isEqualToString:kDesc])
        {
            [myvCardTemp setDesc:value];
        }
        else if ([type isEqualToString:kTel])
        {
            [myvCardTemp setTelecomsAddresses:@[value]];
        }
        
        [[[XMPPDataHelper shareHelper] xmppvCardTempModule] updateMyvCardTemp
         :myvCardTemp];
    }
    else{
        XMPPvCardTemp *newvCardTemp = [XMPPvCardTemp vCardTempFromElement
                                       :vCardXML];
        [[[XMPPDataHelper shareHelper] xmppvCardTempModule] updateMyvCardTemp
         :newvCardTemp];
    }
}

///查找某人的详细信息
-(void)fetchSomeBodyInfo:(NSString *)userName
{
    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:kDOMAIN resource:kRESOURCE];
    [[[XMPPDataHelper shareHelper] xmppvCardTempModule] fetchvCardTempForJID:jid ignoreStorage:YES];
}
-(void)someBodyInfo:(XMPPvCardTemp *)temp andJID:(XMPPJID *)jid
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(fetchSuccessInfo:andJID:)])
        {
            XMPPUserInfo *info = (XMPPUserInfo *)temp;
            [self.delegate fetchSuccessInfo:info andJID:jid];
        }
    });
}
@end
