//
//  MainViewController.m
//  我占你坐
//
//  Created by yu_hao on 5/19/14.
//  Copyright (c) 2014 GraphicSound. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "ManageViewController.h"
#import "CustomButton.h"

#import "AppDelegate.h"

#import "TSPopoverController.h"
#import "TSActionSheet.h"

#import "MJRefresh.h"

#import "YHLoadHeaderImage.h"

@interface MainViewController ()
{
    NSMutableArray *_dataContainer;
    int _maxID;
    int _minID;
    
    NSString *schoolName;
    NSString *schoolDBName;
    UIBarButtonItem *categoryBarButton;
    
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    UIScrollView *imageScrollView;
    UIPageControl *pageControl;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // 首先初始化dataContainer
        _dataContainer = [[NSMutableArray alloc] init];
        _maxID = 0;
        _minID = 0;
        
        schoolName = @"林大";
        schoolDBName = @"zz_bjfu";
        
        // 先检查一下能不能获取到AppDelegate的变量
        AppDelegate *appDel=(AppDelegate *)[UIApplication sharedApplication].delegate;
        appDel.schoolDBName = schoolDBName;
        
        self.view.backgroundColor = [UIColor redColor];
        
        // 设置tabBar的title
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"找座位" image:[UIImage imageNamed:@"tab_find"] tag:0];
        
        // 设置navigationController
        self.navigationItem.title = @"我占你坐";
        // 添加左边分类选项按钮
        categoryBarButton = [[UIBarButtonItem alloc] initWithTitle:schoolName style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet:forEvent:)];
        self.navigationItem.leftBarButtonItem = categoryBarButton;
        // 添加右边管理选项按钮
        UIBarButtonItem *manageBarButton = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(manage:)];
        self.navigationItem.rightBarButtonItem = manageBarButton;
        
        // 添加tableView
        self.mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.mainTableView.dataSource = self;
        self.mainTableView.delegate = self;
        [self.view addSubview:self.mainTableView];
        // 配置tableView
        [self.mainTableView setSeparatorInset:UIEdgeInsetsZero]; // 防止separator过短
        self.mainTableView.allowsSelection = NO; // 不允许选中
        // tableView添加下拉和上拉刷新控件
        [self addHeader];
        [self addFooter];
        // 添加headerView
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
        headerView.backgroundColor = [UIColor redColor];
        self.mainTableView.tableHeaderView = headerView;
        // 添加滑动视图
        imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 160)];
        imageScrollView.delegate = self;
        imageScrollView.pagingEnabled = YES;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        [imageScrollView setContentSize:CGSizeMake(headerView.frame.size.width * 3, 160)]; // 三张图片足矣
        [headerView addSubview:imageScrollView];
        // 分别向滑动视图里添加三张照片视图
        [YHLoadHeaderImage retriveImageForScrollView:imageScrollView];
        // 添加pageControl
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((320 - 40)/2, 160-40, 40, 40)];
        pageControl.numberOfPages = 3;
        pageControl.currentPage = 0;
        [headerView addSubview:pageControl];
    }
    return self;
}

#pragma scrollView delegate protocol

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = imageScrollView.frame.size.width;
    int page = floor((imageScrollView.contentOffset.x - pageWidth / 2 ) / pageWidth) + 1; // this provide you the page number
    pageControl.currentPage = page; // this displays the white dot as current page
}

#pragma tableView dataSource protocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataContainer.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cell";
    MainTableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
    // 设置minID
    if (_minID == 0) {
        _minID = cell.idNumber.intValue;
    } else {
        if (cell.idNumber.intValue < _minID) {
            _minID = cell.idNumber.intValue;
        }
    }
    // 设置maxID
    if (_maxID == 0) {
        _maxID = cell.idNumber.intValue;
    } else {
        if (cell.idNumber.intValue > _maxID) {
            _maxID = cell.idNumber.intValue;
        }
    }
    
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
    [cell.callButton addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.callButton setImage:[UIImage imageNamed:@"phone_call"] forState:UIControlStateNormal];
    cell.callButton.phoneNumber = [tempDic objectForKey:@"phoneNumber"];
    [cell.messageButton addTarget:self action:@selector(messageAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.messageButton setImage:[UIImage imageNamed:@"phone_message"] forState:UIControlStateNormal];
    cell.messageButton.phoneNumber = [tempDic objectForKey:@"phoneNumber"];
    [cell.favourButton addTarget:self action:@selector(favourAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.favourButton.idNumber = [tempDic objectForKey:@"id"];
    
    // 把row传到button上，这要好之后更新_dataContainer
    cell.favourButton.rowNumber = indexPath.row;
    NSString *thumbUpAmount = [tempDic objectForKey:@"thumbUpAmount"];
    cell.favourButton.tempThumbUpAmount = thumbUpAmount;
    [cell.favourButton setTitle:[NSString stringWithFormat:@"赞(%@)", thumbUpAmount] forState:UIControlStateNormal];
    
    cell.deviceID = [tempDic objectForKey:@"deviceID"];
    cell.phoneNumber = [tempDic objectForKey:@"phoneNumber"];
    cell.contentLabel.text = [tempDic objectForKey:@"content"];
    // [cell.contentLabel setTextColor:[UIColor darkGrayColor]];
    cell.dateLabel.text = [tempDic objectForKey:@"postDate"];
    
    return cell;
}

#pragma tableView delegate protocol

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)callAction:(id)sender {
    CustomButton *button = sender;
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", button.phoneNumber]];
    [[UIApplication sharedApplication] openURL:telURL];
}

- (void)messageAction:(id)sender {
    CustomButton *button = sender;
    NSURL *smsURL = [NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", button.phoneNumber]];
    [[UIApplication sharedApplication] openURL:smsURL];
}

- (void)favourAction:(id)sender {
    CustomButton *tempButton = sender;
    NSLog(@"赞id:%@", tempButton.idNumber);
    
    NSString *retrieveUpdateString = [NSString stringWithFormat:@"%@/library-api.php?schoolDBName=%@&api=4&id=%@", serverUrl, schoolDBName, tempButton.idNumber];
    NSURL *retrieveUpdateUrl = [NSURL URLWithString:[retrieveUpdateString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    dispatch_async(kBgQueue, ^{
        NSError* error = nil;
        NSString *responseString = [NSString stringWithContentsOfURL:retrieveUpdateUrl encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"返回赞id:%@", responseString);
        
        if ([responseString isEqualToString:@"1"]) {
            [self performSelectorOnMainThread:@selector(updateFavourButton:)
                                   withObject:tempButton
                                waitUntilDone:YES];
        }
    });
}

- (void)updateFavourButton:(CustomButton *)tempButton {
    // 如果返回值是1就表明成功赞了，我们不用再次联网刷新数据，只需要更新本地数据
    tempButton.tempThumbUpAmount = [NSString stringWithFormat:@"%d", tempButton.tempThumbUpAmount.intValue + 1];
    [tempButton setTitle:[NSString stringWithFormat:@"赞(%@)", tempButton.tempThumbUpAmount] forState:UIControlStateNormal];
    
    // 先获得对应信息的dic，注意要mutableCopy
    NSMutableDictionary *tempDic = [[_dataContainer objectAtIndex:tempButton.rowNumber] mutableCopy];
    [tempDic setValue:[NSString stringWithFormat:@"%d", tempButton.tempThumbUpAmount.intValue] forKey:@"thumbUpAmount"];
    
    // 替换掉原来的dic
    [_dataContainer replaceObjectAtIndex:tempButton.rowNumber withObject:tempDic];
}

#pragma navigationBar customization

- (void)showActionSheet:(id)sender forEvent:(UIEvent*)event
{
    TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:@"选择学校"];
    // [actionSheet destructiveButtonWithTitle:@"北京林业大学" block:nil];
    [actionSheet addButtonWithTitle:@"北京林业大学" block:^{
        [self checkSchoolDBName:@"zz_bjfu" WithChinese:@"林大"];
    }];
    [actionSheet addButtonWithTitle:@"北京语言大学" block:^{
        [self checkSchoolDBName:@"zz_blcu" WithChinese:@"北语"];
    }];
    [actionSheet addButtonWithTitle:@"中国地质大学" block:^{
        [self checkSchoolDBName:@"zz_cug" WithChinese:@"地大"];
    }];
    [actionSheet addButtonWithTitle:@"四川大学" block:^{
        [self checkSchoolDBName:@"zz_scu" WithChinese:@"川大"];
    }];
    [actionSheet cancelButtonWithTitle:@"取消" block:nil];
    actionSheet.cornerRadius = 5;
    
    [actionSheet showWithTouch:event];
}

- (void)checkSchoolDBName:(NSString *)english WithChinese:(NSString *)chinese {
    if ([schoolDBName isEqualToString:english] == 0) {
        schoolName = chinese;
        schoolDBName = english;
        [categoryBarButton setTitle:schoolName];
        
        // 更新AppDelegate变量
        AppDelegate *appDel=(AppDelegate *)[UIApplication sharedApplication].delegate;
        appDel.schoolDBName = schoolDBName;
        
        [_header beginRefreshing];
    }
}

- (void)manage:(id)sender {
    ManageViewController *manageViewController = [[ManageViewController alloc] init];
    [manageViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:manageViewController animated:YES completion:nil];
}

- (void)doEdit:(id)sender {
    [self.mainTableView setEditing:NO animated:YES];
    
    // 添加左边分类选项按钮
    // UIBarButtonItem *categoryBarButton = [[UIBarButtonItem alloc] initWithTitle:@"学校" style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet:forEvent:)];
    self.navigationItem.leftBarButtonItem = categoryBarButton;
    
    // 添加右边管理选项按钮
    UIBarButtonItem *manageBarButton = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(manage:)];
    self.navigationItem.rightBarButtonItem = manageBarButton;
}

#pragma MJRefresh stuff

- (void)addHeader
{
    __unsafe_unretained MainViewController *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.mainTableView;
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        
        // 增加5条假数据
        NSString *retrieveUpdateString = [NSString stringWithFormat:@"%@/library-api.php?schoolDBName=%@&api=1&minID=%d&maxID=%d", serverUrl, schoolDBName, _minID, _maxID];
        NSLog(@"_minID=%d _maxID=%d", _minID, _maxID);
        NSURL *retrieveUpdateUrl = [NSURL URLWithString:[retrieveUpdateString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSError* error = nil;
        NSData* data = [NSData dataWithContentsOfURL:retrieveUpdateUrl
                                             options:NSDataReadingUncached
                                               error:&error]; // 居然能如此简单！！！
        if (error) {
            NSLog(@"retrieveUpdateFromServer error");
        } else
        {
            NSString *parseType = @"1";
            [self performSelectorOnMainThread:@selector(parseUpdateData:)
                                   withObject:@[data, parseType]
                                waitUntilDone:YES];
            NSLog(@"拉取数据成功，大小共为%fKB", data.length/1024.0);
        }
        
        // 模拟延迟加载数据，因此2秒后才调用
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.0];
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    
    // 程序刚启动时候一旦加载header就会开始更新
    [header beginRefreshing];
    
    _header = header;
}

- (void)addFooter
{
    __unsafe_unretained MainViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.mainTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        
        // 增加5条假数据
        NSString *retrieveUpdateString = [NSString stringWithFormat:@"%@/library-api.php?schoolDBName=%@&api=2&minID=%d", serverUrl, schoolDBName, _minID];
        NSURL *retrieveUpdateUrl = [NSURL URLWithString:[retrieveUpdateString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSError* error = nil;
        NSData* data = [NSData dataWithContentsOfURL:retrieveUpdateUrl
                                             options:NSDataReadingUncached
                                               error:&error]; // 居然能如此简单！！！
        if (error) {
            NSLog(@"retrieveUpdateFromServer error");
        } else
        {
            NSString *parseType = @"2";
            [self performSelectorOnMainThread:@selector(parseUpdateData:)
                                   withObject:@[data, parseType]
                                waitUntilDone:YES];
            NSLog(@"拉取数据成功，大小共为%fKB", data.length/1024.0);
        }
        
        // 模拟延迟加载数据，因此2秒后才调用
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:0.0];
    };
    
    _footer = footer;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.mainTableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
