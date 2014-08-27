//
//  AppDelegate.h
//  我占你坐
//
//  Created by yu_hao on 5/19/14.
//  Copyright (c) 2014 GraphicSound. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// 既然appDelegate本身就是一个singleton，就在这里添加一个变量
@property NSString *schoolDBName;

@end
