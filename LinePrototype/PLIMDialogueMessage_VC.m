//
//  DialogueMessage_VC.m
//  LinePrototype
//
//  Created by Paul Lee on 2015/8/19.
//  Copyright (c) 2015年 Paul Lee. All rights reserved.
//

#import "PLIMDialogueMessage_VC.h"
#import "PLIMDialogueCell.h"
#import "PLIMLibrayAPI.h"
#import "PLIMChatMessage.h"

@interface PLIMDialogueMessage_VC ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *historicalMessageArray;
}

@property (weak, nonatomic) IBOutlet UIScrollView *dialogueScrollView;
@property (weak, nonatomic) IBOutlet UITableView *historicalMessageTableView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@end

@implementation PLIMDialogueMessage_VC




#pragma mark- view for User Actions
- (IBAction)sendBtnPressed:(id)sender {
    
#if 1
    /*stick to Sinch SDK's delegate method and use KVO to notifiy PLIMLibraryAPI when message has been received or sent. Controller who wants to refresh its view can use -(void)subscribeLatestMessageForSubscriber:
                          (id)controller Storage:(NSMutableArray*)storage
                                         Action :(SEL)invokeMethod;
     
        defined in PLIMLibaray singleton to subscribe the message events.
    */
    
    [[PLIMLibrayAPI defaultLibrary] sendTextMessage:self.messageTextField.text toRecipient:self.chatMateId];
    self.messageTextField.text = @"";
    
#else
    // Modify Sinch's SDK, use call-back to update tableView,
    [[PLIMLibrayAPI defaultLibrary]sendTextMessage:self.messageTextField.text toRecipient:self.chatMateId completion:^(id<SINMessage> message) {
        
        PLIMChatMessage *lastestChatMessage = (PLIMChatMessage*)message;
        [historicalMessageArray addObject:lastestChatMessage];
        [self.historicalMessageTableView reloadData];
        
    }];

#endif
    

}

- (IBAction)historicalMessageTableViewDidTapped:(id)sender {
    
    [self.messageTextField resignFirstResponder];
    
}


-(void)RefreshTableView{
    [self.historicalMessageTableView reloadData];
    [self scrollTableToBottom];
}

- (void)scrollTableToBottom {
    NSInteger rowNumber = [self.historicalMessageTableView numberOfRowsInSection:0];
    if (rowNumber > 0) [self.historicalMessageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}



#pragma mark - keyboard Notification

-(void)keyboardWillShow:(NSNotification*)aNotification{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSDictionary *info = aNotification.userInfo;
    CGRect keyboadFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGSize keyboardSize = keyboadFrame.size;
    self.dialogueScrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    
    self.historicalMessageTableView.contentInset=UIEdgeInsetsMake(keyboardSize.height, 0.0, 0.0, 0.0);
    
    [self.dialogueScrollView scrollRectToVisible:self.messageTextField.frame animated:NO];
    
}

-(void)keyboardWillHide:(NSNotification*)aNotification{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.dialogueScrollView.contentInset = UIEdgeInsetsZero;
    self.historicalMessageTableView.contentInset=UIEdgeInsetsZero;
    
}


#pragma mark - viewController Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.historicalMessageTableView.estimatedRowHeight=44;
    self.historicalMessageTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.historicalMessageTableView.delegate = self;
    self.historicalMessageTableView.dataSource = self;
    
    [self.tabBarController.tabBar setHidden:YES];
    
    [self.historicalMessageTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.historicalMessageTableView addGestureRecognizer:_tapGesture];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
#if 0
    self.myUserId=@"paul";
    self.chatMateId=@"userA";
#else
    self.myUserId=@"userA";
    self.chatMateId=@"paul";
#endif
    historicalMessageArray = [NSMutableArray new];
    
    //[[PLIMLibrayAPI defaultLibrary]initSinchClient:self.myUserId];
    
    [[PLIMLibrayAPI defaultLibrary]initSinchClientForUser:self.myUserId ChatMate:self.chatMateId];
    
}


-(void)viewWillDisappear:(BOOL)animated{
   [self.tabBarController.tabBar setHidden:NO];
   [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [[PLIMLibrayAPI defaultLibrary]subscribeLatestMessageForSubscriber:self Storage:historicalMessageArray Action:@selector(RefreshTableView)];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView data soure
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [historicalMessageArray count];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     PLIMDialogueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DialogueCell" forIndexPath:indexPath];
    
    [self configureCell:cell AtIndexPath:indexPath];
    
    return cell;
}


-(void)configureCell:(PLIMDialogueCell*)cell AtIndexPath:(NSIndexPath*)indexPath{
    
    PLIMChatMessage *chatMessage = historicalMessageArray[indexPath.row];
    
    if ([[chatMessage senderId] isEqualToString:self.myUserId]) {
        // If the message was sent by myself
        cell.chateMateMessageLab.text = @"";
        cell.myMessageLab.text = chatMessage.text;
    } else {
        // If the message was sent by the chat mate
        cell.myMessageLab.text = @"";
        cell.chateMateMessageLab.text = chatMessage.text;
    }
    
}

#pragma mark - tableView delegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
