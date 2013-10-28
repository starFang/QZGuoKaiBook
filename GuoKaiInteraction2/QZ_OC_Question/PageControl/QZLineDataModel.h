//
//  QZLineDataModel.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-26.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QZLineDataModel : NSObject
{
    NSMutableArray *_linePointArray;
    NSString *_lineWords;
    NSString *_lineDate;
    NSString *_lineCritique;
    NSInteger _linePageNumber;
    NSInteger _lineStartIndex;
    NSInteger _lineEndIndex;
    
}
@property (nonatomic, retain) NSMutableArray *linePointArray;
@property (nonatomic, copy) NSString *lineWords;
@property (nonatomic, copy) NSString *lineDate;
@property (nonatomic, copy) NSString *lineCritique;
@property (nonatomic, assign) NSInteger linePageNumber;
@property (nonatomic, assign) NSInteger lineStartIndex;
@property (nonatomic, assign) NSInteger lineEndIndex;
@end
