//
//  SLEmojiModel.m
//  XMPPIM
//
//  Created by wshaolin on 15/1/3.
//  Copyright (c) 2015年 Bourbon. All rights reserved.
//

#import "SLEmojiModel.h"

@implementation SLEmojiModel

+ (instancetype)modelWithEmojiKey:(NSString *)emojiKey emojiImageName:(NSString *)emojiImageName{
    return [[self alloc] initWithEmojiKey:emojiKey emojiImageName:emojiImageName];
}

- (instancetype)initWithEmojiKey:(NSString *)emojiKey emojiImageName:(NSString *)emojiImageName{
    if(self = [super init]){
        _emojiKey = emojiKey;
        _emojiImageName = emojiImageName;
    }
    return self;
}

@end
