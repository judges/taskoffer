//
//  SLEmojiModel.h
//  XMPPIM
//
//  Created by wshaolin on 15/1/3.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLEmojiModel : NSObject

@property (nonatomic, copy) NSString *emojiKey;
@property (nonatomic, copy) NSString *emojiImageName;

- (instancetype)initWithEmojiKey:(NSString *)emojiKey emojiImageName:(NSString *)emojiImageName;
+ (instancetype)modelWithEmojiKey:(NSString *)emojiKey emojiImageName:(NSString *)emojiImageName;

@end
