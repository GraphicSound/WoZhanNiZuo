//
//  MainViewController.h
//  我占你坐
//
//  Created by yu_hao on 5/19/14.
//  Copyright (c) 2014 GraphicSound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property UITableView *mainTableView;

@end
