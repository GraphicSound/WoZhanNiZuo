//
//  EditingViewController.m
//  我占你坐
//
//  Created by yu_hao on 5/20/14.
//  Copyright (c) 2014 GraphicSound. All rights reserved.
//

#import "EditingViewController.h"

#import "TPKeyboardAvoidingScrollView.h"
#import "UIPlaceHolderTextView.h"
#import "UIInsetTextField.h"

#import "AppDelegate.h"

@interface EditingViewController ()
{
    TPKeyboardAvoidingScrollView *scrollView;
    
    NSMutableData *_responseData;
    
    int takeOrGive;
    UIButton *takeButton;
    UIButton *giveButton;
    UIInsetTextField *phoneTextField;
    UIInsetTextField *roomTextField;
    UIPlaceHolderTextView *contentTextView;
    
    NSString *schoolDBNameCopy;
}

@end

@implementation EditingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // 先检查一下能不能获取到AppDelegate的变量
        AppDelegate *appDel=(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSLog(@"appDel.schoolDBName:%@", appDel.schoolDBName);
        schoolDBNameCopy = appDel.schoolDBName;
        
        // 为了保证和naviBar默认的颜色一致
        self.view.backgroundColor = [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1];
        
        // 首先添加一个防止键盘遮挡的scrollView，注意与下面nav的层次关系
        scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
        [scrollView setScrollEnabled:YES];
        [self.view addSubview:scrollView];
        
        // 添加一个navigationBar
        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
        [self.view addSubview:navigationBar];
        // 添加一个标题
        //navigationBar.topItem.title = @"编辑"; // 像topItem这些变量，如果不在一个确切的NC里面，是nil的
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 60, 44)];
        titleLabel.text = @"编辑";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [navigationBar addSubview:titleLabel];
        
        [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        // 添加左边的取消按钮
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1];
        [cancelButton addTarget:self action:@selector(cancelViewController:) forControlEvents:UIControlEventTouchUpInside];
        [navigationBar addSubview:cancelButton];
        // 添加右边的发布按钮
        UIButton *publishButton = [[UIButton alloc] initWithFrame:CGRectMake(320-0-60, 0, 60, 44)];
        [publishButton setTitle:@"发布" forState:UIControlStateNormal];
        [publishButton setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
        [publishButton addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
        [navigationBar addSubview:publishButton];
        
        // 添加两个按钮，表示分类
        takeButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 80, 80, 80)];
        [takeButton setTitle:@"求座" forState:UIControlStateNormal];
        takeButton.titleLabel.textColor = [UIColor blueColor]; // 很奇怪，不起作用！！！
        [takeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [takeButton setBackgroundImage:[UIImage imageNamed:@"circle1"] forState:UIControlStateNormal];
        [takeButton addTarget:self action:@selector(take:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:takeButton];
        
        giveButton = [[UIButton alloc] initWithFrame:CGRectMake(320-40-80, 80, 80, 80)];
        [giveButton setTitle:@"献座" forState:UIControlStateNormal];
        giveButton.titleLabel.textColor = [UIColor blueColor];
        [giveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [giveButton setBackgroundImage:[UIImage imageNamed:@"circle0"] forState:UIControlStateNormal];
        [giveButton addTarget:self action:@selector(give:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:giveButton];
        
        // 添加输入电话的textField（可以尝试一下保存，以免再次输入）
        phoneTextField = [[UIInsetTextField alloc] initWithFrame:CGRectMake(0, 180, 320, 40)];
        phoneTextField.placeholder = @"你的手机号";
        phoneTextField.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:phoneTextField];
        
        // 添加输入房间号的textField
        roomTextField = [[UIInsetTextField alloc] initWithFrame:CGRectMake(0, 240, 320, 40)];
        roomTextField.placeholder = @"自习室号";
        roomTextField.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:roomTextField];
        
        // 添加一个textView，用来留言
        contentTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 300, 320, 100)];
        [contentTextView setFont:[UIFont systemFontOfSize:17]];
        contentTextView.placeholder = @"留言";
        contentTextView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:contentTextView];
    }
    return self;
}

- (void)take:(id)sender {
    NSLog(@"take...");
    takeOrGive = 0;
    [self setButtonImage];
}

- (void)give:(id)sender {
    NSLog(@"give...");
    takeOrGive = 1;
    [self setButtonImage];
}

- (void)setButtonImage {
    if (takeOrGive == 0) {
        [takeButton setBackgroundImage:[UIImage imageNamed:@"circle1"] forState:UIControlStateNormal];
        [giveButton setBackgroundImage:[UIImage imageNamed:@"circle0"] forState:UIControlStateNormal];
    } else {
        [takeButton setBackgroundImage:[UIImage imageNamed:@"circle0"] forState:UIControlStateNormal];
        [giveButton setBackgroundImage:[UIImage imageNamed:@"circle1"] forState:UIControlStateNormal];
    }
}

- (void)cancelViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"VC dismissed");
    }];
}

- (void)publish:(id)sender {
    // 先执行输入检查
    if ([phoneTextField.text isEqualToString:@""]) {
        [self showMessage:@"请输入你的电话号码，方便别人直接联系到你"];
        return;
    }
    if ([roomTextField.text isEqualToString:@""]) {
        [self showMessage:@"请输入你所在的自习室号"];
        return;
    }
    if ([contentTextView.text isEqualToString:@""]) {
        [self showMessage:@"请输入一段简短信息，比如你可以提一定的要求"];
        return;
    }
    
    NSLog(@"publishing...");
    
    NSMutableString *dataUrl = [[NSMutableString alloc] init];
    [dataUrl appendString:serverUrl];
    [dataUrl appendString:[NSString stringWithFormat:@"/library.php?schoolDBName=%@", schoolDBNameCopy]];
    dataUrl = (NSMutableString *)[dataUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:dataUrl]
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:20];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"WebKitFormBoundarycC4YiaUFwM44F6rT";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *dateSring = nil;
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    dateSring = [formatter stringFromDate:date];
    
    // DeviceID
    // 先处理DeviceID里面的dash
    NSMutableString *finalDeviceID = [[NSMutableString alloc] initWithString:DeviceID];
    [finalDeviceID deleteCharactersInRange:NSMakeRange(8, 1)];
    [finalDeviceID deleteCharactersInRange:NSMakeRange(12, 1)];
    [finalDeviceID deleteCharactersInRange:NSMakeRange(16, 1)];
    [finalDeviceID deleteCharactersInRange:NSMakeRange(20, 1)];
    // 源字符串太长，先除掉最开始的4个
    [finalDeviceID deleteCharactersInRange:NSMakeRange(0, 4)];
    
    [self addString:finalDeviceID byName:@"DeviceID" toBodyData:body withBoundary:boundary];
    
    // phoneNumber
    [self addString:phoneTextField.text byName:@"phoneNumber" toBodyData:body withBoundary:boundary];
    
    // type
    [self addString:[NSString stringWithFormat:@"%d", takeOrGive] byName:@"type" toBodyData:body withBoundary:boundary];
    
    // room
    [self addString:roomTextField.text byName:@"room" toBodyData:body withBoundary:boundary];
    
    // content
    // 尝试将手机的名字加进去
    NSMutableString *contentString = [[NSMutableString alloc] initWithFormat:@"%@: ", [UIDevice currentDevice].name];
    [contentString appendString:contentTextView.text];
    [self addString:contentString byName:@"content" toBodyData:body withBoundary:boundary];
    
    // postDate
    [self addString:dateSring byName:@"postDate" toBodyData:body withBoundary:boundary];
    
    [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:body];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request
                                                                  delegate:self
                                                          startImmediately:YES];
    NSLog(@"%@", connection); // 仅仅是为了编译器不报错
}

    // 用来往http header里面添加string信息的函数
- (void)addString:(NSString *)string byName:(NSString *)name toBodyData:(NSMutableData *)body withBoundary:(NSString *)boundary {
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", string] dataUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
    NSString *respondString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", respondString);
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connection did finish loading");
    
    //成功的话，我们暂时就隐藏VC
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error:%@",[error localizedDescription]);
}

- (void)showMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)viewWillAppear:(BOOL)animated {
    // 很贱，必须要在这里设置contentSize，就算是viewDidLoad都不行
    [scrollView setContentSize:CGSizeMake(320, 568)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
