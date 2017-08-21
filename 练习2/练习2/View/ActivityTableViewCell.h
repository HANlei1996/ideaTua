//
//  ActivityTableViewCell.h
//  练习2
//
//  Created by admin on 17/7/25.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *activiImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infolabel;
@property (weak, nonatomic) IBOutlet UILabel *lakeLabel;
@property (weak, nonatomic) IBOutlet UILabel *neirong;
@property (weak, nonatomic) IBOutlet UIButton *favoBtn;

@end
