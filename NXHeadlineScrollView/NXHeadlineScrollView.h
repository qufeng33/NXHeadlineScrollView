//
//  NXHeadlineScrollView.h
//  NXHeadlineScrollViewDemo
//
//  Created by 蒋瞿风 on 16/7/27.
//  Copyright © 2016年 nightx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HeadlineStyle){
    HeadlineStyleOneLine = 0, //一行滚动效果
    HeadlineStyleTwoLine = 1, //两行滚动效果
};

@interface NXHeadlineScrollView : UIView

/** 显示的文字数组 */
@property (copy  , nonatomic) NSArray <NSAttributedString *> *titleArray;

/** 最多几行文字 */
@property (assign, nonatomic) NSInteger          numberOfLine;

/** 自动滚动间隔时间,默认3s */
@property (assign, nonatomic) CGFloat            autoScrollTimeInterval;

/** 滚动的效果 */
@property (assign, nonatomic) HeadlineStyle      style;

/** 是否显示左边的视图 */
@property (assign, nonatomic) BOOL               showLeftView;

/** 左视图的宽度 */
@property (assign, nonatomic) CGFloat            leftViewWidth;

/** 左视图 */
@property (strong, nonatomic, readonly) UIView   *leftBackgroundView;

/** 内容背景颜色 */
@property (strong, nonatomic) UIColor            *contentBackgroundColor;

/** block方式监听点击 */
@property (copy  , nonatomic) void (^DidSelectedItemBlock)(NSInteger currentIndex);


- (void)reloadData;

@end
