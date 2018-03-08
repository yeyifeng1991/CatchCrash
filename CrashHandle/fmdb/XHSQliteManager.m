//
//  XHSQliteManager.m
//  QiMu
//
//  Created by XH on 16/11/18.
//  Copyright © 2016年 XH. All rights reserved.
//

#import "XHSQliteManager.h"

#define YHDocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define DynamicPath [YHDocumentDir stringByAppendingPathComponent:@"Dynamic.sqlite"]
#define FilterPath [YHDocumentDir stringByAppendingPathComponent:@"Filter.sqlite"]
//#define AreaPath [YHDocumentDir stringByAppendingPathComponent:@"Area.sqlite"]
@interface XHSQliteManager()

@property(nonatomic,retain) FMDatabaseQueue *dbQueue;
@property(nonatomic,strong) NSMutableArray<NSString *>*maCreatDynTable;     //创表动态语句数组
@property(nonatomic,strong) NSMutableArray<NSString *>*qimuFilterTable;
@property(nonatomic,strong) NSMutableArray<NSString *>*areaTable;

@end

@implementation XHSQliteManager
XHSingletonM(XHSQliteManager)

- (instancetype)init{
    if (self = [super init]) {
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:FilterPath];
    }
    return self;
}

//用户信息表
- (NSMutableArray<NSString *> *)maCreatDynTable{
    if (!_maCreatDynTable) {
        _maCreatDynTable = [NSMutableArray arrayWithCapacity:2];
        
        NSString *usrdb = [XHUserModel yh_sqlForCreateTableWithPrimaryKey:@"id"];
        NSString *usrInfo = [XHUserInfoModel yh_sqlForCreateTableWithPrimaryKey:@"id"];
        
        [_maCreatDynTable addObject:usrdb];
        [_maCreatDynTable addObject:usrInfo];
        
    }
    return _maCreatDynTable;
}
//筛选表
- (NSMutableArray<NSString *>*)qimuFilterTable{
    if (!_qimuFilterTable) {
        _qimuFilterTable = [NSMutableArray arrayWithCapacity:5];
        NSString *planfilter = [XHPlanFilterModel yh_sqlForCreateTableWithPrimaryKey:@"id"];
        NSString *materialFilter = [XHMaterialFilterModel yh_sqlForCreateTableWithPrimaryKey:@"id"];
        NSString *productionFilter = [XHProductionFilterModel yh_sqlForCreateTableWithPrimaryKey:@"id"];
        NSString *province = [XHProvinceModel yh_sqlForCreateTableWithPrimaryKey:@"id"];
        NSString *city = [XHCityModel yh_sqlForCreateTableWithPrimaryKey:@"id"];
        //NSString *
        [_qimuFilterTable addObject:planfilter];
        [_qimuFilterTable addObject:materialFilter];
        [_qimuFilterTable addObject:productionFilter];
        [_qimuFilterTable addObject:province];
        [_qimuFilterTable addObject:city];
    }
    return _qimuFilterTable;
}
/*
//地区表
- (NSMutableArray<NSString *>*)areaTable{
    if (!_areaTable) {
        _areaTable = [NSMutableArray arrayWithCapacity:2];
        
        NSString *province = [XHProvinceModel yh_sqlForCreateTableWithPrimaryKey:@"id"];
        NSString *city = [XHCityModel yh_sqlForCreateTableWithPrimaryKey:@"id"];
        
        [_areaTable addObject:province];
        [_areaTable addObject:city];
    }
    return _areaTable;
}
*/
//建用户表
- (void)creatDynTable{
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:DynamicPath];
    XHLog(@"-----%@--",DynamicPath);
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        for (NSString *sql in self.maCreatDynTable) {
            BOOL ok = [db executeUpdate:sql];
            if (ok == NO) {
                XHLog(@"----NO:%@---",sql);
            }
        }
    }];
}
//建表
- (void)creatFilterTabel{
    //self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:FilterPath];
    XHLog(@"-----%@--",FilterPath);
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        for (NSString *sql in self.qimuFilterTable) {
            BOOL ok = [db executeUpdate:sql];
            if (ok == NO) {
                XHLog(@"----NO:%@---",sql);
            }
        }
    }];
}
/*
//建地区表
-(void)creatAreaTabel{
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:AreaPath];
    XHLog(@"-----%@--",AreaPath);
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        for (NSString *sql in self.areaTable) {
            BOOL ok = [db executeUpdate:sql];
            if (ok == NO) {
                XHLog(@"----NO:%@---",sql);
            }
        }
    }];
}
*/
//删除用户数据库表
- (void)deleteUserTableComplete:(void(^)(BOOL success,id obj))complete;{
    
    BOOL success = [self _deleteFileAtPath:DynamicPath];
    if (success) {
        self.dbQueue = nil;
    }
    complete(success,nil);
}
//删除数据库表
- (void)deleteFilterTableComplete:(void(^)(BOOL success,id obj))complete{
    BOOL success = [self _deleteFileAtPath:FilterPath];
    if (success) {
        self.dbQueue = nil;
    }
    complete(success,nil);
}
/*
//删除地区表
- (void)deleteAreaTableComplete:(void(^)(BOOL success,id obj))complete{
    BOOL success = [self _deleteFileAtPath:AreaPath];
    if (success) {
        self.dbQueue = nil;
    }
    complete(success,nil);
}
*/
#pragma mark - 用户
- (void)updateaUser:(XHUserModel *)aDyn complete:(void (^)(BOOL success,id obj))complete{
    [self creatDynTable];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        /** 存储:会自动调用insert或者update，不需要担心重复插入数据 */
        [db yh_saveDataWithModel:aDyn userInfo:nil option:^(BOOL save) {
            complete(save,nil);
        }];
        
    }];
}
- (void)queryaUser:(XHUserModel *)aDyn userInfo:(NSDictionary *)userInfo complete:(void (^)(BOOL, id))complete{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db yh_excuteDataWithModel:aDyn userInfo:userInfo fuzzyUserInfo:nil option:^(id output_model) {
            complete(YES,output_model);
        }];
        
    }];
}

- (void)deleteUser:(XHUserModel *)dyn userInfo:(NSDictionary *)userInfo complete:(void(^)(BOOL success,id obj))complete{
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db yh_deleteDataWithModel:dyn userInfo:userInfo option:^(BOOL del) {
            complete(del,@(del));
        }];
    }];
}

#pragma mark - 工厂筛选属性
//更新
- (void)updatePlan:(NSArray<XHPlanFilterModel *> *)dynList complete:(void (^)(BOOL, id))complete{
    [self creatFilterTabel];
    for (XHPlanFilterModel *model in dynList) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            /** 存储:会自动调用insert或者update，不需要担心重复插入数据 */
            [db yh_saveDataWithModel:model  primaryKey:@"ID" userInfo:nil option:^(BOOL save) {
                complete(save,nil);
            }];
                       
        }];
    }
}
//查询
- (void)queryPlan:(NSArray<XHPlanFilterModel *> *)dynList complete:(void (^)(BOOL, id))complete{
   // self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:FilterPath];
    __block NSMutableArray *maRet = [NSMutableArray new];
    for (XHPlanFilterModel *model in dynList) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            [db yh_excuteDataWithModel:model userInfo:nil fuzzyUserInfo:nil option:^(id output_model) {
                if (output_model) {
                    [maRet addObject:output_model];
                }
            }];
        }];
    }
    complete(YES,maRet);
    
}
//删除
- (void)deletePlan:(NSArray<XHPlanFilterModel *> *)dynList complete:(void (^)(BOOL, id))complete{
    //self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:FilterPath];
    for (XHPlanFilterModel *model in dynList) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            [db yh_deleteDataWithModel:model userInfo:nil option:^(BOOL del) {
            }];
        }];
    }
}

#pragma mark - 鞋样筛选属性
//鞋样筛选
//更新
- (void)updateProduction:(NSArray <XHProductionFilterModel *>*)dynList complete:(void (^)(BOOL success,id obj))complete{
    [self creatFilterTabel];
    for (XHProductionFilterModel *model in dynList) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            /** 存储:会自动调用insert或者update，不需要担心重复插入数据 */
            [db yh_saveDataWithModel:model  primaryKey:@"ID" userInfo:nil option:^(BOOL save) {
                complete(save,nil);
            }];
        }];
    }
}
//条件查询(一条)
- (void)queryProduction:(XHProductionFilterModel *)model UserInfo:(NSDictionary *)infoDic fuzzyUserInfo:(NSDictionary *)fuzzyDic complete:(void (^)(BOOL success, id obj))complete{
    //self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:AreaPath];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db yh_excuteDataWithModel:model primaryKey:@"ID" userInfo:infoDic fuzzyUserInfo:fuzzyDic option:^(id output_model) {
            if (output_model) {
                complete(YES,output_model);
            }
        }];
    }];
}
//条件查询(多条)
- (void)queryProductionMore:(XHProductionFilterModel *)model UserInfo:(NSArray <NSDictionary *> *)infoArr complete:(void (^)(BOOL success, id obj))complete{
    __block NSMutableArray *maRet = [NSMutableArray new];
    for (NSDictionary *dic in infoArr) {
        [self queryProduction:model UserInfo:dic fuzzyUserInfo:nil complete:^(BOOL success, id obj) {
            if (success) {
                [maRet addObject:obj];
            }else{
                NSLog(@"查询多条失败");
            }
        }];
    }
    complete(YES,maRet);
}
// 条件查询 (多条)
- (void)queryProductionMoreWithUserInfo:(NSDictionary *)userInfo fuzzyUserInfo:(NSDictionary *)fuzzyUserInfo complete:(void (^)(BOOL success,NSMutableArray *modelArr))complete{
    //self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:FilterPath];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db yh_excuteDatasWithModel:[XHProductionFilterModel new] userInfo:userInfo fuzzyUserInfo:fuzzyUserInfo option:^(NSMutableArray *models) {
            if (models.count >0) {
                complete(YES,models);
            }else{
                complete(NO,nil);
            }
        }];
    }];
}

//删除
- (void)deleteProduction:(NSArray <XHProductionFilterModel *>*)dynList complete:(void(^)(BOOL success,id obj))complete{
    //self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:FilterPath];
    for (XHProductionFilterModel *model in dynList) {
        
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            [db yh_deleteDataWithModel:model userInfo:nil option:^(BOOL del) {
            }];
        }];
    }
}
#pragma mark - 鞋材筛选属性
//更新
- (void)updateMaterial:(NSArray <XHMaterialFilterModel *>*)dynList complete:(void (^)(BOOL success,id obj))complete{
    [self creatFilterTabel];
    for (XHMaterialFilterModel *model in dynList) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            /** 存储:会自动调用insert或者update，不需要担心重复插入数据 */
            [db yh_saveDataWithModel:model userInfo:nil option:^(BOOL save) {
                complete(save,nil);
            }];
            
        }];
    }
}
//条件查询 (一条)
- (void)queryMaterialWithUserInfo:(NSDictionary *)infoDic fuzzyUserInfo:(NSDictionary *)fuzzyDic complete:(void (^)(BOOL success, XHMaterialFilterModel *model))complete{
    //self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:FilterPath];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db yh_excuteDataWithModel:[XHMaterialFilterModel new] userInfo:infoDic fuzzyUserInfo:fuzzyDic option:^(id output_model) {
            if (output_model) {
                complete(YES,output_model);
            }else{
                complete(NO,nil);
            }
        }];
    }];
}
// 条件查询 (多条)
- (void)queryMaterialMoreWithUserInfo:(NSDictionary *)userInfo fuzzyUserInfo:(NSDictionary *)fuzzyUserInfo complete:(void (^)(BOOL success,NSMutableArray *modelArr))complete{
    //self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:FilterPath];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db yh_excuteDatasWithModel:[XHMaterialFilterModel new] userInfo:userInfo fuzzyUserInfo:fuzzyUserInfo option:^(NSMutableArray *models) {
            if (models.count >0) {
                complete(YES,models);
            }else{
                complete(NO,nil);
            }
        }];
    }];
}
//删除
- (void)deleteMaterial:(NSArray <XHMaterialFilterModel *>*)dynList complete:(void(^)(BOOL success,id obj))complete{
   // self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:FilterPath];
    for (XHMaterialFilterModel *model in dynList) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            [db yh_deleteDataWithModel:model userInfo:nil option:^(BOOL del) {
            }];
        }];
    }
}
#pragma mark - 地区
//省份
//更新
- (void)updateAreaProvince:(NSArray <XHProvinceModel *>*)dynList complete:(void (^)(BOOL success,id obj))complete{
    [self creatFilterTabel]; // 创建表格
    for (XHProvinceModel *model in dynList) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            /** 存储:会自动调用insert或者update，不需要担心重复插入数据 */
            [db yh_saveDataWithModel:model userInfo:nil option:^(BOOL save) {
                complete(save,nil);
            }];
            
        }];
    }
}
//条件查询 (一条)
- (void)queryAreaProvinceWithUserInfo:(NSDictionary *)infoDic fuzzyUserInfo:(NSDictionary *)fuzzyDic complete:(void (^)(BOOL success, XHProvinceModel  *model))complete{
    //self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:FilterPath];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db yh_excuteDataWithModel:[XHProvinceModel new] userInfo:infoDic fuzzyUserInfo:fuzzyDic option:^(id output_model) {
            if (output_model) {
                complete(YES,output_model);
            }
        }];
    }];
}
// 条件查询 (多条)不传条件输出整个表
- (void)queryAreaProvinceMoreWithUserInfo:(NSDictionary *)userInfo fuzzyUserInfo:(NSDictionary *)fuzzyUserInfo complete:(void (^)(BOOL success,NSMutableArray *modelArr))complete{
    //self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:FilterPath];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db yh_excuteDatasWithModel:[XHProvinceModel new] userInfo:userInfo fuzzyUserInfo:fuzzyUserInfo option:^(NSMutableArray *models) {
            complete(YES,models);
        }];
    }];
}
//删除
- (void)deleteAreaProvince:(NSArray <XHProvinceModel *>*)dynList complete:(void(^)(BOOL success,id obj))complete{
    for (XHProvinceModel *model in dynList) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            [db yh_deleteDataWithModel:model userInfo:nil option:^(BOOL del) {
            }];
        }];
    }
}

//城市
//更新
- (void)updateAreaCity:(NSArray <XHCityModel *>*)dynList complete:(void (^)(BOOL success,id obj))complete{
    [self creatFilterTabel];
    for (XHCityModel *model in dynList) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            /** 存储:会自动调用insert或者update，不需要担心重复插入数据 */
            [db yh_saveDataWithModel:model userInfo:nil option:^(BOOL save) {
                complete(save,nil);
            }];
            
        }];
    }
}
//条件查询 (一条)
- (void)queryAreaCityWithUserInfo:(NSDictionary *)infoDic fuzzyUserInfo:(NSDictionary *)fuzzyDic complete:(void (^)(BOOL success, XHCityModel  *model))complete{
    //self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:FilterPath];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db yh_excuteDataWithModel:[XHCityModel new] userInfo:infoDic fuzzyUserInfo:fuzzyDic option:^(id output_model) {
            if (output_model) {
                complete(YES,output_model);
            }
        }];
    }];
}
// 条件查询 (多条)不传条件输出整个表
- (void)queryAreaCityMoreWithUserInfo:(NSDictionary *)userInfo fuzzyUserInfo:(NSDictionary *)fuzzyUserInfo complete:(void (^)(BOOL success,NSMutableArray *modelArr))complete{
    //self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:FilterPath];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db yh_excuteDatasWithModel:[XHCityModel new] userInfo:userInfo fuzzyUserInfo:fuzzyUserInfo option:^(NSMutableArray *models) {
            complete(YES,models);
        }];
    }];
}
//删除
- (void)deleteAreaCity:(NSArray <XHCityModel *>*)dynList complete:(void(^)(BOOL success,id obj))complete{
    for (XHCityModel *model in dynList) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            [db yh_deleteDataWithModel:model userInfo:nil option:^(BOOL del) {
            }];
        }];
    }
}

#pragma mark - Private
- (BOOL)_deleteFileAtPath:(NSString *)filePath{
    if (!filePath || filePath.length == 0) {
        return NO;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"delete file error, %@ is not exist!", filePath);
        return NO;
    }
    NSError *removeErr = nil;
    if (![[NSFileManager defaultManager] removeItemAtPath:filePath error:&removeErr] ) {
        NSLog(@"delete file failed! %@", removeErr);
        return NO;
    }
    return YES;
}

@end
