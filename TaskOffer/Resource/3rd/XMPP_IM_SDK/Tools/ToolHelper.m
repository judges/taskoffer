//
//  ToolHelper.m
//  rndIM
//
//  Created by BourbonZ on 14/12/10.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "ToolHelper.h"
#import <AddressBook/AddressBook.h>
#include "pinyin.h"
@implementation ToolHelper

+(NSMutableDictionary *)allPhoneDict
{
    //取得本地通信录名柄
    
    ABAddressBookRef tmpAddressBook = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        tmpAddressBook =ABAddressBookCreate();
    }
    //取得本地所有联系人记录
    
    
    if (tmpAddressBook==nil) {
        return nil;
    };
    NSArray* tmpPeoples = (NSArray*)CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(tmpAddressBook));
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for(id tmpPerson in tmpPeoples)
        
    {
        
        //获取的联系人单一属性:First name
        
        NSString* tmpFirstName = (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonFirstNameProperty));
        if (tmpFirstName == nil)
        {
            tmpFirstName = @"";
        }
//        NSLog(@"First name:%@", tmpFirstName);
        
        //获取的联系人单一属性:Last name
        
        NSString* tmpLastName = (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonLastNameProperty));
        if (tmpLastName == nil)
        {
            tmpLastName = @"";
        }
//        NSLog(@"Last name:%@", tmpLastName);
        
        NSString *name = [tmpLastName stringByAppendingString:tmpFirstName];
        if (name == nil)
        {
            name = @"";
        }
        
        //获取的联系人单一属性:Generic phone number
        
        ABMultiValueRef tmpPhones = ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonPhoneProperty);
        
//        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
//            
//        {
        
        NSString* tmpPhoneIndex = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(tmpPhones, 0));
        if (tmpPhoneIndex == nil)
        {
            tmpPhoneIndex = @"";
        }
        [tmpPhoneIndex stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [tmpPhoneIndex stringByReplacingOccurrencesOfString:@" " withString:@""];
        [tmpPhoneIndex stringByReplacingOccurrencesOfString:@"(" withString:@""];
        [tmpPhoneIndex stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        [dict setObject:name forKey:tmpPhoneIndex];
        
//            NSLog(@"tmpPhoneIndex%d:%@", j, tmpPhoneIndex);
        
            
//        }
        
        CFRelease(tmpPhones);

        
//        //获取的联系人单一属性:Nickname
//        
//        NSString* tmpNickname = (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonNicknameProperty));
//        
//        NSLog(@"Nickname:%@", tmpNickname);
//        
//        
//        //获取的联系人单一属性:Company name
//        
//        NSString* tmpCompanyname = (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonOrganizationProperty));
//        
//        NSLog(@"Company name:%@", tmpCompanyname);
//        
//        
//        //获取的联系人单一属性:Job Title
//        
//        NSString* tmpJobTitle= (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonJobTitleProperty));
//        
//        NSLog(@"Job Title:%@", tmpJobTitle);
//        
//        
//        //获取的联系人单一属性:Department name
//        
//        NSString* tmpDepartmentName = (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonDepartmentProperty));
//        
//        NSLog(@"Department name:%@", tmpDepartmentName);
//        
//        
//        //获取的联系人单一属性:Email(s)
//        
//        ABMultiValueRef tmpEmails = ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonEmailProperty);
//        
//        for(NSInteger j = 0; ABMultiValueGetCount(tmpEmails); j++)
//            
//        {
//            
//            NSString* tmpEmailIndex = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(tmpEmails, j));
//            
//            NSLog(@"Emails%d:%@", j, tmpEmailIndex);
//            
//            
//        }
//        
//        CFRelease(tmpEmails);
//        
//        //获取的联系人单一属性:Birthday
//        
//        NSDate* tmpBirthday = (NSDate*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonBirthdayProperty));
//        
//        NSLog(@"Birthday:%@", tmpBirthday);
//        
//        
//        //获取的联系人单一属性:Note
//        
//        NSString* tmpNote = (NSString*)CFBridgingRelease(ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonNoteProperty));
//        
//        NSLog(@"Note:%@", tmpNote);
    
        
        
    }
    
    //释放内存
    
    
    CFRelease(tmpAddressBook);
    

    NSMutableDictionary *returnDict = [NSMutableDictionary dictionary];
    for (int i = 0 ; i < dict.allKeys.count; i++)
    {
        NSString *value = [[dict allKeys] objectAtIndex:i];
        NSString *key = [dict objectForKey:value];
        value = [value stringByReplacingOccurrencesOfString:@"-" withString:@""];
        value = [value stringByReplacingOccurrencesOfString:@"(" withString:@""];
        value = [value stringByReplacingOccurrencesOfString:@")" withString:@""];
        value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
        [returnDict setObject:key forKey:value];
    }
    
    return returnDict;
}
#pragma mark 设备UUID
+(NSString *)deviceUUID
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    result = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return result;
}
#pragma mark 将联系人数组转换成字典
+(NSDictionary *)arrayToDictionary:(NSArray *)array
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *keyArray         = [NSMutableArray array];
    for (int i = 0; i < array.count; i ++)
    {
        NSString *key = @"";
        FriendUserInfo *object = [array objectAtIndex:i];
        NSString *name                        = [[XMPPRosterHelper sharedHelper] remarkNameOrNickNameForFriend:[object userID]];
        NSString *index                       = [name substringToIndex:1];
        NSString *tmp = @"qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
        NSString *num = @"1234567890";
        if ([tmp rangeOfString:index].location != NSNotFound)
        {
            [keyArray addObject:index];
            key = index;
        }
        else if ([num rangeOfString:index].location != NSNotFound)
        {
            [keyArray addObject:@"#"];
            key = @"#";
        }
        else
        {
            unichar first                            = pinyinFirstLetter([name characterAtIndex:0]);
            [keyArray addObject:[NSString stringWithFormat:@"%c",first]];
            key = [NSString stringWithFormat:@"%c",first];
        }
        
        NSMutableArray *valueArray = [mutableDict objectForKey:key];
        if (valueArray == nil)
        {
            valueArray = [NSMutableArray array];
        }
        [valueArray addObject:object];
        
        [mutableDict setObject:valueArray forKey:key];
        
    }
    
    NSArray *tmpArray = [[mutableDict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
       
        return [obj1 compare:obj2];
        
    }];
    
    NSMutableDictionary *tmpDict     = [NSMutableDictionary dictionary];

    for (NSString *key in tmpArray)
    {
        [tmpDict setObject:[mutableDict objectForKey:key] forKey:key];
    }
    
    return [tmpDict copy];
}
+(void)sendDeviceToken
{
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    if (tokenStr.length == 0)
    {
        return;
    }
    
    
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tokenStr = [tokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    XMPPIQ *iq = [[XMPPIQ alloc] init];
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    NSString *userName = [kDefaultJID.user stringByAppendingFormat:@"@%@",kDOMAIN];
    [iq addAttributeWithName:@"from" stringValue:userName];
    DDXMLElement *node = [[DDXMLElement alloc] initWithName:@"bind" xmlns:@"rndchina"];
    DDXMLElement *token = [[DDXMLElement alloc] initWithName:@"deviceToken" stringValue:tokenStr];
    [node insertChild:token atIndex:0];
    [iq insertChild:node atIndex:0];
    
    [[[XMPPDataHelper shareHelper] xmppStream] sendElement:iq];
    
}
@end
