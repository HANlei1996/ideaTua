//
//  ActivityModel.h
//  练习2
//
//  Created by admin on 17/7/26.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject
@property(strong,nonatomic) NSString *activityId;
@property (strong,nonatomic)NSString *imgUrl;//定义活动图片url字符串
@property(strong,nonatomic) NSString *name;//活动名称
@property(strong,nonatomic) NSString *neirong;//活动内容
@property (nonatomic) NSInteger like;//点赞数
@property(nonatomic) NSInteger unlike;//被踩数
@property(nonatomic) BOOL isFavo;//是否被收藏

-(id)initWithDictionary:(NSDictionary *)dict; 
@end
