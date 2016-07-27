//
//  HeadlineCell.m
//  NXHeadlineScrollViewDemo
//
//  Created by 蒋瞿风 on 16/7/27.
//  Copyright © 2016年 nightx. All rights reserved.
//

#import "HeadlineCell.h"

@interface HeadlineCell ()

@end

@implementation HeadlineCell

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UILabel *label = [[UILabel alloc] init];
    self.textLabel = label;
    [self.contentView addSubview:self.textLabel];
    
    [self.textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:self.textLabel
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.contentView
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.textLabel
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.contentView
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0 constant:10];
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.textLabel
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.contentView
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.textLabel
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.contentView
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0 constant:-10];
    
    [self.contentView addConstraints:@[constraint1,constraint2,constraint3,constraint4]];
}

- (void)configWithText:(NSAttributedString *)text{
    self.textLabel.attributedText = text;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)prepareForReuse{
    [self configWithText:nil];
}

+ (NSString *)cellIdentifier{
    return NSStringFromClass([self class]);
}

@end
