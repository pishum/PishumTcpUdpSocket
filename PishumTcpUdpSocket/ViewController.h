//
//  ViewController.h
//  PishumTcpUdpSocket
//
//  Created by Pishum on 15/12/22.
//  Copyright © 2015年 Pishum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *udpIPTextField;
@property (strong, nonatomic) IBOutlet UITextField *udpPortTextField;
@property (strong, nonatomic) IBOutlet UIButton *udpBtn;

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITextField *tcpIpTextField;
@property (strong, nonatomic) IBOutlet UITextField *tcpPortTextField;
@property (strong, nonatomic) IBOutlet UITextField *sendTextField;

@property (strong, nonatomic) IBOutlet UIButton *tcpBtn;

- (IBAction)OnClicked:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *tcpSendTextField;


@end

