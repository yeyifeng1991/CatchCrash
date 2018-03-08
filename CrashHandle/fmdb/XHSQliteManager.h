//
//  XHSQliteManager.h
//  QiMu
//
//  Created by XH on 16/11/18.
//  Copyright © 2016年 XH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHPlanFilterModel.h"
#import "XHMaterialFilterModel.h"
#import "XHProductionFilterModel.h"

@interface XHSQliteManager : NSObject
XHSingletonH(XHSQliteManager)
//删除用户数据库表
- (void)deleteUserTableComplete:(void(^)(BOOL success,id obj))complete;
//删除筛选数据库表
- (void)deleteFilterTableComplete:(void(^)(BOOL success,id obj))complete;

#pragma mark - 用户
//储存用户信息
- (void)updateaUser:(XHUserModel *)aDyn complete:(void (^)(BOOL success,id obj))complete;
//查询用户信息
- (void)queryaUser:(XHUserModel *)aDyn userInfo:(NSDictionary *)userInfo complete:(void (^)(BOOL success, id obj))complete;
//删除用户信息
- (void)deleteUser:(XHUserModel *)dyn userInfo:(NSDictionary *)userInfo complete:(void(^)(BOOL success,id obj))complete;

#pragma mark - 鞋样筛选属性
//鞋样筛选
//更新
- (void)updateProduction:(NSArray <XHProductionFilterModel *>*)dynList complete:(void (^)(BOOL success,id obj))complete;
//条件查询 (一条)
- (void)queryProduction:(XHProductionFilterModel *)model UserInfo:(NSDictionary *)infoDic fuzzyUserInfo:(NSDictionary *)fuzzyDic complete:(void (^)(BOOL success, id obj))complete;
// 条件查询 (多条) 对查询一条的扩展，本质是一次查询一条
- (void)queryProductionMore:(XHProductionFilterModel *)model UserInfo:(NSArray <NSDictionary *> *)infoArr complete:(void (^)(BOOL success, id obj))complete;
// 条件查询 (多条) 会遍历整张表，满足条件的放到返回数组里
- (void)queryProductionMoreWithUserInfo:(NSDictionary *)userInfo fuzzyUserInfo:(NSDictionary *)fuzzyUserInfo complete:(void (^)(BOOL success,NSMutableArray *modelArr))complete;
//删除
- (void)deleteProduction:(NSArray <XHProductionFilterModel *>*)dynList complete:(void(^)(BOOL success,id obj))complete;
#pragma mark - 鞋材筛选属性
//更新
- (void)updateMaterial:(NSArray <XHMaterialFilterModel *>*)dynList complete:(void (^)(BOOL success,id obj))complete;
//条件查询 (一条)
- (void)queryMaterialWithUserInfo:(NSDictionary *)infoDic fuzzyUserInfo:(NSDictionary *)fuzzyDic complete:(void (^)(BOOL success, XHMaterialFilterModel  *model))complete;
// 条件查询 (多条)不传条件输出整个表
- (void)queryMaterialMoreWithUserInfo:(NSDictionary *)userInfo fuzzyUserInfo:(NSDictionary *)fuzzyUserInfo complete:(void (^)(BOOL success,NSMutableArray *modelArr))complete;
//删除
- (void)deleteMaterial:(NSArray <XHMaterialFilterModel *>*)dynList complete:(void(^)(BOOL success,id obj))complete;
#pragma mark - 工厂筛选属性
//更新
- (void)updatePlan:(NSArray <XHPlanFilterModel *>*)dynList complete:(void (^)(BOOL success,id obj))complete;
//查询
- (void)queryPlan:(NSArray<XHPlanFilterModel *>*)dynList complete:(void (^)(BOOL, id))complete;
//删除
- (void)deletePlan:(NSArray <XHPlanFilterModel *>*)dynList complete:(void(^)(BOOL success,id obj))complete;

#pragma mark - 地区
//省份
//更新
- (void)updateAreaProvince:(NSArray <XHProvinceModel *>*)dynList complete:(void (^)(BOOL success,id obj))complete;
//条件查询 (一条)
- (void)queryAreaProvinceWithUserInfo:(NSDictionary *)infoDic fuzzyUserInfo:(NSDictionary *)fuzzyDic complete:(void (^)(BOOL success, XHProvinceModel  *model))complete;
// 条件查询 (多条)不传条件输出整个表
- (void)queryAreaProvinceMoreWithUserInfo:(NSDictionary *)userInfo fuzzyUserInfo:(NSDictionary *)fuzzyUserInfo complete:(void (^)(BOOL success,NSMutableArray *modelArr))complete;
//删除
- (void)deleteAreaProvince:(NSArray <XHProvinceModel *>*)dynList complete:(void(^)(BOOL success,id obj))complete;

//城市
//更新
- (void)updateAreaCity:(NSArray <XHCityModel *>*)dynList complete:(void (^)(BOOL success,id obj))complete;
//条件查询 (一条)
- (void)queryAreaCityWithUserInfo:(NSDictionary *)infoDic fuzzyUserInfo:(NSDictionary *)fuzzyDic complete:(void (^)(BOOL success, XHCityModel  *model))complete;
// 条件查询 (多条)不传条件输出整个表
- (void)queryAreaCityMoreWithUserInfo:(NSDictionary *)userInfo fuzzyUserInfo:(NSDictionary *)fuzzyUserInfo complete:(void (^)(BOOL success,NSMutableArray *modelArr))complete;
//删除
- (void)deleteAreaCity:(NSArray <XHCityModel *>*)dynList complete:(void(^)(BOOL success,id obj))complete;

@end
