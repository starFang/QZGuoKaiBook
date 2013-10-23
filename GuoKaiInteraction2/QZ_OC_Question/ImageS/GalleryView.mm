//
//  GalleryView.m
//  ImageGesture
//
//  Created by qanzone on 13-9-27.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "GalleryView.h"
#import "CTView.h"
#import "MarkupParser.h"

@implementation GalleryView

@synthesize imageArray = _imageArray;
@synthesize gallerySCV = _gallerySCV;
@synthesize mArrayImages = _mArrayImages;
@synthesize mTitleText = _mTitleText,mPageControl = _mPageCtrol,mTipView = _mTipView;
@synthesize pageImageList = _pageImageList;

- (void)dealloc
{
    [self.gallerySCV release];
    self.gallerySCV = nil;
    [self.imageArray release];
    self.imageArray = nil;
    [self.mArrayImages release];
    self.mArrayImages = nil;
    [self.mTitleText release];
    self.mTitleText = nil;
    [self.mPageControl release];
    self.mPageControl = nil;
    [self.mTipView release];
    self.mTipView = nil;
    [self.pageImageList release];
    self.pageImageList = nil;
    [super dealloc];
 }

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
    }
    return self;
}


- (void)initIncomingData:(PageImageList *)pageImageList
{
    pImageList = pageImageList;
    self.pageImageList = [[PageImageList1 alloc]init];
    [self.pageImageList setIsSmallImage:pImageList->isSmallImage];
    [self.pageImageList setIsComment:pImageList->isComment];
    self.imageArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < pImageList->vImages.size(); i++)
    {
        PageImageListSubImage1 *pageSubImage = [[PageImageListSubImage1 alloc]init];
        NSString *imageName = [NSString stringWithUTF8String:pImageList->vImages[i].strImgPath.c_str()];
        if ( pImageList->vImages[i].stImgComment.isRichText == NO)
        {
            [pageSubImage setStImgComment:[NSString stringWithUTF8String:pImageList->vImages[i].stImgComment.strText.c_str()]];
        }else{
            NSMutableString * commentStr = [NSMutableString string];
            [commentStr setString:@""];
            for (int j = 0 ; j < pImageList->vImages[i].stImgComment.vTextItemList.size(); j++)
            {
                if (pImageList->vImages[i].stImgComment.vTextItemList[j].pieceType == PAGE_RICH_TEXT_PIECE_TEXT)
                {
                    [commentStr appendString:[NSString stringWithUTF8String:pImageList->vImages[i].stImgComment.vTextItemList[j].strText.c_str()]];
                }
            }
            [pageSubImage setStImgComment:commentStr];
        }
        
        [pageSubImage setStrImgPath: imageName];
        [self.imageArray addObject:pageSubImage];
        [pageSubImage release];
    }
    [self.pageImageList.vImages setArray:self.imageArray];
}

- (void)composition
{

    [self initWithSubView:self.frame];
}

- (void)initWithSubView:(CGRect)frame
{
    isBigScreen = NO;
    [self initTitle:frame];
    [self initImageDetail:frame];
    [self initPageControl:frame];
    [self initImageScrollView:frame];
} 
#pragma mark - 设置标题
- (void)initTitle:(CGRect)frame
{
    ctv = [[CTView alloc]init];
    if (pImageList->stTitle.isRichText == YES)
    {
        [self isYesRichText:frame];
    }else{
        [self isNoRichText:frame];
    }
    [self addSubview:ctv];
    titHeight = ctv.FSH;
}

- (void)isYesRichText:(CGRect)frame
{
    NSMutableString *strBegin = [[NSMutableString alloc]initWithString:@""];
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    NSMutableString * strFont = [NSMutableString string];
    CGFloat fontsize;
    MarkupParser *p = [[[MarkupParser alloc]init]autorelease];
    for (int i = 0; i < pImageList->stTitle.vTextItemList.size(); i++)
    {
        switch (pImageList->stTitle.vTextItemList[i].pieceType)
        {
            case PAGE_RICH_TEXT_PIECE_PARAGRAPH_BEGIN:
            {
                if (![strBegin length]) {
                    
                }else{
                    [strBegin appendString:@"\n"];
                    [string appendString:@"\n"];
                }
                UIFont *font = [UIFont fontWithName:[NSString stringWithUTF8String:pImageList->stTitle.vTextItemList[i].fontFamily.c_str()] size:pImageList->stTitle.vTextItemList[i].fontSize];
                
                CGSize sizek = [@" " sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
                NSInteger countK = (int)ceilf(pImageList->stTitle.vTextItemList[i].nLength/sizek.width);
                for (int j =0 ; j < countK; j++)
                {
                    [strBegin appendString:@" "];
                    [string appendString:@" "];
                }
            }
                break;
            case PAGE_RICH_TEXT_PIECE_TEXT:
            {
                [string appendString:[NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:pImageList->stTitle.vTextItemList[i].strText.c_str()]]];
                NSString * strText = [NSString stringWithFormat:@"<font color=\"%d,%d,%d,%d\">%@",pImageList->stTitle.vTextItemList[i].fontColor.rgbRed,pImageList->stTitle.vTextItemList[i].fontColor.rgbGreen,pImageList->stTitle.vTextItemList[i].fontColor.rgbBlue,pImageList->stTitle.vTextItemList[i].fontColor.rgbAlpha,[NSString stringWithUTF8String:pImageList->stTitle.vTextItemList[i].strText.c_str()]];
                [strBegin appendString:strText];
                [strFont setString:[NSString stringWithUTF8String:pImageList->stTitle.vTextItemList[i].fontFamily.c_str()]];
                fontsize = (float)pImageList->stTitle.vTextItemList[i].fontSize;
                
            }
                break;
            case PAGE_RICH_TEXT_PIECE_PARAGRAPH_END:
            {
                
            }
                break;
            case PAGE_RICH_TEXT_PIECE_DOT:
            {
                
            }
                break;
            default:
                break;
        }
    }
    [p setFont:strFont];
    [p setSize:fontsize];
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:35] constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    NSAttributedString *attString = [p attrStringFromMarkup:strBegin];
    ctv.frame = CGRectMake(0, 0, size.width, size.height);
    [ctv setAttString:attString];
    
}

- (void)isNoRichText:(CGRect)frame
{
    UIFont *fontTt = [UIFont fontWithName:@"Helvetica" size:15];
    CGSize sizeTt = [[NSString stringWithUTF8String:pImageList->stTitle.strText.c_str()] sizeWithFont:fontTt constrainedToSize:CGSizeMake(FSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    ctv.frame = CGRectMake(0, 0, FSW, sizeTt.height);
    ctv.backgroundColor = [UIColor clearColor];
    MarkupParser *p = [[[MarkupParser alloc]init]autorelease];
    [p setFont:@"Helvetica"];
    [p setSize:15];
    NSAttributedString *attString = [p attrStringFromMarkup:[NSString stringWithFormat:@"<font color=\"0,0,0,255\">%@",[NSString stringWithUTF8String:pImageList->stTitle.strText.c_str()]]];
    [(CTView *)ctv setAttString:attString];
 }

- (void)initImageScrollView:(CGRect)frame
{
    UILabel *labelT = (UILabel *)[self viewWithTag:202];
    self.gallerySCV = [[UIScrollView alloc]init];
    
    if (self.pageImageList.isComment == YES && self.pageImageList.isSmallImage == YES)
    {
       self.gallerySCV.frame = CGRectMake(0, titHeight+10,frame.size.width, frame.size.height- titHeight -labelT.frame.size.height-110);
        self.gallerySCV.contentSize = CGSizeMake(frame.size.width*[self.pageImageList.vImages count], frame.size.height- titHeight -labelT.frame.size.height-110);
    }else if (self.pageImageList.isComment == YES && self.pageImageList.isSmallImage == NO)
    {
        self.gallerySCV.frame = CGRectMake(0, titHeight+10,frame.size.width, frame.size.height- titHeight-labelT.frame.size.height-55);
        self.gallerySCV.contentSize = CGSizeMake(frame.size.width*[self.pageImageList.vImages count], frame.size.height- titHeight-labelT.frame.size.height-55);
    }else if (self.pageImageList.isComment == NO && self.pageImageList.isSmallImage == YES)
    {
        self.gallerySCV.frame = CGRectMake(0, titHeight+10,frame.size.width, frame.size.height- titHeight-10 -15 -labelT.frame.size.height-30);
        self.gallerySCV.contentSize = CGSizeMake(frame.size.width*[self.pageImageList.vImages count], frame.size.height- titHeight-10 -15 -labelT.frame.size.height-30);
    }else if (self.pageImageList.isComment == NO && self.pageImageList.isSmallImage == NO)
    {
        self.gallerySCV.frame = CGRectMake(0, titHeight+10,frame.size.width, frame.size.height- titHeight-45);
        self.gallerySCV.contentSize = CGSizeMake(frame.size.width*[self.pageImageList.vImages count], frame.size.height- titHeight-45);
    }
    self.gallerySCV.backgroundColor = [UIColor clearColor];
    self.gallerySCV.delegate =self;
    [self addSubview:self.gallerySCV];
    self.gallerySCV.pagingEnabled = YES;
    self.gallerySCV.showsHorizontalScrollIndicator = NO;
    self.gallerySCV.showsVerticalScrollIndicator = NO;
    
    
    for (int i = 0 ; i < [self.pageImageList.vImages count]; i++)
    {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.gallerySCV.frame.size.width, 0, self.gallerySCV.frame.size.width, self.gallerySCV.frame.size.height) ];
        imageView.tag = 300 + i;
        imageView.userInteractionEnabled = YES;
        PageImageListSubImage1 *pageFirst = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:i];
        [imageView setImage:[UIImage imageNamed:pageFirst.strImgPath]];
        UITapGestureRecognizer *tapOneGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [imageView addGestureRecognizer:tapOneGesture];
        [self.gallerySCV addSubview:imageView];
        [imageView release];
    }
}

- (void)initImageDetail:(CGRect)frame
{
    if (self.pageImageList.isComment == YES)
    {
        //图片说明
        _mTitleText = [[UILabel alloc]init];
        _mTitleText.tag = 202;
        UIFont *font = [UIFont fontWithName:@"Palatino" size:15.0];
        [_mTitleText setFont:font];
        NSInteger longStringIndex=0;
        for (int i = 0; i  < [self.pageImageList.vImages count]; i++)
        {
            PageImageListSubImage1 *pageSubImage = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:i];
            if ([pageSubImage.stImgComment length] >= [pageSubImage.stImgComment length])
            {
                longStringIndex = i;
            }else{
                longStringIndex = i+1;
            }
        }
        PageImageListSubImage1 *pageFirst = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:0];
        _mTitleText.text = pageFirst.stImgComment;
        
        PageImageListSubImage1 *pageSubImage = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:longStringIndex];
        CGSize sizeT = [pageSubImage.stImgComment sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        _mTitleText.frame = CGRectMake(0, frame.size.height-30-sizeT.height, frame.size.width, sizeT.height);
        [_mTitleText setTextAlignment:NSTextAlignmentLeft];
        _mTitleText.numberOfLines = 0;
        [_mTitleText setBackgroundColor:[UIColor clearColor]];
        [_mTitleText setTextColor:[UIColor blackColor]];
        [self addSubview:_mTitleText];
        
    }else if (self.pageImageList.isComment == NO)
    {
        NSLog(@"没有说明！！！！！");
    }
}

- (void)initPageControl:(CGRect)frame
{
    if (self.pageImageList.isSmallImage == NO)
    {
        CGRect tipRect = CGRectMake(0, self.frame.size.height-30, self.frame.size.width, 30);
        _mTipView = [[UIView alloc]initWithFrame:tipRect];
        [_mTipView setAlpha:0.7];
        [self addSubview:_mTipView];
        _mTipView.backgroundColor = [UIColor clearColor];
        _mPageCtrol = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 10, 400, 20)];
        _mPageCtrol.currentPage = 0;
        [_mPageCtrol addTarget:self action:@selector(pageControlWithSC:) forControlEvents:UIControlEventValueChanged];
        [_mPageCtrol setNumberOfPages:[self.pageImageList.vImages count]];
        _mPageCtrol.hidesForSinglePage = NO;
        [_mTipView addSubview:_mPageCtrol];
        
        UIImage *image1 = [UIImage imageNamed:@"a1.png"];
        UIImage *image2 = [UIImage imageNamed:@"a2.png"];
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 20,20)];
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(_mTipView.frame.size.width-20, 10, 20, 20)];
        [imageView1 setImage:image1];
        [imageView2 setImage:image2];
        [_mTipView addSubview:imageView1];
        [_mTipView addSubview:imageView2];
        [imageView1 release];
        [imageView2 release];
        
    
    }else{
        CGRect tipRect = CGRectMake(0, self.frame.size.height-85, self.frame.size.width, 85);
        _mTipView = [[UIView alloc]initWithFrame:tipRect];
        [_mTipView setAlpha:1.0];
        [self addSubview:_mTipView];
        _mTipView.backgroundColor = [UIColor clearColor];
        _mPageCtrol = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 65, 400, 20)];
        _mPageCtrol.currentPage = 0;
        [_mPageCtrol addTarget:self action:@selector(pageControlWithSC:) forControlEvents:UIControlEventValueChanged];
        [_mPageCtrol setNumberOfPages:[self.imageArray count]];
        _mPageCtrol.hidesForSinglePage = NO;
        [_mTipView addSubview:_mPageCtrol]; 
        UIImage *image1 = [UIImage imageNamed:@"m2.png"];
        UIImage *image2 = [UIImage imageNamed:@"m1.png"];
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 65, 20,20)];
        UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(_mTipView.frame.size.width-20, 65, 20, 20)];
        [imageView1 setImage:image1];
        [imageView2 setImage:image2];
        [_mTipView addSubview:imageView1];
        [_mTipView addSubview:imageView2];
        [imageView1 release];
        [imageView2 release];
    }
    
}

-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    isBigScreen = YES;
    UIView *bigView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 1024, 768)];
    bigView.tag = 999;
    bigView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapOneGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageBig:)];
    [bigView addGestureRecognizer:tapOneGesture];
    UIScrollView *sCV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    sCV.backgroundColor = [UIColor clearColor];
    sCV.contentSize = CGSizeMake(1024*[self.pageImageList.vImages count], 768);
    sCV.delegate =self;
    [bigView addSubview:sCV];
    sCV.pagingEnabled = YES;
    sCV.showsHorizontalScrollIndicator = NO;
    sCV.showsVerticalScrollIndicator = NO;
    [sCV setContentOffset:CGPointMake(1024 * (gestureRecognizer.view.tag-300), 0)];
    
    for (int i = 0 ; i < [self.pageImageList.vImages count]; i++)
    {
        PageImageListSubImage1 *pageFirst = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*sCV.frame.size.width, 0, sCV.frame.size.width, sCV.frame.size.height) ];
        imageView.userInteractionEnabled = YES;
        [imageView setImage:[UIImage imageNamed:pageFirst.strImgPath]];
        [sCV addSubview:imageView];
        [imageView release];
    }
    
    UIView *titleHead = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 44)];
    titleHead.backgroundColor = [UIColor blackColor];
    titleHead.tag = 110;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 0, 44, 44);
    [button setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pressCloseBigImage:) forControlEvents:UIControlEventTouchUpInside];
    [titleHead addSubview:button];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(74, 0, 1024, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.text = self.pageImageList.stTitle;
    label.textColor = [UIColor whiteColor];
    UIFont *font = [UIFont fontWithName:@"Bodoni 72 Oldstyle" size:30];
    CGSize size = [label.text sizeWithFont:font constrainedToSize:CGSizeMake(1024-74, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    label.font = font;
    if (size.width <= 1024-74)
    {
        label.textAlignment = NSTextAlignmentCenter;
    }else{
        label.textAlignment = NSTextAlignmentLeft;
    }
    [titleHead addSubview:label];
    [label release];
    [bigView addSubview:titleHead];
    [self.superview addSubview:bigView];
    [titleHead release];
  
    UIView *footView = [[UIView alloc]init];;
    footView.backgroundColor = [UIColor blackColor];
    UILabel *footLabel = [[UILabel alloc]init];
    footLabel.tag = HUALANG_FOOTLABEL_TAG;
    footLabel.backgroundColor = [UIColor clearColor];
    
    if (self.pageImageList.isComment == YES && self.pageImageList.isSmallImage == YES)
    {
        
    }else if (self.pageImageList.isComment == YES && self.pageImageList.isSmallImage == NO)
    {
        PageImageListSubImage1 *pageSubimage = [self.pageImageList.vImages objectAtIndex:gestureRecognizer.view.tag-300];
        UIFont *font = [UIFont fontWithName:@"Bodoni 72 Oldstyle" size:30];
        CGSize size = [pageSubimage.stImgComment sizeWithFont:font constrainedToSize:CGSizeMake(1024, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        footLabel.text = pageSubimage.stImgComment;
        footLabel.textColor = [UIColor whiteColor];
        footLabel.frame = CGRectMake(0,10, 1024, size.height);
        [footView addSubview:footLabel];
    }else if (self.pageImageList.isComment == NO && self.pageImageList.isSmallImage == YES)
    {
    
    }else if (self.pageImageList.isComment == NO && self.pageImageList.isSmallImage == NO)
    {
    
    }
    footView.frame = CGRectMake(0, 768-footLabel.frame.size.height-20, 1024, footLabel.frame.size.height+20);;
    [bigView addSubview:footView];
    [footLabel release];
    [footView release];
    [bigView release];
}

- (void)bigImageScreen
{

}
- (void)pressCloseBigImage:(id)sender
{
    isBigScreen = NO;
    UIView *view = (UIView *)[self.superview viewWithTag:999];
    [view removeFromSuperview];
}

static int indexNum;
- (void)tapImageBig:(UITapGestureRecognizer *)gestureRecognizer
{

    if (indexNum%2 == 1)
    {
        UIView *titleHead = (UIView *)[self viewWithTag:110];
        titleHead.alpha = 0.0;
        NSLog(@"HAHAHHAHAHAHAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    }
    indexNum++;
  

    return;
   
    self.frame = CGRectMake(0, 0, 1024, 768);
    
    for (int i = 0 ; i < [self.imageArray count]; i++)
    {
        ImageGV *imageGV = [[ImageGV alloc]initWithFrame:CGRectMake(i*self.gallerySCV.frame.size.width, 0, self.gallerySCV.frame.size.width, self.gallerySCV.frame.size.height) ];
        [imageGV loadImage:[self.imageArray objectAtIndex:i]];
        imageGV.delegate = self;
        [self.gallerySCV addSubview:imageGV];
        [imageGV release];
        
    }
    
    //        提示View
    CGRect tipRect = CGRectMake(0, 708, 1024, 60);
    _mTipView = [[UIView alloc]initWithFrame:tipRect];
    [_mTipView setAlpha:0.7];
    [self addSubview:_mTipView];
    _mTipView.backgroundColor = [UIColor darkGrayColor];
    
    //        图片提示标题
    CGRect rectTitle = CGRectMake(0, 15, 1024, 30);
    _mTitleText = [[UILabel alloc]initWithFrame:rectTitle];
    _mTitleText.text = @"1_1.jpg";
    [_mTitleText setTextAlignment:NSTextAlignmentCenter];
    [_mTitleText setBackgroundColor:[UIColor clearColor]];
    [_mTitleText setFont:[UIFont systemFontOfSize:32.0]];
    [_mTitleText setTextColor:[UIColor whiteColor]];
    [_mTipView addSubview:_mTitleText];
        
    
    self.gallerySCV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    self.gallerySCV.backgroundColor = [UIColor clearColor];
    self.gallerySCV.contentSize = CGSizeMake(1024*[self.imageArray count], 768);
    self.gallerySCV.delegate =self;
    [self addSubview:self.gallerySCV];
    self.gallerySCV.pagingEnabled = YES;
    self.gallerySCV.showsHorizontalScrollIndicator = NO;
    self.gallerySCV.showsVerticalScrollIndicator = NO;
}

-(void)removeFromTheView:(NSString *)name
{
    
    NSLog(@"star_TongHua");
    return;
    ImageGV * imageGV = (ImageGV *)[self.superview viewWithTag:111];
    imageGV.hidden = YES;
    [imageGV removeFromSuperview];
    
    NSArray * array = self.gallerySCV.subviews;
    for (int i = 0 ; i < [self.imageArray count]; i++)
    {
    if ([name isEqualToString:[self.imageArray objectAtIndex:i]])
        {
            [[array objectAtIndex:i] setHidden:NO];
            NSLog(@"我们发现了许多宝藏，快来发掘啊，你相信吗？");
        }
    }
}

-(void)panImage:(NSString *)name
{
    self.gallerySCV.hidden = YES;
    return;
    NSArray * array = self.gallerySCV.subviews;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    for (int i = 0 ; i < [self.imageArray count]; i++)
    {
        if ([name isEqualToString:[self.imageArray objectAtIndex:i]])
        {
            [[array objectAtIndex:i] setHidden:YES];
            ImageGV *imageGV = [[ImageGV alloc]initWithFrame:CGRectMake(self.frame.origin.x + 100, self.frame.origin.y + 400, self.gallerySCV.frame.size.width, self.gallerySCV.frame.size.height) ];
            imageGV.backgroundColor = [UIColor blackColor];
            [imageGV loadImage:name];
            imageGV.delegate = self;
            [self.superview addSubview:imageGV];
            [imageGV bringSubviewToFront:self.superview];
            [imageGV release];
        }
        
    }
}

//滚动视图停止时候回调函数
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat aWidth = scrollView.frame.size.width;
    //    得到当前页数
    NSInteger curPageView = floor(scrollView.contentOffset.x/aWidth);
    //    更新标题和页数
    if (curPageView < 0)
    {
        curPageView = 0;
    }
    PageImageListSubImage1 *pageFirst = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:curPageView];
    
    if (isBigScreen == NO)
    {
        _mTitleText.text = pageFirst.stImgComment;
        [_mPageCtrol setCurrentPage:curPageView];
        
    }else{
        UILabel * footLabel = (UILabel *)[self.superview viewWithTag:HUALANG_FOOTLABEL_TAG];
        [footLabel setText:pageFirst.stImgComment];
    }
    
}

- (void)pageControlWithSC:(id)sender
{
//  获取当前pagecontroll的值
    int page = self.mPageControl.currentPage;
//    根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    [self.gallerySCV setContentOffset:CGPointMake(self.frame.size.width * page, 0)];
    PageImageListSubImage1 *pageFirst = (PageImageListSubImage1 *)[self.pageImageList.vImages objectAtIndex:page];
    self.mTitleText.text  = pageFirst.stImgComment;
}

@end
