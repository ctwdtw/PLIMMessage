//
//  PLIMParseManager.m
//  LinePrototype
//
//  Created by Paul Lee on 2015/8/23.
//  Copyright (c) 2015年 Paul Lee. All rights reserved.
//

#import "PLIMdBManager.h"

@implementation PLIMdBManager

-(void)saveMessagesOndB:(id<SINMessage>)message{
    
    PFQuery *query = [PFQuery queryWithClassName:@"SinchMessage"];
    [query whereKey:@"messageId" equalTo:[message messageId]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *messageArray, NSError *error) {
        if (!error) {
            // If the SinchMessage is not already saved on Parse (an empty array is returned), save it.
            if ([messageArray count] <= 0) {
                PFObject *messageObject = [PFObject objectWithClassName:@"SinchMessage"];
                
                messageObject[@"messageId"] = [message messageId];
                messageObject[@"senderId"] = [message senderId];
                messageObject[@"recipientId"] = [message recipientIds][0];
                messageObject[@"text"] = [message text];
                messageObject[@"timestamp"] = [message timestamp];
                
                [messageObject saveInBackground];
            }
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    
}

-(void)retrieveMessagesFromParseWithChatMateID:(NSString *)chatMateId UserID:(NSString *)userID{
    
    NSArray *userNames = @[userID, chatMateId];
    
    PFQuery *query = [PFQuery queryWithClassName:@"SinchMessage"];
    [query whereKey:@"senderId" containedIn:userNames];
    [query whereKey:@"recipientId" containedIn:userNames];
    [query orderByAscending:@"timestamp"];
    
    __weak typeof(self) weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *chatMessageArray, NSError *error) {
        if (!error) {
            // Store all retrieve messages into historicalMessagesArray
            for (int i = 0; i < [chatMessageArray count]; i++) {
                PLIMChatMessage *chatMessage = [[PLIMChatMessage alloc] init];
                
                [chatMessage setMessageId:chatMessageArray[i][@"messageId"]];
                [chatMessage setSenderId:chatMessageArray[i][@"senderId"]];
                [chatMessage setRecipientIds:[NSArray arrayWithObject:chatMessageArray[i][@"recipientId"]]];
                [chatMessage setText:chatMessageArray[i][@"text"]];
                [chatMessage setTimestamp:chatMessageArray[i][@"timestamp"]];
                
                weakSelf.retrievedMessage = chatMessage;
            
            }
            
            
            
        } else {
            NSLog(@"Error: %@", error.description);
        }
    }];
    
    
    
    
}


@end
