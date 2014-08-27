//
//  MainNavigationBar.m
//  我占你坐
//
//  Created by yu_hao on 5/19/14.
//  Copyright (c) 2014 GraphicSound. All rights reserved.
//

#import "MainNavigationBar.h"

@implementation MainNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        UINavigationItem *titleItem = [[UINavigationItem alloc] init];
//        titleItem.title = @"林大图书馆座位分享社区";
        
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 20, 100, 44)];
//        titleLabel.text = @"林大图书馆座位分享社区";
//        self.topItem.titleView = titleLabel;
        
        /*
        self.topItem.title = @"林大图书馆座位分享社区";
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
        shadow.shadowOffset = CGSizeMake(0, 1);
        [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                               [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                               shadow, NSShadowAttributeName,
                                                               [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
         */
        
        // 既然不能显示title，那就自己添加一个label
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];
        titleLabel.text = @"林大图书馆座位分享社区";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        // 添加左边分类选项按钮
        UIBarButtonItem *categoryBarButton = [[UIBarButtonItem alloc] init];
        categoryBarButton.title = @"分类";
        self.topItem.leftBarButtonItem = categoryBarButton;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
