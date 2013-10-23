//
//  QZPageNavRectView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "QZEpubPageObjs.h"

@interface QZPageNavRectView : UIView
{
    PageNavRect *pNavRect;
    UITapGestureRecognizer * oneTap;
}
- (void)initIncomingData:(PageNavRect *)pageNavRect;
- (void)composition;

@end
