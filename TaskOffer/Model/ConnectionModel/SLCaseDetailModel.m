//
//  SLCaseDetailModel.m
//  TaskOffer
//
//  Created by wshaolin on 15/3/21.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLCaseDetailModel.h"
#import "NSDictionary+NullFilter.h"
#import "SLHTTPServerHandler.h"

@implementation SLCaseDetailModel

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
    _createUser = [dictionary stringForKey:@"createUser"];
    
    _caseID = [dictionary stringForKey:@"id"];
    _caseName = [dictionary stringForKey:@"caseName"];
    _caseLogoName = [dictionary stringForKey:@"caseLogo"];
    _caseLogo = SLHTTPServerImageURL(_caseLogoName, SLHTTPServerImageKindCaseLogo);
    _caseType = [dictionary integerForKey:@"caseType"];
    
    _tags = [[dictionary stringForKey:@"caseTags"] componentsSeparatedByString:@","];
    _industry = [dictionary stringForKey:@"caseProfessionType"];
    _projectDesc = [dictionary stringForKey:@"projectDesc"];
    _referencePrice = [dictionary stringForKey:@"casePrice"];
    _developmentTime = [dictionary stringForKey:@"caseTimes"];
    _technicalScheme = [dictionary stringForKey:@"caseTechnical"];
    _schemeDesc = [dictionary stringForKey:@"caseTechnicalDescibe"];
    _isOnline = [dictionary boolForKey:@"isPublish"];
    _downloadLink = [dictionary stringForKey:@"caseLink"];
    if(_downloadLink.length > 0){
        _isValidURL = [NSURL URLWithString:_downloadLink].host != nil;
    }
    
    _designSchemeImageNames = [dictionary stringForKey:@"casePicture"];
    if(_designSchemeImageNames.length > 0){
        NSMutableArray *tempArray = [NSMutableArray array];
        NSArray *imgaeNames = [_designSchemeImageNames componentsSeparatedByString:@","];
        for(NSString *imgaeName in imgaeNames){
            [tempArray addObject:SLHTTPServerImageURL(imgaeName, SLHTTPServerImageKindCasePicture)];
        }
        _designSchemeUrl = [tempArray copy];
    }
}

- (void)setCollected:(BOOL)isCollected{
    _isCollected = isCollected;
}

- (void)setCollectId:(NSString *)collectId{
    _collectId = collectId;
}

@end
