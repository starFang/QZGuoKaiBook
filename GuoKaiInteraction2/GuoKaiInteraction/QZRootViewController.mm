
//
//  QZRootViewController.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-17.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZRootViewController.h"

#import "DataManager.h"
#import <QuartzCore/QuartzCore.h>

@interface QZRootViewController ()

@end

@implementation QZRootViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        indexImage = 0;
        arrayImage = [[NSMutableArray alloc]init];
        self.view.backgroundColor = [UIColor underPageBackgroundColor];
    }
        return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   [arrayImage setArray:[DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/imageArray.plist",BOOKNAME]]];
    [self pageNum:indexImage];
}

- (void)pageNum:(NSInteger)pNumber
{
    QZPageListView *pageListV = (QZPageListView *)[self.view viewWithTag:200];
    if (pageListV)
    {
        [pageListV saveData];
        [pageListV removeFromSuperview];
    }
    
    QZPageListView *pageListView = [[QZPageListView alloc]init];
    pageListView.frame = CGRectMake(ZERO , ZERO , DW , DH-20);
    pageListView.tag = 200;
    pageListView.delegate = self;
    [pageListView setPageNumber:indexImage];
    [pageListView initIncomingData:[arrayImage objectAtIndex:pNumber]];
    [pageListView composition];
    [self.view addSubview:pageListView];
    [pageListView release];
    
    CATransition * si = [[CATransition alloc]init];
    si.type = @"rippleEffect";
    si.subtype = kCATransitionFromRight;
    si.duration = 0.5;
    [self.view addAnimation:si forKey:nil];
    [si release];
}

- (void)saveDate
{
    QZPageListView *pageListV = (QZPageListView *)[self.view viewWithTag:200];
    if (pageListV)
    {
        [pageListV save];
    }
}

- (void)up:(id)sender
{
    if (indexImage <= 0)
    {
        indexImage = 0;
    }else{
        indexImage--;
    }
    [self pageNum:indexImage];
}

- (void)down:(id)sender
{
    if (indexImage >= [arrayImage count]-1)
    {
        indexImage =[arrayImage count]-1;
        
    }else{
        indexImage++;
    }
    [self pageNum:indexImage];
}

- (void)skipPage:(QZ_INT)pageNum
{
    indexImage = pageNum;
    [self pageNum:pageNum];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [super dealloc];
}


@end
