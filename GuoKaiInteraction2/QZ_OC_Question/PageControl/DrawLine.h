//
//  drawLine.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-26.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "QZEpubPage.h"
#include <vector>

@interface DrawLine : UIView
{
   QZEpubPage *pageObj;
   std::vector<QZ_BOX> vBoxes;
   UILongPressGestureRecognizer *_longPressGestureRecognizer;
//    记录是否是文字
    BOOL isWord;
    QZ_POS startPos;
}

- (void)composition;
- (void)incomingData:(QZEpubPage *)pObj;
@end
