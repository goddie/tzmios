//
//  JSQChat.h
//  touzimao
//
//  Created by goddie on 15/8/13.
//  Copyright (c) 2015年 xiaba2. All rights reserved.
//
#import "JSQMessages.h"
#import "JSQMessagesViewController.h"
#import "DemoModelData.h"


@class JSQChat;

@protocol JSQDemoViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(JSQChat *)vc;

@end



@interface JSQChat : JSQMessagesViewController<UIActionSheetDelegate>


@property (weak, nonatomic) id<JSQDemoViewControllerDelegate> delegateModal;

@property (strong, nonatomic) DemoModelData *demoData;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;

@end
