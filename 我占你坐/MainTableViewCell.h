//
//  MainTableViewCell.h
//  我占你坐
//
//  Created by yu_hao on 5/19/14.
//  Copyright (c) 2014 GraphicSound. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface MainTableViewCell : UITableViewCell

@property NSString *idNumber;
@property NSString *phoneNumber;
@property NSString *deviceID;

@property (weak, nonatomic) IBOutlet UIImageView *roomImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet CustomButton *callButton;
@property (weak, nonatomic) IBOutlet CustomButton *messageButton;
@property (weak, nonatomic) IBOutlet CustomButton *favourButton;

- (IBAction)favourAction:(id)sender;

@end
