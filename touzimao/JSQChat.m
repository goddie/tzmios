//
//  JSQChat.m
//  touzimao
//  聊天
//  Created by goddie on 15/8/13.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//

#import "JSQChat.h"
#import "User.h"
#import "UIViewController+Custome.h"
#import "UIImageView+WebCache.h"
#import "Message.h"

@interface JSQChat ()

@end

@implementation JSQChat
{
    NSMutableArray *messages;
    BOOL isLoading;
    JSQMessagesBubbleImage *outgoingBubbleImageData;
    
    JSQMessagesBubbleImage *incomingBubbleImageData;
    
    NSTimer *timer;
}





#pragma mark - View lifecycle

/**
 *  Override point for customization.
 *
 *  Customize your view.
 *  Look at the properties on `JSQMessagesViewController` and `JSQMessagesCollectionView` to see what is possible.
 *
 *  Customize your layout.
 *  Look at the properties on `JSQMessagesCollectionViewFlowLayout` to see what is possible.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = @"聊天";
    messages = [NSMutableArray arrayWithCapacity:10];
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleRedColor]];
    
 
    
 
 
    
    
    
    /**
     *  You MUST set your senderId and display name
     */
    self.senderId = self.from.uuid;
    self.senderDisplayName = self.from.nickname;
    
    
    /**
     *  Load up our fake data for the demo
     */
    //self.demoData = [[DemoModelData alloc] init];
    
    [self getLastMessage];
    
    
    //self.showLoadEarlierMessagesHeader = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage jsq_defaultTypingIndicatorImage]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(receiveMessagePressed:)];
    
    /**
     *  Register custom menu actions for cells.
     */
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    [UIMenuController sharedMenuController].menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action" action:@selector(customAction:)] ];
    
    
    
    /**
     *  Customize your toolbar buttons
     *
     *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
     *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
     */
    
    /**
     *  Set a maximum height for the input toolbar
     *
     *  self.inputToolbar.maximumHeight = 150;
     */
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [timer invalidate];
}

-(void)getNewMessage
{
    if (self.from==nil||self.sendTo==nil) {
        return;
    }
    //[self showHud];
    
    isLoading = YES;
    
    NSDictionary *parameters = @{
                                 @"from": self.sendTo.uuid,
                                 @"sendTo": self.from.uuid,
                                 @"status": @"0",
                                 @"p": @"1"
                                 };
    //NSLog(@"getNewMessage: %@",parameters);
    NSLog(@"getNewMessage");
    [self post:@"message/json/gettomsg" params:parameters success:^(id responseObj) {
        
        isLoading = NO;
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            NSArray *arr = [dict objectForKey:@"data"];
            for (NSDictionary *dc in arr) {
                Message *model = [MTLJSONAdapter modelOfClass:[Message class] fromJSONDictionary:dc error:nil];
                if (model) {
                    
                    NSString *content = [GlobalUtil toString:model.content];
                    NSString *from = [GlobalUtil toString:[model.from objectForKey:@"nickname"]];
                    NSString *fromId = [GlobalUtil toString:[model.from objectForKey:@"id"]];
                    
                    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[model.createdDate doubleValue]/1000];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    
                    
                    JSQMessage *jsqm = [[JSQMessage alloc] initWithSenderId:fromId
                                                          senderDisplayName:from
                                                                       date:d
                                                                       text:content];
                    
                    [messages addObject:jsqm];
                }
            }
            
            self.showTypingIndicator = !self.showTypingIndicator;
            [self finishReceivingMessage];
            
        }
    }];
}




-(void)getLastMessage
{
    
    if (self.from==nil||self.sendTo==nil) {
        return;
    }
    
    [self showHud];
    
    isLoading = YES;
    NSDictionary *parameters = @{
                                 @"from": self.from.uuid,
                                 @"sendTo": self.sendTo.uuid,
                                 @"p":@"1"
                                 };
    
    NSLog(@"%@",parameters);
    
    [self post:@"message/json/getmsg" params:parameters success:^(id responseObj) {
        isLoading = NO;
        
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
            NSArray *arr = [dict objectForKey:@"data"];
            for (NSDictionary *dc in arr) {
                Message *model = [MTLJSONAdapter modelOfClass:[Message class] fromJSONDictionary:dc error:nil];
                
                
                
                
                if (model) {
                    
                    NSString *content = [GlobalUtil toString:model.content];
                    NSString *from = [GlobalUtil toString:[model.from objectForKey:@"nickname"]];
                    NSString *fromId = [GlobalUtil toString:[model.from objectForKey:@"id"]];
                    
                    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[model.createdDate doubleValue]/1000];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 
                    
                    JSQMessage *jsqm = [[JSQMessage alloc] initWithSenderId:fromId
                                                          senderDisplayName:from
                                                                       date:d
                                                                       text:content];
                    
                    [messages addObject:jsqm];
                }
                
                
            }
            
            
            [self.collectionView reloadData];
            
            
        }
        
        [self hideHud];
    }];
    
}


-(void)sendMessage:(NSString*)content
{
    if (self.from==nil||self.sendTo==nil) {
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"from": self.from.uuid,
                                 @"sendTo": self.sendTo.uuid,
                                 @"content":content
                                 };
    
    NSLog(@"%@",parameters);
    
    [self post:@"message/json/add" params:parameters success:^(id responseObj) {
        NSDictionary *dict = (NSDictionary *)responseObj;
        if ([[dict objectForKey:@"code"] intValue]==1) {
            
        }
    }];
}
-(void)timerUpdate
{
    if (isLoading) {
        return;
    }
    [self getNewMessage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.delegateModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                              target:self
                                                                                              action:@selector(closePressed:)];
    }
}




#pragma mark - Testing

- (void)pushMainViewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nc = [sb instantiateInitialViewController];
    [self.navigationController pushViewController:nc.topViewController animated:YES];
}


#pragma mark - Actions

- (void)receiveMessagePressed:(UIBarButtonItem *)sender
{
    /**
     *  DEMO ONLY
     *
     *  The following is simply to simulate received messages for the demo.
     *  Do not actually do this.
     */
    
    
    /**
     *  Show the typing indicator to be shown
     */
    self.showTypingIndicator = !self.showTypingIndicator;
    
    /**
     *  Scroll to actually view the indicator
     */
    [self scrollToBottomAnimated:YES];
    
    /**
     *  Copy last sent message, this will be the new "received" message
     */
    //JSQMessage *copyMessage = [[self.demoData.messages lastObject] copy];
    JSQMessage *copyMessage = [[messages lastObject] copy];
    if (!copyMessage) {
        copyMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdJobs
                                          displayName:kJSQDemoAvatarDisplayNameJobs
                                                 text:@"First received!"];
    }
    
}

- (void)closePressed:(UIBarButtonItem *)sender
{
    [self.delegateModal didDismissJSQDemoViewController:self];
}




#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
//    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self sendMessage:text];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    //[self.demoData.messages addObject:message];
    [messages addObject:message];
    
    [self finishSendingMessageAnimated:YES];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Media messages"
//                                                       delegate:self
//                                              cancelButtonTitle:@"Cancel"
//                                         destructiveButtonTitle:nil
//                                              otherButtonTitles:@"Send photo", @"Send location", @"Send video", nil];
//    
//    [sheet showFromToolbar:self.inputToolbar];
}





#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [messages objectAtIndex:indexPath.item];
    //return [self.demoData.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    //JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        //return self.demoData.outgoingBubbleImageData;
        return outgoingBubbleImageData;
    }
    
    //return self.demoData.incomingBubbleImageData;
    return  incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
//        JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
        JSQMessage *message = [messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    //JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    JSQMessage *message = [messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
       // JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
         JSQMessage *previousMessage = [messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return [self.demoData.messages count];
    return [messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    //JSQMessage *msg = [self.demoData.messages objectAtIndex:indexPath.item];
    
    JSQMessage *msg = [messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}



#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{

}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    //JSQMessage *currentMessage = [self.demoData.messages objectAtIndex:indexPath.item];
    JSQMessage *currentMessage = [messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        //JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
        JSQMessage *previousMessage = [messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

@end
