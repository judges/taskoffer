//
//  SLConnectionModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/19.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLConnectionModel.h"
#import "NSDictionary+NullFilter.h"
#import "SLTimeStampHandler.h"
#import "SLHTTPServerHandler.h"

@implementation SLConnectionModel

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
    _userID = [dictionary stringForKey:@"id"];
    _imageURL = [dictionary stringForKey:@"userHeadPicture"];
    _imageURL = SLHTTPServerImageURL(_imageURL, SLHTTPServerImageKindUserAvatar);
    _displayName = [dictionary stringForKey:@"userName"];
    
    NSString *sex = [dictionary stringForKey:@"userSex"];
    _sex = SLConnectionModelSexUnknown;
    if(sex.length > 0){
        if([sex isEqualToString:@"男"]){
            _sex = SLConnectionModelSexMale;
        }else if([sex isEqualToString:@"女"]){
            _sex = SLConnectionModelSexFemale;
        }
    }
    
    // 0:未认证 1:认证中 2:伪认证 3:已认证
    _isAuthenticated = [dictionary integerForKey:@"userCertificateStatus"] == 3;
    _caseCount = [dictionary integerForKey:@"userCases"];
    _introduction = [dictionary stringForKey:@"userDescibe"];
    _email = [dictionary stringForKey:@"userMail"];
    if(_email.length == 0){
        _email = @"尚未完善";
    }
    _authenticatedTime = [SLTimeStampHandler stringWithTimeStamp:[dictionary doubleForKey:@"userCertificateTime"]];
    _mobile = [dictionary stringForKey:@"userPhone"];
    _isPerfectInfo = [dictionary boolForKey:@"userInfoIntegrity"];
    
    _city = [dictionary stringForKey:@"userCity"];
    if(_city.length == 0){
        _city = @"尚未完善";
    }
    _companyName = [dictionary stringForKey:@"userCompanyDefinedName"];
    _companyID = [dictionary stringForKey:@"userCompanyId"];
    _companyStaffSize = [dictionary stringForKey:@"userCompanySize"];
    if(_companyStaffSize.length == 0){
        _companyStaffSize = @"尚未完善";
    }
    _companyIntroduction = [dictionary stringForKey:@"userCompanyDescibe"];
    _companyEnterpriseName = [dictionary stringForKey:@"userCompanyName"];
    
    if(_companyName.length > 0){
        _companyAndJob = [NSString stringWithFormat:@"%@   %@", _companyName, [dictionary stringForKey:@"userCompanyPosition"]];
    }else{
        _companyAndJob = [dictionary stringForKey:@"userCompanyPosition"];
    }
    
    _tags = [[dictionary stringForKey:@"userTags"] componentsSeparatedByString:@","];
    _tag1 = @"";
    _tag2 = @"";
    _tag3 = @"";
    if(_tags != nil && _tags.count > 0){
        if(_tags.count == 1){
            _tag1 = _tags[0];
        }else if (_tags.count == 2){
            _tag1 = _tags[0];
            _tag2 = _tags[1];
        }else{
            _tag1 = _tags[0];
            _tag2 = _tags[1];
            _tag3 = _tags[2];
        }
    }
}

- (NSUInteger)hash{
    return self.userID.hash;
}

- (BOOL)isEqualConnection:(SLConnectionModel *)connectionModel{
    return [self.userID isEqualToString:connectionModel.userID];
}

@end
