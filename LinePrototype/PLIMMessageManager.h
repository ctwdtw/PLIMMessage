//
//  MessageSingleton.h
//  LinePrototype
//
//  Created by Paul Lee on 2015/8/20.
//  Copyright (c) 2015年 Paul Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Sinch/Sinch.h>
#import "PLIMMessageDelegate.h"
#import "PLIMChatMessage.h"
#import "Config.h"

@interface PLIMMessageManager : NSObject <NSObject>
@property(nonatomic)BOOL isMessageSent;
@property(nonatomic,strong)PLIMMessageDelegate *messageDelegate;
@property (nonatomic) NSMutableArray *modelMessageArray;
@property (strong, nonatomic) id<SINClient> sinchClient;
@property (strong, nonatomic) id<SINMessageClient> sinchMessageClient;
@property (strong, nonatomic) PLIMChatMessage *latestChatMessage;
- (void)initSinchClient:(NSString*)userId;
- (void)sendTextMessage:(NSString *)messageText toRecipient:(NSString *)recipientID;
- (void)sendTextMessage:(NSString *)messageText toRecipients:(NSArray *)recipientID;
@end
