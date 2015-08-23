//
//  PLIMLibrayAPI.h
//  LinePrototype
//
//  Created by Paul Lee on 2015/8/21.
//  Copyright (c) 2015年 Paul Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLIMChatMessage.h"

@interface PLIMLibrayAPI : NSObject
+(PLIMLibrayAPI*)defaultLibrary;
-(void)sendTextMessage:(NSString *)messageText
           toRecipient:(NSString *)recipientID
            completion:(void(^)(id<SINMessage> message))callbackBlock;

-(void)sendTextMessage:(NSString *)messageText
           toRecipient:(NSString *)recipientID;
-(void)sendTextMessage:(NSString *)messageText
          toRecipients:(NSArray *)recipientIDgroup;
//-(void)initSinchClient:(NSString*)userId;

-(void)initSinchClientForUser:(NSString*)userId
                     ChatMate:(NSString*)chateMateId;


//-(PLIMChatMessage*)latestChatMessage;
-(void)subscribeLatestMessageForSubscriber:(id)controller
                                   Storage:(NSMutableArray*)storage
                                   Action :(SEL)invokeMethod;




@end
