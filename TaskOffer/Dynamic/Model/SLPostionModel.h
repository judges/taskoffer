//
//  SLPostionModel.h
//  XMPPIM
//
//  Created by wshaolin on 14/12/26.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SLPostionModel : NSObject

@property (nonatomic, copy, readonly) NSString *postionName;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D locationCoordinate;
@property (nonatomic, copy, readonly) NSString *latitude;
@property (nonatomic, copy, readonly) NSString *longitude;

- (instancetype)initWithLocationCoordinate:(CLLocationCoordinate2D)locationCoordinate postionName:(NSString *)postionName;
+ (instancetype)modelWithLocationCoordinate:(CLLocationCoordinate2D)locationCoordinate postionName:(NSString *)postionName;

@end
