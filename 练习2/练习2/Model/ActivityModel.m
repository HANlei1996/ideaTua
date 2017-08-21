//
//  ActivityModel.m
//  练习2
//
//  Created by admin on 17/7/26.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel



-(id)initWithDictionary:(NSDictionary *)dict{
    /*if ([dict[@"imgURL"] isKindOfClass:[NSNull class]]) {
     _imgUrl = @"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_2_0B28535F-B789-4E8B-9B5D-28DEDB728E9A";
    }else{
    _imgUrl = dict[@"imURL"];
    
     }*/
    self=[super init];
    if(self){
    
    self.imgUrl = [dict[@"imgUrl"] isKindOfClass:[NSNull class]] ? @"" : dict[@"imgUrl"] ;
    self.name=[dict[@"name"] isKindOfClass:[NSNull class]] ?@"活动":dict[@"name"];
    self.neirong=[dict[@"content"] isKindOfClass:[NSNull class]] ?@"暂无内容":dict[@"content"];
    self.like=[dict[@"like"]isKindOfClass:[NSNull class]]?0:[dict[@"like"]integerValue];
    self.unlike=[dict[@"unlike"]isKindOfClass:[NSNull class]]?0:[dict[@"unlike"]integerValue];
    self.isFavo = [dict[@"isFavo"] isKindOfClass:[ NSNull class]] ? NO:[dict[@"isFavo"] boolValue];
    
     }
    return self;
}
@end
