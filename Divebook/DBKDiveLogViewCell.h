//
//  DBKDiveLogViewCell.h
//  Divebook
//
//  Created by AndyYou on 2014/8/14.
//  Copyright (c) 2014年 AndyYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBKDiveLogViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *month;
@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *placeName;
@property (strong, nonatomic) IBOutlet UILabel *maxDepth;
@property (strong, nonatomic) IBOutlet UIImageView *weather;
@property (strong, nonatomic) IBOutlet UILabel *wave;
@end
