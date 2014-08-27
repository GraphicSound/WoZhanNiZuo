//
//  CustomButton.m
//  我占你坐
//
//  Created by yu_hao on 5/22/14.
//  Copyright (c) 2014 GraphicSound. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.phoneNumber = @"15520391111";
        self.idNumber = @"1";
        self.tempThumbUpAmount = @"0";
        
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
