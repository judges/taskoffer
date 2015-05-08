//
//  XMPPFileHelper.m
//  XMPPIM
//
//  Created by BourbonZ on 15/1/23.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "XMPPFileHelper.h"
#import "XMPPDataHelper.h"
static XMPPFileHelper *_helper;
@implementation XMPPFileHelper

+(XMPPFileHelper *)shared
{
    @synchronized(self)
    {
        if (_helper == nil)
        {
            _helper = [[XMPPFileHelper alloc] init];
        }
        return _helper;
    }
}

-(void)checkServerProxy
{
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" elementID:[XMPPStream generateUUID]];
    [iq addAttributeWithName:@"from" stringValue:kDefaultJID.bare];
    [iq addAttributeWithName:@"to" stringValue:kDOMAIN];
    DDXMLElement *query = [DDXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"];
    [iq addChild:query];
    [[[XMPPDataHelper shareHelper] xmppStream] sendElement:iq];
}

#pragma mark 私有方法
-(void)_serverProxy:(NSArray *)proxyArray
{
    NSMutableArray *itemArray = [NSMutableArray array];
    for (XMPPJID *jid in proxyArray)
    {
        [itemArray addObject:jid.description];
    }
    [TURNSocket setProxyCandidates:itemArray];
    XMPPJID *jid = [XMPPJID jidWithUser:@"888" domain:kDOMAIN resource:kRESOURCE];
    TURNSocket *socket = [[TURNSocket alloc] initWithStream:[[XMPPDataHelper shareHelper] xmppStream] toJID:jid];
    [socket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}
#pragma mark 代理方法
-(void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket
{
    DLog(@"%@",sender.description);
}
-(void)turnSocketDidFail:(TURNSocket *)sender
{
    DLog(@"%@",sender.description);
}
@end
