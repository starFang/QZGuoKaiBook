//
//  Database.m
//  JsonDemo
//
//  Created by DuHaiFeng on 13-7-24.
//  Copyright (c) 2013年 dhf. All rights reserved.
//

#import "Database.h"
#import "QZLineDataModel.h"

//静态全局变量(唯一数据库操作类对象)
static Database * gl_database=nil;

@implementation Database
+(Database*)sharedDatabase
{
    if (!gl_database) {
        gl_database=[[Database alloc] init];
    }
    return gl_database;
}
+(NSString*)filePath:(NSString *)fileName
{
    //当前程序的沙盒目录
    NSString *path=NSHomeDirectory();
    //documents
    //tmp
    //library
    //拼接路径Library/Caches
    path=[path stringByAppendingPathComponent:@"Documents"];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",BOOKNAME]];
    NSFileManager *fm=[NSFileManager defaultManager];
    //检查指定的缓存目录是否存在
    if ([fm fileExistsAtPath:path])
    {
        //检查要保存的文件名是否合法
        if (fileName && [fileName length]!=0)
        {
            //拼接全路径
            path=[path stringByAppendingPathComponent:fileName];
        }
    }else{
        NSLog(@"缓存目录不存在");
    }
    return path;
}

//创建表PAGEINFORMATION表，记录数据
-(void)createTable
{
    NSArray *array=[NSArray arrayWithObjects:@"CREATE TABLE PageInformation (id integer DEFAULT 0,createTime Timestamp DEFAULT 0,modeTime Timestamp DEFAULT 0,author Varchar(255),isSimepleRef Boolean DEFAULT false,beginChapterId Varchar DEFAULT 0,beginFileOffset integer DEFAULT 0,beginChapterIndex integer DEFAULT NULL,beginParaIndex integer DEFAULT NULL,beginAutoIndex integer DEFAULT NULL,endChapterId Varchar DEFAULT NULL,endFileOffset integer DEFAULT NULL,endChapterIndex integer DEFAULT NULL,endParaIndex integer DEFAULT NULL,endAutoIndex integer DEFAULT NULL,refContent TEXT DEFAULT NULL,comment integer DEFAULT NULL)", nil];
    
    for (NSString *sql in array)
    {
        //执行sql语句
        //创建表，增，删，改都用这个方法
        if ([fmdb executeUpdate:sql])
        {
            NSLog(@"创建表成功！！");
        }
        else{
            NSLog(@"创建表失败:%@",[fmdb lastErrorMessage]);;
        }
    }
 }

- (void)createTableWithBookMark
{
    NSArray *array=[NSArray arrayWithObjects:@"CREATE TABLE bookMark (id integer  PRIMARY KEY AUTOINCREMENT DEFAULT 0,createTime Timestamp DEFAULT 0,modeTime Timestamp DEFAULT 0,author Varchar,chapterId Varchar DEFAULT NULL,fileOffset integer DEFAULT NULL,chapterIndex integer DEFAULT NULL,paraIndex integer DEFAULT NULL,autoIndex integer DEFAULT NULL,comment TEXT DEFAULT NULL)", nil];
    
    for (NSString *sql in array)
    {
        //执行sql语句
        //创建表，增，删，改都用这个方法
        if ([fmdb executeUpdate:sql])
        {
            
        }
        else{
            NSLog(@"创建表失败:%@",[fmdb lastErrorMessage]);;
        }
    }
}

-(id)init
{
    if (self=[super init])
    {
        //实例化第三方数据库操作类对象
        //如果user.db文件不存在就创建新的
        //存在就直接使用
        fmdb=[[FMDatabase databaseWithPath:[Database filePath:@"book.db"]] retain];
        //尝试打开数据库
        if ([fmdb open])
        {
            NSLog(@"打开数据库");
            //创建数据表
            [self createTable];
            [self createTableWithBookMark];
        }
    }
    return self;
}

//插入一条记录
-(void)insertItem:(QZLineDataModel *)item
{
    if ([self existsItem:item])
    {
        return;
    }
    NSString *sql=[NSString stringWithFormat:@"insert into PageInformation (refContent) values (?)"];
//     ,createTime,modeTime,author,isSimepleRef,beginChapterId,beginFileOffset,beginChapterIndex,beginParaIndex,beginAutoIndex,endChapterId,endFileOffset,endChapterIndex,endParaIndex ,endAutoIndex,refContent,comment   ,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?
    //变参方法，每个?号代表一个字段值,所有参数必须为对象类类型
    if ([fmdb executeUpdate:sql,item.linePageNumber])
    {
        NSLog(@"数据插入成功");
    }
    else{
        NSLog(@"插入失败 :%@",[fmdb lastErrorMessage]);
    }
}
-(void)insertArray:(NSArray *)array
{
    //开始批量操作
    [fmdb beginTransaction];
    for (QZLineDataModel *item in array)
    {
        [self insertItem:item];
    }
    //提交所有修改
    [fmdb commit];
}
-(NSArray*)selectData:(NSInteger)startIndex count:(NSInteger)count
{
    //查询指定位置startIndex开始的count条记录
    NSString *sql=[NSString stringWithFormat:@"select username,uid,headimage,realname limit %d,%d",startIndex,count];
    NSMutableArray *array=[NSMutableArray array];
    //执行查询
    FMResultSet *rs=[fmdb executeQuery:sql];
    //如果有记录
    while ([rs next])
    {
        QZLineDataModel *item=[[[QZLineDataModel alloc] init] autorelease];
        //此方法是一组方法
        //根据字段类型选择不同方法
        item.lineWords = [rs stringForColumn:@"username"];
        item.lineCritique=[rs stringForColumn:@"uid"];
        item.lineDate = [rs stringForColumn:@"headimage"];
        item.linePageNumber=[rs stringForColumn:@"realname"];
        [array addObject:item];
    }
    return array;
    
}

-(BOOL)existsItem:(QZLineDataModel *)item
{
    NSString *sql=[NSString stringWithFormat:@"select username from user where uid=?"];
    FMResultSet *rs=[fmdb executeQuery:sql,item.linePageNumber];
    while ([rs next])
    {
        return YES;
    }
    return NO;
}
-(NSInteger)count
{
    NSString *sql=[NSString stringWithFormat:@"select count(uid) from user"];
    FMResultSet *rs=[fmdb executeQuery:sql];
    while ([rs next])
    {
        //因为结果中有一列，所以通过索引获得
        return [rs intForColumnIndex:0];
    }
    return 0;
}

@end
