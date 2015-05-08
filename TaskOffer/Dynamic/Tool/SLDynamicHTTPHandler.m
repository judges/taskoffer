//
//  SLDynamicHTTPHandler.m
//  TaskOffer
//
//  Created by wshaolin on 15/4/7.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLDynamicHTTPHandler.h"
#import "SLFriendCircleHttpURL.h"
#import "NSDictionary+NullFilter.h"
#import "SLFriendCircleStatusModel.h"
#import "SLFriendCircleStatusFrameModel.h"
#import "SLFriendCirclePersonStatusFrameModel.h"
#import "SLNetworkMonitorHandler.h"
#import "SLFriendCircleSQLiteHandler.h"
#import "MBProgressHUD+Conveniently.h"
#import "SLHTTPHandler.h"

@implementation SLDynamicHTTPHandler

+ (void)GETWithURL:(NSString *)url parameters:(NSDictionary *)parameters showProgressInView:(UIView *)view isHideProgress:(BOOL)isHideProgress success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    [SLHTTPHandler GETWithURL:url parameters:parameters showProgressInView:view isHideProgress:isHideProgress success:^(NSDictionary *dataDictionary) {
        if(success){
            success(dataDictionary);
        }
    } failure:^(NSError *error) {
        if(failure){
            if(error.code == kSLHTTPHandlerRequestFailureCustomCode){
                failure([error.userInfo stringForKey:kSLHTTPHandlerRequestFailureCustomUserInfoKey]);
            }else{
                failure([error localizedDescription]);
            }
        }
    }];
}

+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters isHideProgress:(BOOL)isHideProgress showProgressInView:(UIView *)view success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    [SLHTTPHandler POSTWithURL:url parameters:parameters showProgressInView:view isHideProgress:isHideProgress success:^(NSDictionary *dataDictionary) {
        if(success){
            success(dataDictionary);
        }
    } failure:^(NSError *error) {
        if(failure){
            if(error.code == kSLHTTPHandlerRequestFailureCustomCode){
                failure([error.userInfo stringForKey:kSLHTTPHandlerRequestFailureCustomUserInfoKey]);
            }else{
                failure([error localizedDescription]);
            }
        }
    }];
}

+ (void)POSTWithURL:(NSString *)url parameters:(NSDictionary *)parameters imageDatas:(NSArray *)imageDatas isHideProgress:(BOOL)isHideProgress showProgressInView:(UIView *)view success:(void (^)(NSDictionary *))success failure:(void (^)(NSString *))failure{
    [SLHTTPHandler POSTWithURL:url parameters:parameters datas:imageDatas showProgressInView:view isHideProgress:isHideProgress success:^(NSDictionary *dataDictionary) {
        if(success){
            success(dataDictionary);
        }
    } failure:^(NSError *error) {
        if(failure){
            if(error.code == kSLHTTPHandlerRequestFailureCustomCode){
                failure([error.userInfo stringForKey:kSLHTTPHandlerRequestFailureCustomUserInfoKey]);
            }else{
                failure([error localizedDescription]);
            }
        }
    }];
}

#pragma -mark 朋友圈列表

+ (void)POSTFriendCircleAllMessageListWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure{
    //    NSInteger pageNumber = [parameters integerForKey:@"pageNum"];
    //    NSArray *dataArray = nil;
    //    if(pageNumber > 1){
    //        dataArray = [SLFriendCircleSQLiteHandler statusFrameModelsWithParameters:parameters];
    //    }
    //
    //    if(dataArray != nil && dataArray.count > 0){
    //        if(success){
    //            success(dataArray);
    //        }
    //        return;
    //    }
    
    [self POSTWithURL:API_FRIEND_CIRCLE_STATUS_ALL_LIST_URL parameters:parameters isHideProgress:YES showProgressInView:view success:^(NSDictionary *dataDictionary) {
        if(success){
            NSArray *dataArray = [dataDictionary arrayForKey:@"data"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for(NSDictionary *dictionary in dataArray){
                SLFriendCircleStatusModel *friendCircleStatusModel = [SLFriendCircleStatusModel modelWithDictionary:dictionary];
                // 缓存数据
                // [SLFriendCircleSQLiteHandler insertWithStatusModel:friendCircleStatusModel];
                SLFriendCircleStatusFrameModel *friendCircleStatusFrameModel = [[SLFriendCircleStatusFrameModel alloc] initWithFriendCircleStatusModel:friendCircleStatusModel];
                [tempArray addObject:friendCircleStatusFrameModel];
            }
            success([tempArray copy]);
        }
    } failure:^(NSString *failureMessage) {
        if(failure){
            failure(failureMessage);
        }
    }];
}

#pragma -mark 朋友圈（个人）

+ (void)POSTFriendCirclePersonMessageListWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(NSArray *))success failure:(void (^)(NSString *))failure{
    //    NSInteger pageNumber = [parameters integerForKey:@"pageNum"];
    //    NSArray *dataArray = nil;
    //    if(pageNumber > 1){
    //        dataArray = [SLFriendCircleSQLiteHandler personFrameStatusModelsWithParameters:parameters];
    //    }
    //
    //    if(dataArray != nil && dataArray.count > 0){
    //        if(success){
    //            success(dataArray);
    //        }
    //        return;
    //    }
    
    [self POSTWithURL:API_FRIEND_CIRCLE_STATUS_PERSON_LIST_URL parameters:parameters isHideProgress:YES showProgressInView:view success:^(NSDictionary *dataDictionary) {
        if(success){
            NSArray *dataArray = [dataDictionary arrayForKey:@"data"];
            NSDictionary *rdinfoDictionary = [dataArray firstObject];
            NSArray *array = [rdinfoDictionary arrayForKey:@"rdinfo"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for(NSDictionary *dictionary in array){
                SLFriendCircleStatusModel *friendCircleStatusModel = [SLFriendCircleStatusModel modelWithDictionary:dictionary];
                // 缓存数据
                // [SLFriendCircleSQLiteHandler insertWithStatusModel:friendCircleStatusModel];
                SLFriendCirclePersonStatusFrameModel *friendCirclePersonStatusFrameModel = [[SLFriendCirclePersonStatusFrameModel alloc] initWithFriendCircleStatusModel:friendCircleStatusModel];
                [tempArray addObject:friendCirclePersonStatusFrameModel];
            }
            success([tempArray copy]);
        }
    } failure:^(NSString *failureMessage) {
        if(failure){
            failure(failureMessage);
        }
        [MBProgressHUD showWithError:@"数据加载失败"];
    }];
}

#pragma -mark 发布状态

+ (void)POSTFriendCircleSendMessageWithParameters:(NSDictionary *)parameters imageDatas:(NSArray *)imageDatas showProgressInView:(UIView *)view success:(void (^)(void))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_FRIEND_CIRCLE_STATUS_SEND_URL parameters:parameters imageDatas:imageDatas isHideProgress:YES showProgressInView:view success:^(NSDictionary *dataDictionary) {
        if(success){
            success();
        }
    } failure:^(NSString *failureMessage) {
        if(failure){
            failure(failureMessage);
        }
    }];
}

#pragma -mark 点赞

+ (void)POSTFriendCircleApplaudWithParameters:(NSDictionary *)parameters isCancel:(BOOL)cancel showProgressInView:(UIView *)view success:(void (^)(void))success failure:(void (^)(NSString *))failure{
    
    NSString *url = API_FRIEND_CIRCLE_STATUS_LIKE_URL;
    if(cancel){
        url = API_FRIEND_CIRCLE_STATUS_CANCEL_LIKE_URL;
    }
    
    [self POSTWithURL:url parameters:parameters isHideProgress:YES showProgressInView:view success:^(NSDictionary *dataDictionary) {
        if(success){
            success();
        }
    } failure:^(NSString *failureMessage) {
        if(failure){
            failure(failureMessage);
        }
    }];
}

#pragma -mark 评论

+ (void)POSTFriendCircleCommentWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(SLFriendCircleStatusCommentModel *))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_FRIEND_CIRCLE_STATUS_COMMENT_URL parameters:parameters isHideProgress:YES showProgressInView:view success:^(NSDictionary *dataDictionary) {
        if(success){
            NSDictionary *dictionary = [dataDictionary dictionaryForKey:@"data"];
            SLFriendCircleStatusCommentModel *statusCommentModel = [[SLFriendCircleStatusCommentModel alloc] initWithDictionary:dictionary];
            success(statusCommentModel);
        }
    } failure:^(NSString *failureMessage) {
        if(failure){
            failure(failureMessage);
        }
    }];
}

#pragma -mark 删除状态

+ (void)POSTFriendCircleDeleteStatusWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(void))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_FRIEND_CIRCLE_STATUS_DELETE_URL parameters:parameters isHideProgress:NO showProgressInView:view success:^(NSDictionary *dataDictionary) {
        if(success){
            success();
        }
    } failure:^(NSString *failureMessage) {
        if(failure){
            failure(failureMessage);
        }
    }];
}

#pragma -mark 状态详情

+ (void)POSTFriendCircleStatusDetailWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(SLFriendCircleStatusModel *))success failure:(void (^)(NSString *))failure{
    //    // 如果网络不可用，取缓存数据
    //    if(![SLNetworkMonitorHandler sharedMonitorHandler].isAvailableNetwork){
    //        NSString *statusId = [parameters stringForKey:@"infoId"];
    //        SLFriendCircleStatusModel *friendCircleStatusModel = [SLFriendCircleSQLiteHandler statusModelWithId:statusId];
    //        if(friendCircleStatusModel != nil){
    //            if(success){
    //                success(friendCircleStatusModel);
    //            }
    //            return;
    //        }
    //    }
    
    [self POSTWithURL:API_FRIEND_CIRCLE_STATUS_DETAIL_URL parameters:parameters isHideProgress:NO showProgressInView:view success:^(NSDictionary *dataDictionary) {
        NSDictionary *dictionary = [[dataDictionary arrayForKey:@"data"] firstObject];
        if(success && dictionary != nil && [dictionary isKindOfClass:[NSDictionary class]]){
            SLFriendCircleStatusModel *friendCircleStatusModel = [SLFriendCircleStatusModel modelWithDictionary:dictionary];
            // [SLFriendCircleSQLiteHandler insertWithStatusModel:friendCircleStatusModel];
            success(friendCircleStatusModel);
        }else{
            if(failure){
                [MBProgressHUD showWithError:@"数据错误"];
                failure(@"数据错误");
            }
        }
    } failure:^(NSString *failureMessage) {
        if(failure){
            failure(failureMessage);
        }
    }];
}

#pragma -mark 是否有好友的新动态

+ (void)POSTFriendCircleHasNewRefreshStatusWithParameters:(NSDictionary *)parameters showProgressInView:(UIView *)view success:(void (^)(BOOL))success failure:(void (^)(NSString *))failure{
    [self POSTWithURL:API_FRIEND_CIRCLE_STATUS_NEW_URL parameters:parameters isHideProgress:YES showProgressInView:view success:^(NSDictionary *dataDictionary) {
        if(success){
            success([dataDictionary boolForKey:@"data"]);
        }
    } failure:^(NSString *failureMessage) {
        if(failure){
            failure(failureMessage);
        }
    }];
}

@end
