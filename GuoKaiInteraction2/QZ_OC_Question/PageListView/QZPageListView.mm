//
//  QZPageListView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZPageListView.h"

#import "QuestionRootView.h"
#import "QZPageTextRollWebView.h"
#import "QZPageWebLinkView.h"
#import "QZPageToolTipView.h"
//音频
#import "MusicToolView.h"
#import "GalleryView.h"
#import "MovieView.h"
#import "ImageGV1.h"

#import "XMLParserBookData.h"

#define NVACHILDBUTTON 120

@implementation QZPageListView

@synthesize pageName;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)initIncomingData:(NSArray *)imageName
{
    array = [NSArray arrayWithObjects:[imageName objectAtIndex:0],[imageName objectAtIndex:1], nil];
    NSString *bookPath = [[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:[[[imageName objectAtIndex:0] objectForKey:@"0"] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    UIImage * image = [UIImage imageWithContentsOfFile:bookPath];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
    [imageView release];
}

- (void)composition
{
    [self inputPageData];
}

- (void)inputPageData
{
    NSString *bookPath0 = [DOCUMENT stringByAppendingPathComponent:BOOKNAME];
    NSString *bookPath = [[bookPath0 stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:[[array objectAtIndex:1] objectForKey:@"1"]];
    pageObj.LoadData([bookPath UTF8String]);
    vector<const PageBaseElements*> vObjs = pageObj.GetDrawableObjList();
    for (int i = 0; i < vObjs.size(); i++)
    {
    const PageBaseElements* pObj = vObjs[i];
    switch (pObj->m_elementType)
        {
        
            case PAGE_OBJECT_QUESTION_LIST:// 题目列表
            {
            PageQuestionList* pQuestionList = (PageQuestionList*)pObj;
                NSLog(@"题目列表");
            [self selfDetect:pQuestionList];
            }
            break;
                
                case PAGE_OBJECT_TOOL_TIP:
            {
            PageToolTip *pToolTip = (PageToolTip *)pObj;
                NSLog(@"点击文字提示");
                [self ToolTip:pToolTip];
            }
                break;
                
                case PAGE_OBJECT_TOOL_IMAGE_TIP:
            {
            PageToolImageTip *pToolImageTip = (PageToolImageTip *)pObj;
                
                NSLog(@"点击图片提示");
                [self ToolImageTip:pToolImageTip];
            }
                break;
                
                case PAGE_OBJECT_NAV_RECT:
            {
                PageNavRect *pNavRect = (PageNavRect *)pObj;
                NSLog(@"点击跳转");
                [self navRect:pNavRect];
            }
                break;
                
                case PAGE_OBJECT_NAV_BUTTON:
            {
                PageNavButton *pNavButton = (PageNavButton *)pObj;
                NSLog(@"点击多项跳转提示");
                [self navButton:pNavButton];
             }
                break;
                
                case PAGE_OBJECT_VIDEO:
            {
                PageVideo *pVideo = (PageVideo *)pObj;
                NSLog(@"视频");
                [self video:pVideo];
            }
                break;
                case PAGE_OBJECT_IMAGE:
            {
                PageImage * pImage = (PageImage *)pObj;
                NSLog(@"单张图片");
                [self image:pImage];
            }
                break;
                case PAGE_OBJECT_IMAGE_LIST:
            {
                PageImageList *pImageList = (PageImageList *)pObj;
                NSLog(@"画廊");
                [self imageList:pImageList];
            }
                break;
            case PAGE_OBJECT_VOICE:
            {
                PageVoice *pVoice = (PageVoice *)pObj;
                NSLog(@"音频");
                [self voice:pVoice];
            }
                break;
            case PAGE_OBJECT_TEXT_ROLL:
            {
            PageTextRoll *pTextRoll = (PageTextRoll *)pObj;
                NSLog(@"文字滚动视图");
                [self TextRoll:pTextRoll];
            }
                break;
            case PAGE_OBJECT_WEB_LINK:
            {
            PageWebLink *pageWebLink = (PageWebLink *)pObj;
                NSLog(@"浏览器跳转");
                [self webLink:pageWebLink];
             }
                break;
        default:
            break;
    
        }
    }
}
//文字提示
- (void)ToolTip:(PageToolTip *)pToolTip
{
    pageToolTip = [[QZPageToolTipView alloc]initWithFrame:CGRectMake(
           pToolTip->rect.X0,
           pToolTip->rect.Y0,
           pToolTip->rect.X1 - pToolTip->rect.X0,
           pToolTip->rect.Y1 - pToolTip->rect.Y0)
                                      ];
    [pageToolTip initIncomingData:pToolTip];
    [pageToolTip composition];
    [self addSubview:pageToolTip];
 }
//文字图片提示
- (void)ToolImageTip:(PageToolImageTip *)pToolImageTip
{
//    坐标
    CGFloat x0 = pToolImageTip->rect.X0;
    CGFloat x1 = pToolImageTip->rect.X1;
    CGFloat y0 = pToolImageTip->rect.Y0;
    CGFloat y1 = pToolImageTip->rect.Y1;
    CGPoint center = CGPointMake((x0+x1)/2,(y0+y1)/2);
//    弹出视图的宽高
    CGFloat toolX;
    CGFloat toolY;
    CGFloat toolW;
    CGFloat toolH;
    
    toolH = y1 - y0 + 20 + pToolImageTip->nHeight;
    if ((x1 - x0) >= pToolImageTip->nWidth)
    {
        toolW = pToolImageTip->rect.X1-pToolImageTip->rect.X0;
     }else{toolW = pToolImageTip->nWidth;}
    int a = 0;
    int b = 0;
    if (center.x <= DW/2)
    {
            toolX = center.x - toolW/2;
        a=1;
    
    }else{
            toolX = DW - 20 - toolW;

        a = 0;
     }
    if (center.y <= DH/2)
    {
        toolY = y0;
        b =1;
    
    }else{
        toolY = y1-toolH;
        b = 0;
     }
   
    pToolTipImageview = [[QZToolTipImageview alloc]init];
    pToolTipImageview.delegate = self;
    pToolTipImageview.frame = CGRectMake(toolX , toolY , toolW  ,toolH);
    pToolTipImageview.backgroundColor = [UIColor grayColor];
    if (a == 0 && b == 0)
    {
        [pToolTipImageview setFist:1];
    }else if (a == 1 && b == 0)
    {
        [pToolTipImageview setFist:2];
    }else if(a == 0 && b == 1 )
    {
        [pToolTipImageview setFist:3];
    }else if (a == 1 && b == 1)
    {
        [pToolTipImageview setFist:4];
    }
    [pToolTipImageview initIncomingData:pToolImageTip];
    [pToolTipImageview composition];
    [self addSubview:pToolTipImageview];
 }

//导航点击区域
- (void)navRect:(PageNavRect *)pNavRect
{
    pNavRectView = [[QZPageNavRectView alloc]init];
    pNavRectView.frame = CGRectMake(pNavRect->rect.X0, pNavRect->rect.Y0, pNavRect->rect.X1 - pNavRect->rect.X0, pNavRect->rect.Y1 - pNavRect->rect.Y0);
    [pNavRectView initIncomingData:pNavRect];
    pNavRectView.delegate = self;
    [pNavRectView composition];
    [self addSubview:pNavRectView];
}
//点击区域按钮的
- (void)navButton:(PageNavButton *)pNavButton
{
    pNavButtonView = [[QZPageNavButtonView alloc]init];
    pNavButtonView.delegate = self;
    //    坐标
    CGFloat x0 = pNavButton->rect.X0;
    CGFloat x1 = pNavButton->rect.X1;
    CGFloat y0 = pNavButton->rect.Y0;
    CGFloat y1 = pNavButton->rect.Y1;
    //    弹出视图的宽高
    CGFloat toolX;
    CGFloat toolY;
    CGFloat toolW = pNavButton->nWidth;
    CGFloat toolH = (y1-y0)+80+pNavButton->nHeight;
    
    if (x0 <= DW/2 && y0 <= DW/2)
    {
        toolX = x0;
        toolY = y0;
        [pNavButtonView setFist:1];
    }else if (x0 <= DW/2 && y0 > DW/2){
        toolX = x0;
        toolY = y1-toolH;
        [pNavButtonView setFist:3];
    }else if (x0 > DW/2 && y0 <= DW/2){
        
        toolX = x1 - pNavButton->nWidth;
        toolY = y0;
        [pNavButtonView setFist:2];
    }else{
        toolX = x1-pNavButton->nWidth;
        toolY = y1-toolH;
        [pNavButtonView setFist:4];
    }
    
    pNavButtonView.frame =CGRectMake(x0, toolY, toolW, toolH);
    [pNavButtonView initIncomingData:pNavButton];
    [pNavButtonView composition];
    [self addSubview:pNavButtonView];
}
//题
- (void)selfDetect:(PageQuestionList *)pQuestionList
{
    QuestionRootView *qView = [[QuestionRootView alloc]init];
    qView.frame = CGRectMake(
        pQuestionList->rect.X0,
        pQuestionList->rect.Y0,
        pQuestionList->rect.X1 - pQuestionList->rect.X0,
        pQuestionList->rect.Y1 - pQuestionList->rect.Y0
                            );
    [qView initIncomingData:pQuestionList];
    [qView composition];
    [self addSubview:qView];

}
//视频
- (void)video:(PageVideo *)pVideo
{
    MovieView *movieView = [[MovieView alloc]init];
    movieView.frame = CGRectMake(pVideo->rect.X0, pVideo->rect.Y0, pVideo->rect.X1 - pVideo->rect.X0, pVideo->rect.Y1 - pVideo->rect.Y0);
    [movieView initIncomingData:pVideo];
    [movieView composition];
    [self addSubview:movieView];
    [movieView release];
}
//单张图片
- (void)image:(PageImage *)pImage
{
    ImageGV1 *image = [[ImageGV1 alloc]init];
    image.frame = CGRectMake(pImage->rect.X0, pImage->rect.Y0, pImage->rect.X1 - pImage->rect.X0, pImage->rect.Y1 - pImage->rect.Y0);
    [image initIncomingData:pImage];
    [image composition];
    [self addSubview:image];
    [image release];
}
//画廊
- (void)imageList:(PageImageList *)pImageList
{
    GalleryView * gallView = [[GalleryView alloc]init];
    gallView.frame = CGRectMake(pImageList->rect.X0, pImageList->rect.Y0, pImageList->rect.X1 - pImageList->rect.X0, pImageList->rect.Y1 - pImageList->rect.Y0);
    [gallView initIncomingData:pImageList];
    [gallView composition];
    [self addSubview:gallView];
    [gallView release];
}
//声音8
- (void)voice:(PageVoice *)pVoice
{
    MusicToolView *musciView = [[MusicToolView alloc]init];
    musciView.frame = CGRectMake(pVoice->rect.X0, pVoice->rect.Y0, pVoice->rect.X1 - pVoice->rect.X0, pVoice->rect.Y1 - pVoice->rect.Y0);
    [musciView initIncomingData:pVoice];
    [musciView composition];
    [self addSubview:musciView];
    [musciView release];
}
//文字滚动视图 9
- (void)TextRoll:(PageTextRoll *)pTextRoll
{
    QZPageTextRollWebView *pageTextRoll = [[QZPageTextRollWebView alloc]init];
    pageTextRoll.frame = CGRectMake(
        pTextRoll->rect.X0,
        pTextRoll->rect.Y0,
        pTextRoll->rect.X1 - pTextRoll->rect.X0,
        pTextRoll->rect.Y1 - pTextRoll->rect.Y0);
    [pageTextRoll initIncomingData:pTextRoll];
    [pageTextRoll composition];
    [self addSubview:pageTextRoll];
}
//web链接10
- (void)webLink:(PageWebLink *)pageWebLink
{
    QZPageWebLinkView *page = [[QZPageWebLinkView alloc]initWithFrame:CGRectMake(pageWebLink->rect.X0,
            pageWebLink->rect.Y0,
            pageWebLink->rect.X1 - pageWebLink->rect.X0,
            pageWebLink->rect.Y1 - pageWebLink->rect.Y0)];
    [page initIncomingData:pageWebLink];
    [page composition];
    [self addSubview:page];
    [page release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [pageToolTip closeTheTextViewWithToolTipView];
    [pToolTipImageview closeTheTextViewWithToolTipView];
    UIView *view = (UIView *)[self viewWithTag:500];
    [view removeFromSuperview];
}

- (void)dealloc
{
    [pageToolTip release];
    [pNavButtonView release];
    [pNavRectView release];
    [super dealloc];
}

- (void)popBtnView:(PageNavButton *)pNavButton
{

    CGFloat x0 = pNavButton->rect.X0;
    CGFloat x1 = pNavButton->rect.X1;
    CGFloat y0 = pNavButton->rect.Y0;
    CGFloat y1 = pNavButton->rect.Y1;
    //    弹出视图的宽高
    CGFloat toolX;
    CGFloat toolY;
    CGFloat toolW = pNavButton->nWidth;
    CGFloat toolH = pNavButton->nHeight;
    
    NSInteger fist;
    if (x0 <= DW/2 && y0 <= DW/2)
    {
        toolX = x0;
        toolY = y0;
        fist  = 1;
    }else if (x0 <= DW/2 && y0 > DW/2){
        toolX = x0;
        toolY = y1-toolH;
        fist = 3;
    }else if (x0 > DW/2 && y0 <= DW/2){
        toolX = x1 - pNavButton->nWidth;
        toolY = y0;
        fist = 2;
    }else{
        toolX = x1-pNavButton->nWidth;
        toolY = y1-toolH;
        fist = 4;
    }
    
    UIView *popView = [[UIView alloc]init];;
    CGRect rectPop;
    if (fist == 1)
    {
        rectPop = CGRectMake(x0,y1+80,toolW,toolH);
    }else if (fist == 2){
        rectPop = CGRectMake(x1-toolW,y1+80,toolW,toolH);
        
    }else if (fist == 3){
            rectPop = CGRectMake(x0,y0-80-toolH,toolW,toolH);
    }else{
            rectPop = CGRectMake(x1-toolW,y0-80-toolH,toolW,toolH);
    }
    popView.backgroundColor = [UIColor whiteColor];
    popView.tag = 500;
    [popView.layer setShadowOffset:CGSizeMake(1, 1)];
    [popView.layer setShadowRadius:10.0];
    [popView.layer setShadowColor:[UIColor blackColor].CGColor];
    [popView.layer setShadowOpacity:1.0];
    popView.frame = rectPop;
    [self addSubview:popView];
    [popView release];
    
    [self pressButton:pNavButton];
}

- (void)pressButton:(PageNavButton *)pNavButton
{
    UIView *popView = (UIView *)[self viewWithTag:500];
    CGSize size = [[NSString stringWithUTF8String:pNavButton->strTipText.c_str()] sizeWithFont:[UIFont systemFontOfSize:21] constrainedToSize:CGSizeMake(popView.FSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    UILabel * textCont = [[UILabel alloc]init];
    textCont.backgroundColor = [UIColor clearColor];
    textCont.numberOfLines = 0;
    textCont.text = [NSString stringWithUTF8String:pNavButton->strTipText.c_str()];
    textCont.font = [UIFont systemFontOfSize:21];
    textCont.frame = CGRectMake(0, 0, popView.FSW, size.height);
    UIScrollView * svc = [[UIScrollView alloc]init];
    svc.frame = popView.bounds;
    svc.contentSize = CGSizeMake(popView.FSW, size.height+120);
    [svc addSubview:textCont];
    [textCont release];
    for (int i = 0; i < pNavButton->vBtnList.size(); i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.backgroundColor = [UIColor orangeColor];
        button.tag =  NVACHILDBUTTON + pNavButton->vBtnList[i].nPageIndex; 
        [button setTitle:[NSString stringWithUTF8String:pNavButton->vBtnList[i].strBtnText.c_str()] forState:UIControlStateNormal];
        button.frame = CGRectMake((popView.FSW/pNavButton->vBtnList.size())*i, size.height+30, popView.FSW/pNavButton->vBtnList.size(), 80);
        [button addTarget:self action:@selector(pressSkip:) forControlEvents:UIControlEventTouchUpInside];
        [svc addSubview:button];
    }
    [popView addSubview:svc];
}
- (void)pressSkip:(UIButton *)button
{
    [self.delegate skipPage: button.tag - NVACHILDBUTTON];
    UIView *view = (UIView *)[self viewWithTag:500];
    [view removeFromSuperview];
}


- (void)closeBtnView:(PageNavButton *)pageNavButton
{
    UIView *view = (UIView *)[self viewWithTag:500];
    [view removeFromSuperview];
}

-(void)skip:(QZ_INT)pageNum
{
    [self.delegate skipPage:pageNum];
}
@end
