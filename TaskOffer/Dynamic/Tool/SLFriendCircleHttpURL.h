//
//  SLFriendCircleHttpURL.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/17.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLHTTPServerHandler.h"

// 1.朋友圈
#define API_FRIEND_CIRCLE_STATUS_ALL_LIST_URL [NSString stringWithFormat:@"%@/plugins/rdService/info/friendinfos", SLDynamicHTTPServerAddressHeader]

// 2.个人相册
#define API_FRIEND_CIRCLE_STATUS_PERSON_LIST_URL [NSString stringWithFormat:@"%@/plugins/rdService/info/myInfos", SLDynamicHTTPServerAddressHeader]

// 3.发布消息
#define API_FRIEND_CIRCLE_STATUS_SEND_URL [NSString stringWithFormat:@"%@/plugins/rdService/info/create", SLDynamicHTTPServerAddressHeader]

// 4.删除消息
#define API_FRIEND_CIRCLE_STATUS_DELETE_URL [NSString stringWithFormat:@"%@/plugins/rdService/info/delete", SLDynamicHTTPServerAddressHeader]

// 5.评论消息
#define API_FRIEND_CIRCLE_STATUS_COMMENT_URL [NSString stringWithFormat:@"%@/plugins/rdService/info/comment", SLDynamicHTTPServerAddressHeader]

// 6.点赞
#define API_FRIEND_CIRCLE_STATUS_LIKE_URL [NSString stringWithFormat:@"%@/plugins/rdService/info/like", SLDynamicHTTPServerAddressHeader]

// 8.状态详情
#define API_FRIEND_CIRCLE_STATUS_DETAIL_URL [NSString stringWithFormat:@"%@/plugins/rdService/info/detail", SLDynamicHTTPServerAddressHeader]

// 9.取消点赞
#define API_FRIEND_CIRCLE_STATUS_CANCEL_LIKE_URL [NSString stringWithFormat:@"%@/plugins/rdService/info/cancelLike", SLDynamicHTTPServerAddressHeader]

// 10.是否有的新的好友动态
#define API_FRIEND_CIRCLE_STATUS_NEW_URL [NSString stringWithFormat:@"%@/plugins/rdService/info/refresh", SLDynamicHTTPServerAddressHeader]
