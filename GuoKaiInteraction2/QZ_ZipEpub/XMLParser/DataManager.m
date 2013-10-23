//
//  DataManager.m
//  Zip1Demo
//
//  Created by qanzone on 13-9-11.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "DataManager.h"


@implementation DataManager

- (NSString *)FileContentPath:(NSString *)bookName
{
    NSString *filepath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@/content/contentDict.plist",bookName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * contentFilePath = [DOCUMENT stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/content",bookName,bookName]];
    if (![fileManager contentsOfDirectoryAtPath:contentFilePath error:nil])
    {
        
        [fileManager createDirectoryAtPath:contentFilePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
        
    }
    return filepath;
}

- (NSString *)fileContentImagePath:(NSString *)bookName
{
    NSString *filepath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@/content/imageArray.plist",bookName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * contentFilePath = [DOCUMENT stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/content",bookName]];
    if (![fileManager contentsOfDirectoryAtPath:contentFilePath error:nil])
    {
        [fileManager createDirectoryAtPath:contentFilePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    return filepath;
}

- (NSString *)FileContentXMLPath:(NSString *)bookName
{
    NSString *filepath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@/content/XMLArray.plist",bookName];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * contentFilePath = [DOCUMENT stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/content",bookName]];
    if (![fileManager contentsOfDirectoryAtPath:contentFilePath error:nil])
    {
        [fileManager createDirectoryAtPath:contentFilePath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
    return filepath;
}

#pragma mark- 从plist里获取数据
+(NSMutableArray *)getArrayFromPlist:(NSString *)path
{
    NSMutableArray *feedBackArray;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",path]])
    {
        feedBackArray = [[NSMutableArray alloc]initWithContentsOfFile:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",path]];
        return  [feedBackArray autorelease] ;
    }
    else
    {
        return nil;
    }
}

@end
