//
//  ManageViewController.m
//  我占你坐
//
//  Created by yu_hao on 5/22/14.
//  Copyright (c) 2014 GraphicSound. All rights reserved.
//

#import "ManageViewController.h"
#import "MainTableViewCell.h"

#import "AppDelegate.h"

@interface ManageViewController ()
{
    NSMutableArray *_dataContainer;
    
    NSString *schoolDBNameCopy;
    
    CustomButton *tempButton;
}

@end

@implementation ManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // 先检查一下能不能获取到AppDelegate的变量
        AppDelegate *appDel=(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSLog(@"appDel.schoolDBName:%@", appDel.schoolDBName);
        schoolDBNameCopy = appDel.schoolDBName;
        
        self.view.backgroundColor = [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1];
        
        // 首先初始化dataContainer
        _dataContainer = [[NSMutableArray alloc] init];
        
        // 添加tableView
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
        // self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.view addSubview:self.tableView];
        // 配置tableView
        [self.tableView setSeparatorInset:UIEdgeInsetsZero]; // 防止separator过短
        self.tableView.allowsSelection = NO; // 不允许选中
        
        // 添加一个navigationBar
        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
        [self.view addSubview:navigationBar];
        // 添加一个标题
        // navigationBar.topItem.title = @"编辑"; // 像topItem这些变量，如果不在一个确切的NC里面，是nil的
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 100, 44)];
        titleLabel.text = @"我的发布";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [navigationBar addSubview:titleLabel];
        
        [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
        // 添加左边的取消按钮
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [cancelButton setTitle:@"完成" forState:UIControlStateNormal];
        cancelButton.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1];
        [cancelButton addTarget:self action:@selector(cancelViewController:) forControlEvents:UIControlEventTouchUpInside];
        [navigationBar addSubview:cancelButton];
        /*
        // 添加右边的发布按钮
        UIButton *publishButton = [[UIButton alloc] initWithFrame:CGRectMake(320-0-60, 0, 60, 44)];
        [publishButton setTitle:@"完成" forState:UIControlStateNormal];
        publishButton.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1];
        [publishButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
        [navigationBar addSubview:publishButton];
         */
        
        // 开始获取用户发表的信息
        [self retriveData];
    }
    return self;
}

- (void)retriveData {
    // 先处理DeviceID里面的dash
    NSMutableString *finalDeviceID = [[NSMutableString alloc] initWithString:DeviceID];
    [finalDeviceID deleteCharactersInRange:NSMakeRange(8, 1)];
    [finalDeviceID deleteCharactersInRange:NSMakeRange(12, 1)];
    [finalDeviceID deleteCharactersInRange:NSMakeRange(16, 1)];
    [finalDeviceID deleteCharactersInRange:NSMakeRange(20, 1)];
    // 源字符串太长，先除掉最开始的4个
    [finalDeviceID deleteCharactersInRange:NSMakeRange(0, 4)];
    NSLog(@"处理后的DeviceID:%@", finalDeviceID);
    
    dispatch_async(kBgQueue, ^{
        NSString *retrieveUpdateString = [NSString stringWithFormat:@"%@/library-api.php?schoolDBName=%@&api=3&DeviceID=%@", serverUrl, schoolDBNameCopy, finalDeviceID];
        NSURL *retrieveUpdateUrl = [NSURL URLWithString:[retrieveUpdateString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSError* error = nil;
        NSData* data = [NSData dataWithContentsOfURL:retrieveUpdateUrl
                                             options:NSDataReadingUncached
                                               error:&error]; // 居然能如此简单！！！
        if (error) {
            NSLog(@"retrieveUpdateFromServer error");
        } else
        {
            NSString *parseType = @"3";
            [self performSelectorOnMainThread:@selector(parseUpdateData:)
                                   withObject:@[data, parseType]
                                waitUntilDone:YES];
            NSLog(@"拉取数据成功，大小共为%fKB", data.length/1024.0);
        }
    });
}

- (void)parseUpdateData:(NSArray *)inputData {
    NSData *responseData = [inputData objectAtIndex:0];
    
    NSMutableArray *_tempArrayFromRemoteJson = [[NSMutableArray alloc] init];
    
    // NSString *someString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    // NSLog(@"%@", someString);
    
    // parse out the json data, 一定要小心你接收到的json到底是什么格式的，dictionary还是array
    NSError* error;
    _tempArrayFromRemoteJson = [NSJSONSerialization
                                JSONObjectWithData:responseData //1
                                options:kNilOptions
                                error:&error];
    
    NSLog(@"共获得%d项数据", _tempArrayFromRemoteJson.count);
    
    if ([@"1" isEqualToString:[inputData objectAtIndex:1]]) {
        // 说明是更新数据
        
        // 注意mutableArray指针指向的问题，千万不要重复add原来的对象
        [_dataContainer removeAllObjects];
        [_dataContainer addObjectsFromArray:_tempArrayFromRemoteJson];
    } else if ([@"2" isEqualToString:[inputData objectAtIndex:1]]) {
        // 说明是加载更多数据
        
        [_dataContainer addObjectsFromArray:_tempArrayFromRemoteJson];
    } else if ([@"3" isEqualToString:[inputData objectAtIndex:1]]) {
        // 说明是编辑数据
        
        [_dataContainer removeAllObjects];
        [_dataContainer addObjectsFromArray:_tempArrayFromRemoteJson];
    }
    
    // 刷新
    [self.tableView reloadData];
}

- (void)cancelViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"VC dismissed");
    }];
}

- (void)done:(id)sender {
    NSLog(@"done pressed...");
}

#pragma tableView dataSource protocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataContainer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cell";
    MainTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    // 配置cell
    NSDictionary *tempDic = [_dataContainer objectAtIndex:indexPath.row];
    int imageNumber = indexPath.row % 4 + 1;
    NSString *imageName = [[NSString alloc] initWithFormat:@"circle%d", imageNumber];
    cell.roomImageView.image = [UIImage imageNamed:imageName];
    
    // 检查是不是已经隐藏
    NSString *display = [tempDic objectForKey:@"display"];
    if ([display isEqualToString:@"0"]) {
        cell.roomImageView.image = [UIImage imageNamed:@"circle0"];
    }
    
    cell.idNumber = [tempDic objectForKey:@"id"];
    
    // 生成房间号的label
    UILabel *roomlabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 57, 57)];
    roomlabel.textColor = [UIColor redColor];
    [roomlabel setFont:[UIFont systemFontOfSize:18]];
    roomlabel.textAlignment = NSTextAlignmentCenter;
    roomlabel.text = [tempDic objectForKey:@"room"];
    [cell.contentView addSubview:roomlabel];
    
    // 配置typeButton
    if ([@"0" isEqualToString:[tempDic objectForKey:@"type"]]) {
        [cell.typeButton setTitle:@"求座" forState:UIControlStateNormal];
    } else {
        [cell.typeButton setTitle:@"献座" forState:UIControlStateNormal];
    }
    
    // 配置call和message按钮
    [cell.callButton addTarget:self action:@selector(hideContent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.callButton setImage:[UIImage imageNamed:@"content_hide"] forState:UIControlStateNormal];
    cell.callButton.idNumber = [tempDic objectForKey:@"id"];
    [cell.messageButton addTarget:self action:@selector(deleteContent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.messageButton setImage:[UIImage imageNamed:@"content_delete"] forState:UIControlStateNormal];
    cell.messageButton.idNumber = [tempDic objectForKey:@"id"];
    
    // 把row传到button上，这要好之后更新_dataContainer
    cell.favourButton.rowNumber = indexPath.row;
    NSString *thumbUpAmount = [tempDic objectForKey:@"thumbUpAmount"];
    cell.favourButton.tempThumbUpAmount = thumbUpAmount;
    [cell.favourButton setTitle:[NSString stringWithFormat:@"赞(%@)", thumbUpAmount] forState:UIControlStateNormal];
    cell.favourButton.enabled = NO;
    
    cell.deviceID = [tempDic objectForKey:@"deviceID"];
    cell.phoneNumber = [tempDic objectForKey:@"phoneNumber"];
    cell.contentLabel.text = [tempDic objectForKey:@"content"];
    cell.dateLabel.text = [tempDic objectForKey:@"postDate"];
    
    return cell;
}

#pragma tableView delegate protocol

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)hideContent:(id)sender {
    tempButton = sender;
    NSLog(@"隐藏id:%@", tempButton.idNumber);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你将要注销/激活这条信息(信息的图标会变成灰色/彩色)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"Just Do It", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *retrieveUpdateString = [NSString stringWithFormat:@"%@/library-api.php?schoolDBName=%@&api=5&id=%@", serverUrl, schoolDBNameCopy, tempButton.idNumber];
        NSURL *retrieveUpdateUrl = [NSURL URLWithString:[retrieveUpdateString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        dispatch_async(kBgQueue, ^{
            NSError* error = nil;
            NSString *responseString = [NSString stringWithContentsOfURL:retrieveUpdateUrl encoding:NSUTF8StringEncoding error:&error];
            NSLog(@"返回赞id:%@", responseString);
            
            if ([responseString isEqualToString:@"1"]) {
                [self performSelectorOnMainThread:@selector(checkSucceed:)
                                       withObject:responseString
                                    waitUntilDone:YES];
            }
        });
    }
}

- (void)checkSucceed:(NSString *)responseString {
    if ([responseString isEqualToString:@"1"]) {
        [self retriveData];
    }
}

- (void)deleteContent:(id)sender {
    NSLog(@"deleted...");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeTop;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
