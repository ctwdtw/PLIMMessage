//
//  MessageSingleton.m
//  LinePrototype
//
//  Created by Paul Lee on 2015/8/20.
//  Copyright (c) 2015年 Paul Lee. All rights reserved.
//

#import "PLIMMessageManager.h"
#import <Parse/Parse.h>
#import "Config.h"
#import "PLIMLibrayAPI.h"


@interface PLIMMessageManager()<SINClientDelegate,SINMessageClientDelegate>

@end

@implementation PLIMMessageManager

#pragma mark - object life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        //[self addObserver:[PLIMLibrayAPI defaultLibrary] forKeyPath:@"latestChatMessage" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}


-(void)dealloc{
    
    //[self removeObserver:[PLIMLibrayAPI defaultLibrary] forKeyPath:@"latestChatMessage"];
    
}


#pragma mark - instance methods
-(void)sendTextMessage:(NSString *)messageText toRecipient:(NSString *)recipientID{
    
    self.isMessageSent = NO;
    SINOutgoingMessage *outgoingMessage = [SINOutgoingMessage messageWithRecipient:recipientID text:messageText];
    [self.sinchMessageClient sendMessage:outgoingMessage];
    
}

-(void)sendTextMessage:(NSString *)messageText toRecipients:(NSArray *)recipientArray{
    
    SINOutgoingMessage *outgoingMessage = [SINOutgoingMessage messageWithRecipients:recipientArray text:messageText];
    
    [self.sinchMessageClient sendMessage:outgoingMessage];
}


-(void)initSinchClient:(NSString *)userId{
    
    self.sinchClient = [Sinch clientWithApplicationKey:SINCH_APPLICATION_KEY
                                     applicationSecret:SINCH_APPLICATION_SECRET
                                       environmentHost:SINCH_ENVIRONMENT_HOST
                                                userId:userId];
    self.sinchClient.delegate = self;
    [self.sinchClient setSupportMessaging:YES]; //enable IM message
    [self.sinchClient start]; //enable calling function
    [self.sinchClient startListeningOnActiveConnection]; //enable receiving call
    
    
}


#pragma mark - SINMessageClientDelegate

- (void)messageClient:(id<SINMessageClient>)messageClient didReceiveIncomingMessage:(id<SINMessage>)message{
    
    self.latestChatMessage = message;

}

- (void)messageSent:(id<SINMessage>)message recipientId:(NSString *)recipientId{
    
    self.isMessageSent = YES;
    self.latestChatMessage = message;

}

- (void)messageDelivered:(id<SINMessageDeliveryInfo>)info{
    
}

- (void)messageFailed:(id<SINMessage>)message info:(id<SINMessageFailureInfo>)messageFailureInfo{
    
}

#pragma mark - SinchClientDelegate

-(void)clientDidStart:(id<SINClient>)client{
    
    self.sinchMessageClient = [self.sinchClient messageClient];
    //self.messageDelegate = [PLIMMessageDelegate new];
    //self.sinchMessageClient.delegate =  self.messageDelegate;
    
    //sinchMessage Delegate is implement in this class, not in PLIMMessageDelegate
    self.sinchMessageClient.delegate = self;
    
    NSLog(@"SINClient did started");
}



-(void)clientDidFail:(id<SINClient>)client error:(NSError *)error{

    NSLog(@"Start SINClient failed. Description: %@. Reason: %@.", error.localizedDescription, error.localizedFailureReason);
}


-(void)client:(id<SINClient>)client requiresRegistrationCredentials:(id<SINClientRegistration>)registrationCallback{
    
    
}






@end
