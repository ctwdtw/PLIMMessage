//
//  PLIMLibrayAPI.m
//  LinePrototype
//
//  Created by Paul Lee on 2015/8/21.
//  Copyright (c) 2015年 Paul Lee. All rights reserved.
//
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#import "PLIMLibrayAPI.h"
#import "PLIMMessageManager.h"
#import "PLIMdBManager.h"
static PLIMLibrayAPI *_defaultLibrary;
@interface PLIMLibrayAPI(){
    
    PLIMMessageManager *messageManager;
    PLIMdBManager *dBManager;
}

@property(nonatomic)NSMutableArray *subscribers;
@property NSString* myUserID;
@property NSString* chatMateID;
@end


@implementation PLIMLibrayAPI
+(PLIMLibrayAPI*)defaultLibrary{
    
    if (_defaultLibrary == nil) {
        _defaultLibrary = [[PLIMLibrayAPI alloc]init];
    }
    
    return _defaultLibrary;
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
     
        self.subscribers = [NSMutableArray array];
        
        messageManager = [[PLIMMessageManager alloc]init];
    
        [messageManager addObserver:self forKeyPath:@"latestChatMessage" options:NSKeyValueObservingOptionNew context:nil];
        
        dBManager = [[PLIMdBManager alloc] init];
        
        [dBManager addObserver:self forKeyPath:@"retrievedMessage" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

-(void)dealloc{
    [messageManager removeObserver:self forKeyPath:@"latestChatMessage"];
    [dBManager removeObserver:self forKeyPath:@"retrievedMessage"];
}

#pragma mark - KVO 
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"latestChatMessage"] || [keyPath isEqualToString:@"retrievedMessage"]) {
        
        for (NSDictionary *subscriber in self.subscribers) {
            
            [subscriber[@"storage"] addObject:[object valueForKeyPath:keyPath]];
            id controller = subscriber[@"controller"];
            SEL retrivedSelector = NSSelectorFromString(subscriber[@"method"]);
            [controller performSelector:retrivedSelector];
            
        }
        
        [dBManager saveMessagesOndB:[object valueForKeyPath:keyPath]];
        //saveMessageONParse
    
    }

}


#pragma mark - PLMIMMessageManager instance methods

-(void)subscribeLatestMessageForSubscriber:(id)controller Storage:(NSMutableArray *)storage Action:(SEL)invokeMethod{
    
    NSDictionary *subscriberDict = [NSDictionary dictionaryWithObjects:@[controller,storage,NSStringFromSelector(invokeMethod)] forKeys:@[@"controller",@"storage",@"method"]];

    [self.subscribers addObject:subscriberDict];
    [dBManager retrieveMessagesFromParseWithChatMateID:self.chatMateID UserID:self.myUserID];
}

//- (void)initSinchClient:(NSString*)userId{
//    self.myUserID = userId;
//    [messageManager initSinchClient:userId];
//}

-(void)initSinchClientForUser:(NSString *)userId ChatMate:(NSString *)chateMateId{
    self.myUserID = userId;
    self.chatMateID = chateMateId;
    [messageManager initSinchClient:userId];
    
}

//-(PLIMChatMessage*)latestChatMessage{
//    
//    return messageManager.latestChatMessage;
//}


-(void)sendTextMessage:(NSString *)messageText
           toRecipient:(NSString *)recipientID{
    
    [messageManager sendTextMessage:messageText toRecipient:recipientID];
    
    
}

-(void)sendTextMessage:(NSString *)messageText
           toRecipient:(NSString *)recipientID
            completion:(void(^)(id<SINMessage> message))callbackBlock{
    
    [messageManager sendTextMessage:messageText toRecipient:recipientID];
    
    dispatch_async(dispatch_queue_create("myQueue",DISPATCH_QUEUE_CONCURRENT ), ^{
        
         while (messageManager.isMessageSent == NO) {
         //wait for the Message delegate finish it job
         
         }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            callbackBlock(messageManager.latestChatMessage);
        });
        
    });

}
-(void)sendTextMessage:(NSString *)messageText
          toRecipients:(NSArray *)recipientIDgroup{
    [messageManager sendTextMessage:messageText toRecipients:recipientIDgroup];
}

@end
