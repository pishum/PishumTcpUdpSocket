//
//  ViewController.m
//  PishumTcpUdpSocket
//
//  Created by Pishum on 15/12/22.
//  Copyright © 2015年 Pishum. All rights reserved.
//

#import "ViewController.h"
#import "AsyncUdpSocket.h"
#import "AsyncSocket.h"

#define UDP_PORT 8080

@interface ViewController ()
@property (strong,nonatomic) AsyncUdpSocket *udpSocket;
@property (strong,nonatomic)AsyncSocket *tcpSocket;
@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self initUDPSocket];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*******************UDP Socket Start*************************/
//UDP
- (void)initUDPSocket {
    
    //初始化udp
    AsyncUdpSocket *tempSocket=[[AsyncUdpSocket alloc] initIPv4];
    self.udpSocket = tempSocket;
    
    [self.udpSocket setDelegate:self];//这步很重要，否则无法自定义监听方法
    
    tempSocket = nil;
    //绑定端口
    NSError *error = nil;
    [self.udpSocket bindToPort:UDP_PORT error:&error];//pishum
    //发送广播设置
    [self.udpSocket enableBroadcast:YES error:&error];
    [self.udpSocket receiveWithTimeout:-1 tag:200];
    
}



//已接收到消息
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSString *receiveData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSString *cleanString = [receiveData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (receiveData.length > 20) {
        NSLog(@"接收到的数据为 %@",receiveData);
//    }
    
    [sock receiveWithTimeout:-1 tag:0];
    
    return YES;
}
//没有接受到消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"udp didNotReceiveDataWithTag");
}
//没有发送出消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"udp didNotSendDataWithTag");
}
//已发送出消息
-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"udp didSendDataWithTag");
}
//断开连接
-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    NSLog(@"udp onUdpSocketDidClose");
}
/*******************UDP Socket End*************************/



- (IBAction)OnClicked:(UIButton *)sender {
    
    switch ([sender tag]) {
        case 0:
            [self sendUdpInfos];
            break;
        case 1:
            [self linkTcpSocket];
            break;
        case 2:
            [self sendTcpInfos];
            break;
            
        default:
            break;
    }
}


- (void)sendUdpInfos{
    NSString* str= self.sendTextField.text;
    NSData *data=[str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *ip =  self.udpIPTextField.text;
    int port = [self.udpPortTextField.text intValue];
    
    
    
    [self.udpSocket sendData:data
                      toHost:ip
                        port:port//pishum
                 withTimeout:-1
                         tag:0];
}





/*******************WAN TCP Socket Start*************************/


#pragma mark 建立TCP连接
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    [sock readDataWithTimeout:-1 tag:0];
    NSLog(@"正在连接中。。。");
}


- (void)onSocketDidSecure:(AsyncSocket *)sock{
    NSLog(@"onSocketDidSecure");
}
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err{
    NSLog(@"onSocketwillDisconnectWithError  tcpSocket连接错误");
    [self.tcpSocket disconnect];
    self.tcpSocket = nil;
}
- (void)onSocketDidDisconnect:(AsyncSocket *)sock{
    NSLog(@"onSocketDidDisconnect tcpSocket");
    self.tcpSocket = nil;
}

//读取数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    [sock readDataWithTimeout:-1 tag:0];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  
    NSLog(@"接收到的数据%@",str);
    
   }


//连接外网TCP
-(void)linkTcpSocket{
    NSString *ip = self.tcpIpTextField.text;
    int port = [self.tcpPortTextField.text intValue];
    
    @try{
        NSError * erro = nil;
        self.tcpSocket=[[AsyncSocket alloc]initWithDelegate:self];
        NSLog(@"连接外网tcp的时候ip=%@ port=%d",ip,port);
        if(![self.tcpSocket connectToHost:ip onPort:port withTimeout:2.5 error:&erro ]){
            NSLog(@"连接外网TCP错误");
        }
    }@catch(NSException *e){
        NSLog(@"连接外网TCP获取到异常%@",e);
    }
}

- (void)sendTcpInfos{
    NSString* str= self.tcpSendTextField.text;
    NSData *sendData=[str dataUsingEncoding:NSUTF8StringEncoding];
    [self.tcpSocket writeData:sendData withTimeout:-1 tag:0];

}


/*******************TCP Socket End***************************/

@end

