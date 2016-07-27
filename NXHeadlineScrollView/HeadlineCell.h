//
//  HeadlineCell.h
//  NXHeadlineScrollViewDemo
//
//  Created by 蒋瞿风 on 16/7/27.
//  Copyright © 2016年 nightx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadlineCell : UICollectionViewCell

@property (weak, nonatomic) UILabel *textLabel;

- (void)configWithText:(NSAttributedString *)text;

+ (NSString *)cellIdentifier;

@end
