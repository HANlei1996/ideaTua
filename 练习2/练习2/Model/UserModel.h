//
//  UserModel.h
//  练习2
//
//  Created by admin on 2017/8/23.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property(strong,nonatomic) NSString *memberId;//用户ID
@property(strong,nonatomic) NSString *phone;//手机号
@property(strong,nonatomic) NSString *nickname;//名称
@property(strong,nonatomic) NSString *age;//年龄
@property(strong,nonatomic) NSString *dob;//出身日期
@property(strong,nonatomic) NSString *idCardNo;//身份证号
@property(strong,nonatomic) NSString *gender;//性别
@property(strong,nonatomic) NSString *credit;//积分
@property(strong,nonatomic) NSString *avatarUrl;//头像
@property(strong,nonatomic) NSString *tokenKey;//

-(id)initWithDictionary:(NSDictionary *)dict;

@end
