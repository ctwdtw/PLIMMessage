//
//  PLIMParseManager.h
//  LinePrototype
//
//  Created by Paul Lee on 2015/8/23.
//  Copyright (c) 2015年 Paul Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import <Parse/Parse.h>
#import <Sinch/Sinch.h>
#import "PLIMChatMessage.h"

@interface PLIMdBManager : NSObject
- (void)saveMessagesOndB:(id<SINMessage>)message;
- (void)retrieveMessagesFromParseWithChatMateID:(NSString *)chatMateId
                                         UserID:(NSString *)userID;
@property (nonatomic) PLIMChatMessage *retrievedMessage;

@end
