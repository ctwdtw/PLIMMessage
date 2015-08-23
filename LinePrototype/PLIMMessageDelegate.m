//
//  PLIMMessageDelegate.m
//  LinePrototype
//
//  Created by Paul Lee on 2015/8/21.
//  Copyright (c) 2015年 Paul Lee. All rights reserved.
//

#import "PLIMMessageDelegate.h"

@interface PLIMMessageDelegate(){
    
}

@end

@implementation PLIMMessageDelegate 
#pragma mark - SINMessageClientDelegate

- (void)messageClient:(id<SINMessageClient>)messageClient didReceiveIncomingMessage:(id<SINMessage>)message{
    //TODO://1.save message to parse
    

}

- (void)messageSent:(id<SINMessage>)message recipientId:(NSString *)recipientId{
    
    //TODO://1.save message to parse
    //TODO://2.update modelArray
    
    
    
}

- (void)messageDelivered:(id<SINMessageDeliveryInfo>)info{
    
}

- (void)messageFailed:(id<SINMessage>)message info:(id<SINMessageFailureInfo>)messageFailureInfo{
    
    
    
}
@end
