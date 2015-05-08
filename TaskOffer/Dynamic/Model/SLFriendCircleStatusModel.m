//
//  SLFriendCircleStatusModel.m
//  XMPPIM
//
//  Created by wshaolin on 14/12/17.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SLFriendCircleStatusModel.h"
#import "NSDictionary+NullFilter.h"
#import "NSDate+Conveniently.h"
#import "NSString+Conveniently.h"
#import "NSArray+String.h"
#import "SLHTTPServerHandler.h"
#import "HexColor.h"

@implementation SLFriendCircleStatusModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary{
    return [[self alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValuesForKeysWithDictionary:(NSDictionary *)dictionary{
    _originalDateTime = [dictionary stringForKey:@"createTime"];
    _content = [dictionary stringForKey:@"content"];
    _content = [_content trimWhitespaceAndNewlineCharacterSet];
    _statusId = [dictionary stringForKey:@"id"];
    
    _imageUrls = [dictionary arrayForKey:@"urls"];
    _messageType = [dictionary integerForKey:@"type"];
    
    NSString *username = [dictionary stringForKey:@"username"];
    NSString *iconURL = SLHTTPServerImageURL([dictionary stringForKey:@"headerPic"], SLHTTPServerImageKindUserAvatar);
    NSString *displayName = [dictionary stringForKey:@"remarkname"];
    if(displayName.length == 0){
        displayName = [dictionary stringForKey:@"nickname"];
    }
    
    _userModel = [[SLFriendCircleUserModel alloc] initWithUsername:username displayName:displayName iconURL:iconURL];
    self.applaudNicknameArray = [dictionary arrayForKey:@"nicks"];
    self.applaudUsernameArray = [dictionary arrayForKey:@"names"];
    
    NSDate *date = [_originalDateTime dateWithDefaultFormat];
    _dayLinkMonth = [date dayLinkMonth];
    
    NSArray *comments = [dictionary arrayForKey:@"commList"];
    if(comments != nil && comments.count > 0){
        NSMutableArray *tempCommentsModel = [NSMutableArray array];
        for(NSDictionary *commentDictionary in comments){
            SLFriendCircleStatusCommentModel *statusCommentModel = [SLFriendCircleStatusCommentModel modelWithDictionary:commentDictionary];
            SLFriendCircleStatusCommentFrameModel *statusCommentFrameModel = [SLFriendCircleStatusCommentFrameModel modelWithFriendCircleStatusCommentModel:statusCommentModel];
            [tempCommentsModel addObject:statusCommentFrameModel];
        }
        self.commentArray = [tempCommentsModel copy];
    }
    
    NSString *company = [dictionary stringForKey:@"companyName"];
    NSString *job = [dictionary stringForKey:@"userPosition"];
    if(company.length > 0){
        _companyAndJob = [NSString stringWithFormat:@"%@   %@", company, job];
    }else{
        _companyAndJob = job;
    }
}

- (NSString *)formatDateTime{
    return [[_originalDateTime dateWithDefaultFormat] intervalTime];
}

- (void)setApplaudUsernameArray:(NSArray *)applaudUsernameArray{
    _applaudUsernameArray = applaudUsernameArray;
    NSString *currentUsername = [UserInfo sharedInfo].userID;
    if(_applaudUsernameArray != nil && _applaudUsernameArray.count > 0){
        _applauded = [_applaudUsernameArray containsObject:currentUsername];
    }else{
        _applauded = NO;
    }
}

- (void)setApplaudNicknameArray:(NSArray *)applaudNicknameArray{
    _applaudNicknameArray = applaudNicknameArray;
    _applaudCount = (NSInteger)_applaudNicknameArray.count;
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName : [UIColor colorWithHexString:kDefaultBarColor]};
    if(_applaudCount > 0 && _applaudCount <= 10){
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[已点赞]  %@", [_applaudNicknameArray stringByCommaSeparate]] attributes:attributes];
        _applaudNicknameString = [attributedString copy];
    }else if(_applaudCount > 10){
        NSArray *subArray = [_applaudNicknameArray subarrayWithRange:NSMakeRange(0, 10)];
        NSString *applaudNicknameString = [subArray stringByCommaSeparate];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[已点赞]  %@等%ld人赞了", applaudNicknameString, (long)_applaudCount]];
        [attributedString addAttributes:attributes range:NSMakeRange(0, applaudNicknameString.length)];
        NSDictionary *normalAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0],
                                     NSForegroundColorAttributeName : [UIColor blackColor]};
        [attributedString addAttributes:normalAttributes range:NSMakeRange(applaudNicknameString.length, attributedString.length - applaudNicknameString.length)];
        _applaudNicknameString = [attributedString copy];
    }
    
    _allApplaudNicknameString = [NSString stringWithFormat:@"[已点赞]  %@", [_applaudNicknameArray stringByCommaSeparate]];
}

- (void)setCommentArray:(NSArray *)commentArray{
    _commentArray = commentArray;
    _commtentCount = (NSInteger)_commentArray.count;
}

- (void)setFriendCircleUserModel:(SLFriendCircleUserModel *)userModel{
    _userModel = userModel;
}

@end