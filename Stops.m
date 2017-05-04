//
//  Stops.m
//  brisbane.transit
//
//  Created by Bo Wang on 12/10/2014.
//  Copyright (c) 2014 Bo Software. All rights reserved.
//

#import "Stops.h"
#import "FMDatabase.h"
#import "prefix.h"
#import "Helper.h"
#import "Utilities.h"

#define TABLE_NAME @"STOP"
#define COLUMN_STOP_ID @"stop_id"
#define COLUMN_STOP_CODE @"stop_code"
#define COLUMN_STOP_NAME @"stop_name"
#define COLUMN_STOP_DESC @"stop_desc"
#define COLUMN_PARENT_STATION @"parent_station"
#define COLUMN_PLATFORM_CODE @"platform_code"
#define COLUMN_DIRECTION_ID @"direction_id"
#define COLUMN_STOP_SEQUENCE @"stop_sequence"
#define COLUMN_STOP_LON @"stop_lon"
#define COLUMN_STOP_LAT @"stop_lat"


@implementation Stops


+(NSMutableArray *) getSavedStops{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [Stops checkTableCreatedInDb:db];
    NSMutableArray * rtn = [[NSMutableArray alloc] init];
    FMResultSet *rs=[db executeQuery:[NSString stringWithFormat:@"select * from %@",TABLE_NAME]];
    
    while ([rs next]) {
        Stops * stops = [[Stops alloc]init];
        stops.stop_id=[rs stringForColumn:COLUMN_STOP_ID];
        stops.stop_code=[rs stringForColumn:COLUMN_STOP_CODE];
        stops.stop_name=[rs stringForColumn:COLUMN_STOP_NAME];
        stops.stop_desc=[rs stringForColumn:COLUMN_STOP_DESC];
        stops.parent_station=[rs stringForColumn:COLUMN_PARENT_STATION];
        stops.platform_code=[rs stringForColumn:COLUMN_PLATFORM_CODE];
        stops.direction_id=[rs stringForColumn:COLUMN_DIRECTION_ID];
        stops.stop_sequence=[rs stringForColumn:COLUMN_STOP_SEQUENCE];
        stops.stop_lon=[rs stringForColumn:COLUMN_STOP_LON];
        stops.stop_lat=[rs stringForColumn:COLUMN_STOP_LAT];
        [rtn addObject:stops];
    }
    [rs close];
    [db close];
    return rtn;
}
+(BOOL) saveStop:(Stops*)stop{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    [Stops checkTableCreatedInDb:db];
    [Stops deleteStop:stop];

    NSString *sqlStr ;
    
    sqlStr=[NSString stringWithFormat:@"INSERT INTO  %@(%@, %@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?,?,?,?,?)",TABLE_NAME,COLUMN_STOP_ID,COLUMN_STOP_CODE,COLUMN_STOP_NAME,COLUMN_STOP_DESC,COLUMN_PARENT_STATION,COLUMN_PLATFORM_CODE,COLUMN_DIRECTION_ID,COLUMN_STOP_SEQUENCE,COLUMN_STOP_LON,COLUMN_STOP_LAT];
    
    
    BOOL worked = [db executeUpdate:sqlStr,stop.stop_id,stop.stop_code,stop.stop_name,stop.stop_desc,stop.parent_station,stop.platform_code,stop.direction_id,stop.stop_sequence,stop.stop_lon,stop.stop_lat];
    [db close];
    
    
    return worked;
    
}




+(BOOL)checkTableCreatedInDb:(FMDatabase *)db
{
    NSString *createStr=[NSString stringWithFormat:@"CREATE  TABLE  IF NOT EXISTS '%@' ('%@' VARCHAR, '%@' VARCHAR, '%@' VARCHAR, '%@' VARCHAR,'%@' VARCHAR, '%@' varchar,'%@' varchar,'%@' varchar,'%@' varchar,'%@' varchar)",TABLE_NAME,COLUMN_STOP_ID,COLUMN_STOP_CODE,COLUMN_STOP_NAME,COLUMN_STOP_DESC,COLUMN_PARENT_STATION,COLUMN_PLATFORM_CODE,COLUMN_DIRECTION_ID,COLUMN_STOP_SEQUENCE,COLUMN_STOP_LON,COLUMN_STOP_LAT];
    
    BOOL worked = [db executeUpdate:createStr];
    //FMDBQuickCheck(worked);
    return worked;
    
}


+(BOOL)deleteStop:(Stops*)stop{
    FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_PATH];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return NO;
    };
    NSString *sqlStr =[NSString stringWithFormat:@"delete  from %@ where %@ =?",TABLE_NAME,COLUMN_STOP_ID];
    BOOL worked = [db executeUpdate:sqlStr,stop.stop_id];
    [db close];
    return worked;
}
-(Stops*)clone{
    Stops * s = [[Stops alloc]init];
    s.stop_id=self.stop_id;
    
    s.stop_code=self.stop_code;
    s.stop_desc=self.stop_desc;
    s.stop_lat=self.stop_lat;
    s.stop_lon=self.stop_lon;
    
    s.stop_name=self.stop_name;
    s.stop_sequence=self.stop_sequence;
    return s;
}
@end
