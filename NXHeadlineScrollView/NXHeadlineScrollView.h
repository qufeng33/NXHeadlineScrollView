//
//  NXHeadlineScrollView.h
//  NXHeadlineScrollViewDemo
//
//  Created by 蒋瞿风 on 16/7/27.
//  Copyright © 2016年 nightx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXHeadlineScrollView : UIView

/** 显示的文字数组 */
@property (strong, nonatomic) NSArray <NSAttributedString *> *titlesArray;

/** 最多几行文字 */
@property (assign, nonatomic) NSInteger          numberOfLine;

/** 自动滚动间隔时间,默认2s */
@property (assign, nonatomic) CGFloat            autoScrollTimeInterval;

/** 是否显示左边的视图 */
@property (assign, nonatomic) BOOL               showLeftView;

/** 左视图的宽度 */
@property (assign, nonatomic) CGFloat            leftViewWidth;

/** 左视图 */
@property (weak, nonatomic  ) UIView             *leftBackgroundView;

/** 内容背景颜色 */
@property (strong, nonatomic) UIColor            *contentBackgroundColor;

/** block方式监听点击 */
@property (copy  , nonatomic) void (^DidSelectedItemBlock)(NSInteger currentIndex);


- (void)reloadData;

@end
