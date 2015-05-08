//
//  SLConnectionURL.h
//  TaskOffer
//
//  Created by wshaolin on 15/3/24.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLHTTPServerHandler.h"

// 1.人脉列表
#define API_CONNECTION_LIST_URL [NSString stringWithFormat:@"%@/toserver/app/serverAppUser/getAllUserList", SLHTTPServerAddressHeader]

// 2.人脉详情
#define API_CONNECTION_DETAIL_URL [NSString stringWithFormat:@"%@/toserver/app/serverAppUser/getInfo", SLHTTPServerAddressHeader]

// 3.人脉详情-项目列表
#define API_CONNECTION_DETAIL_PROJECT_LIST_URL [NSString stringWithFormat:@"%@/toserver/app/project/getAllProjectList", SLHTTPServerAddressHeader]

// 4.项目详情
#define API_CONNECTION_PROJECT_DETAIL_URL [NSString stringWithFormat:@"%@/toserver/app/project/getProjectInfo", SLHTTPServerAddressHeader]

// 5.人脉详情-案例列表
#define API_CONNECTION_CASE_LIST_URL [NSString stringWithFormat:@"%@/toserver/app/cases/getAllCaseList", SLHTTPServerAddressHeader]

// 6.案例详情
#define API_CONNECTION_CASE_DETAIL_URL [NSString stringWithFormat:@"%@/toserver/app/cases/getCaseInfo", SLHTTPServerAddressHeader]

// 7.收藏的案例列表
#define API_CONNECTION_COLLECTION_CASE_LIST_URL [NSString stringWithFormat:@"%@/toserver/app/cases/getCollectList", SLHTTPServerAddressHeader]

// 8.收藏案例
#define API_CONNECTION_COLLECT_CASE_URL [NSString stringWithFormat:@"%@/toserver/app/cases/collect", SLHTTPServerAddressHeader]

// 9.取消收藏
#define API_CONNECTION_CANCEL_COLLECTION_URL [NSString stringWithFormat:@"%@/toserver/app/serverAppUser/cancelCollect", SLHTTPServerAddressHeader]

// 10.发布案例
#define API_CONNECTION_PUBLISH_CASE_URL [NSString stringWithFormat:@"%@/toserver/app/cases/addCase", SLHTTPServerAddressHeader]

// 11.修改案例（或删除）
#define API_CONNECTION_MODIFY_CASE_URL [NSString stringWithFormat:@"%@/toserver/app/cases/modify", SLHTTPServerAddressHeader]

// 12.上传图片
#define API_CONNECTION_UPLOAD_IMAGE_URL [NSString stringWithFormat:@"%@/toserver/common/fileUpload/uploadMorePicture", SLHTTPServerAddressHeader]

// 13.查询价格、规模字典项
#define API_CONNECTION_SYSTEM_DICTIONARY_OPTION_URL [NSString stringWithFormat:@"%@/toserver/dic/getAllDictionaryByParentId", SLHTTPServerAddressHeader]

// 14.是否允许陌生人发起聊天
#define API_CONNECTION_ALLOW_CHAT_WITH_STRANGER_URL [NSString stringWithFormat:@"%@/toserver/app/serverAppUser/getChatStatus", SLHTTPServerAddressHeader]

// 15.查询企业认证员工
#define API_CONNECTION_COMPANY_AUTHENTICATION_EMPLOYEE_URL [NSString stringWithFormat:@"%@/toserver/app/serverCompany/getUsersList", SLHTTPServerAddressHeader]

// 16.获取所有标签
#define API_CONNECTION_ALL_TAGS_URL [NSString stringWithFormat:@"%@/toserver/app/label/findAllAvailable", SLHTTPServerAddressHeader]
