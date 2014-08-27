//
//  AboutViewController.m
//  我占你坐
//
//  Created by yu_hao on 5/19/14.
//  Copyright (c) 2014 GraphicSound. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
{
    int baseHeight;
    int gap;
    int frameWidth;
    int frameHeight;
    
    UIScrollView *scrollView;
}

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view.backgroundColor = [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1];;
        
        // 设置tabBar的title
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"关于" image:[UIImage imageNamed:@"tab_about"] tag:1];
        
        baseHeight = 64 + 20; // 以statusBar作为基准
        gap = 10;
        
        scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:scrollView];
        [self addShowContent];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    // 很贱，必须要在这里设置contentSize，就算是viewDidLoad都不行
    [scrollView setContentSize:CGSizeMake(320, 568)];
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

- (void)addShowContent {
    // 逐一添加展示内容
    
    // 添加logo
    /*
    frameWidth = 200;
    frameHeight = 50;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake([self getX], baseHeight, frameWidth, frameHeight)];
    [self updateBaseHeightWithGap:40]; // logo之后可以把间距拉开一点
    [scrollView addSubview:logoImageView];
    logoImageView.image = [UIImage imageNamed:@"logo_temp"];
    
    logoImageView.backgroundColor = [UIColor whiteColor];
     */
    
    // 添加navigationBar
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    [self.view addSubview:navigationBar];
    // 添加一个标题
    //navigationBar.topItem.title = @"编辑"; // 像topItem这些变量，如果不在一个确切的NC里面，是nil的
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 160, 44)];
    titleLabel.text = @"我占你坐";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationBar addSubview:titleLabel];
    
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    
    // 添加designLabel
    frameWidth = 200;
    frameHeight = 20;
    UILabel *designLabel = [[UILabel alloc] initWithFrame:CGRectMake([self getX], baseHeight, frameWidth, frameHeight)];
    [self updateBaseHeightWithGap:gap]; // 下一个是个性签名，所以gap弄小一点
    [scrollView addSubview:designLabel];
    
    // designLabel.backgroundColor = [UIColor whiteColor];
    designLabel.text = @"Developed & Designed by:";
    designLabel.textAlignment = NSTextAlignmentCenter;
    [designLabel setFont:[UIFont systemFontOfSize:13]];
    
    // 添加头像
    frameWidth = 100;
    frameHeight = 100;
    UIImageView *myHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake([self getX], baseHeight, frameWidth, frameHeight)];
    [self updateBaseHeightWithGap:gap];
    [scrollView addSubview:myHeaderImageView];
    myHeaderImageView.image = [UIImage imageNamed:@"social_header"];
    
    myHeaderImageView.backgroundColor = [UIColor lightGrayColor];
    myHeaderImageView.layer.cornerRadius = myHeaderImageView.frame.size.height / 2;
    myHeaderImageView.layer.masksToBounds = YES;
    myHeaderImageView.layer.borderWidth = 4;
    myHeaderImageView.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1].CGColor;
    
    // 添加下面的昵称label
    frameWidth = 200;
    frameHeight = 34;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake([self getX], baseHeight, frameWidth, frameHeight)];
    [self updateBaseHeightWithGap:4]; // 下一个是个性签名，所以gap弄小一点
    [scrollView addSubview:nameLabel];
    
    // nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.text = @"余浩 | iyuhao.com";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [nameLabel setFont:[UIFont boldSystemFontOfSize:17]];
    
    // 添加个性签名
    frameWidth = 200;
    frameHeight = 20;
    UILabel *signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake([self getX], baseHeight, frameWidth, frameHeight)];
    [self updateBaseHeightWithGap:gap];
    [scrollView addSubview:signatureLabel];
    
    // signatureLabel.backgroundColor = [UIColor whiteColor];
    signatureLabel.text = @"I am the GraphicSound";
    signatureLabel.textAlignment = NSTextAlignmentCenter;
    [signatureLabel setFont:[UIFont italicSystemFontOfSize:13]];
    
    // 添加分隔符，用uiview代替
    [self addSeparatorView];
    
    // 添加三个社交平台的快捷按钮
    frameWidth = 50;
    frameHeight = 50;
    UIButton *websiteButton = [[UIButton alloc] initWithFrame:CGRectMake(40, baseHeight, frameWidth, frameHeight)];
    [scrollView addSubview:websiteButton];
    [websiteButton setImage:[UIImage imageNamed:@"social_wp"] forState:UIControlStateNormal];
    
    [websiteButton addTarget:self action:@selector(jumpToWeb:) forControlEvents:UIControlEventTouchUpInside];
    
    frameWidth = 50;
    frameHeight = 50;
    UIButton *qqButon = [[UIButton alloc] initWithFrame:CGRectMake([self getX], baseHeight, frameWidth, frameHeight)];
    [scrollView addSubview:qqButon];
    [qqButon setImage:[UIImage imageNamed:@"social_qq"] forState:UIControlStateNormal];
    
    [qqButon addTarget:self action:@selector(jumpToQQ:) forControlEvents:UIControlEventTouchUpInside];
    
    frameWidth = 50;
    frameHeight = 50;
    UIButton *wxButton = [[UIButton alloc] initWithFrame:CGRectMake((320 - 40 - frameWidth), baseHeight, frameWidth, frameHeight)];
    [scrollView addSubview:wxButton];
    [wxButton setImage:[UIImage imageNamed:@"social_wx"] forState:UIControlStateNormal];
    
    [wxButton addTarget:self action:@selector(jumpToWeixin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self updateBaseHeightWithGap:gap];
    
    // 添加分隔符，用uiview代替
    [self addSeparatorView];
    
    // 添加介绍
    frameWidth = 220;
    frameHeight = 50;
    UILabel *introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake([self getX], baseHeight, frameWidth, frameHeight)];
    [self updateBaseHeightWithGap:gap];
    [scrollView addSubview:introductionLabel];
    
    // introductionLabel.backgroundColor = [UIColor whiteColor];
    introductionLabel.text = @"Founder of GraphicSound team. With sincere pleasure.";
    introductionLabel.numberOfLines = 0;
    introductionLabel.textAlignment = NSTextAlignmentCenter;
    [introductionLabel setFont:[UIFont systemFontOfSize:13]];
}

- (int)getX {
    return ((320 - frameWidth) / 2);
}

- (void)updateBaseHeightWithGap:(int)aGap {
    baseHeight += (frameHeight + aGap);
}

- (void)addSeparatorView {
    frameWidth = 270;
    frameHeight = 1;
    UIView *lineVeiw = [[UIView alloc] initWithFrame:CGRectMake([self getX], baseHeight, frameWidth, frameHeight)];
    [self updateBaseHeightWithGap:gap]; // 分隔符下面看来也不能太开
    [scrollView addSubview:lineVeiw];
    
    lineVeiw.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
}

#pragma 3 jump actions

- (void)jumpToWeb:(id)sender {
    NSURL *webURL = [NSURL URLWithString:@"http://iyuhao.com"];
    [[UIApplication sharedApplication] openURL:webURL];
}

- (void)jumpToQQ:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"感谢" message:@"欢迎添加我(805877729)为你的QQ好友" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
    [alertView show];
}

- (void)jumpToWeixin:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"感谢" message:@"欢迎添加我(805877729)为你的微信好友" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([alertView.message isEqualToString:@"欢迎添加我(805877729)为你的QQ好友"]) {
            NSURL *qqURL = [NSURL URLWithString:@"mqq://"];
            [[UIApplication sharedApplication] openURL:qqURL];
        } else {
            NSURL *weixinURL = [NSURL URLWithString:@"weixin://"];
            [[UIApplication sharedApplication] openURL:weixinURL];
        }
    }
}

@end
