//
//  DialogueMessage_VC.h
//  LinePrototype
//
//  Created by Paul Lee on 2015/8/19.
//  Copyright (c) 2015年 Paul Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLIMDialogueMessage_VC : UIViewController
@property (strong, nonatomic) NSString *chatMateId;
@property (strong, nonatomic) NSString *myUserId;
@property (strong,nonatomic) NSMutableArray *chatMateGroup;


@end
