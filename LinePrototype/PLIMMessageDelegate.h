//
//  PLIMMessageDelegate.h
//  LinePrototype
//
//  Created by Paul Lee on 2015/8/21.
//  Copyright (c) 2015年 Paul Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Sinch/Sinch.h>
@interface PLIMMessageDelegate : NSObject<SINMessageClientDelegate>

- (void)messageClient:(id<SINMessageClient>)messageClient didReceiveIncomingMessage:(id<SINMessage>)message;
- (void)messageSent:(id<SINMessage>)message recipientId:(NSString *)recipientId;
- (void)messageDelivered:(id<SINMessageDeliveryInfo>)info;
- (void)messageFailed:(id<SINMessage>)message info:(id<SINMessageFailureInfo>)messageFailureInfo;

@end
