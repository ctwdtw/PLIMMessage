//
//  PLIMChatMessage.h
//  
//
//  Created by Paul Lee on 2015/8/21.
//
//

#import <Foundation/Foundation.h>
#import <Sinch/Sinch.h>

@interface PLIMChatMessage : NSObject <SINMessage>
@property (nonatomic, strong) NSString* messageId;
@property (nonatomic, strong) NSArray* recipientIds;
@property (nonatomic, strong) NSString* senderId;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSDictionary* headers;
@property (nonatomic, strong) NSDate* timestamp;



@end
