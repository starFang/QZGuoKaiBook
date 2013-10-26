//
//  QZLineDataModel.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-26.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZLineDataModel.h"

@implementation QZLineDataModel

@synthesize lineCritique = _lineCritique;
@synthesize lineDate = _lineDate;
@synthesize linePageNumber = _linePageNumber;
@synthesize linePointArray = _linePointArray;
@synthesize lineWords = _lineWords;

- (id)init
{
    self = [super init];
    if (self) {
        self.linePointArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)dealloc
{
    [self.linePointArray release];
    self.linePointArray = nil;
    [super dealloc];
}

@end
