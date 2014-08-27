//
//  RootViewController.m
//  我占你坐
//
//  Created by yu_hao on 5/19/14.
//  Copyright (c) 2014 GraphicSound. All rights reserved.
//

#import "RootViewController.h"
#import "NavigationController.h"
#import "MainViewController.h"
#import "AboutViewController.h"
#import "EditingViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // 初始化tab，创建两个视图控制器
        MainViewController *mainViewController = [[MainViewController alloc] init];
        AboutViewController *aboutViewController = [[AboutViewController alloc] init];
        NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:mainViewController];
        
        self.viewControllers = @[navigationController, aboutViewController];
        
        // 配置tabBar下面的button
        /*
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                        target:self
                                        action:nil];
         */
        
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 0, 80, 40)];
        // [addButton setTitle:@"add" forState:UIControlStateNormal];
        // addButton.backgroundColor = [UIColor redColor];
        [addButton setBackgroundImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(showModalView:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:addButton];
        
        // 添加相应的icon
        // 不对，是要到子视图控制器里面设置
    }
    return self;
}

- (void)showModalView:(id)sender {
    NSLog(@"showing the modal view...");
    
    EditingViewController *editingViewController = [[EditingViewController alloc] init];
    [self presentViewController:editingViewController animated:YES completion:^{
        NSLog(@"presented the VC");
    }];
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
