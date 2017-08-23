//
//  NXHeadlineScrollView.m
//  NXHeadlineScrollViewDemo
//
//  Created by 蒋瞿风 on 16/7/27.
//  Copyright © 2016年 nightx. All rights reserved.
//

#import "NXHeadlineScrollView.h"
#import "HeadlineCell.h"
#import "NSTimer+BlocksTimer.h"

@interface NXHeadlineScrollView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSTimer          *timer;
@property (assign, nonatomic) NSInteger        currentIndex;
@property (strong, nonatomic) NSMutableArray   *titleArrayGroup;

@end

@implementation NXHeadlineScrollView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self defaultSetting];
        [self setupUI];
        [self setupTimer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultSetting];
        [self setupUI];
        [self setupTimer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultSetting];
        [self setupUI];
        [self setupTimer];
    }
    return self;
}

- (void)defaultSetting{
    self.numberOfLine            = 1;
    self.showLeftView            = NO;
    self.leftViewWidth           = 0;
    self.autoScrollTimeInterval  = 3;
    self.currentIndex            = 0;
    self.contentBackgroundColor  = [UIColor whiteColor];
    self.titleArrayGroup         = [[NSMutableArray alloc] init];
}

- (void)setupUI{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing          = 0;
    flowLayout.scrollDirection             = UICollectionViewScrollDirectionVertical;

    UICollectionView *collectionView       = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
    self.collectionView                    = collectionView;
    self.collectionView.dataSource         = self;
    self.collectionView.delegate           = self;
    self.collectionView.scrollEnabled      = NO;
    self.collectionView.indicatorStyle     = UIScrollViewIndicatorStyleWhite;
    [self.collectionView registerClass:[HeadlineCell class] forCellWithReuseIdentifier:[HeadlineCell cellIdentifier]];
    self.collectionView.backgroundColor    = self.contentBackgroundColor;
    [self addSubview:self.collectionView];

    _leftBackgroundView                = [[UIView alloc] init];
    [self addSubview:self.leftBackgroundView];
}

- (void)reloadData{
    [self setupTimer];
    self.currentIndex = 0;
    [self.collectionView reloadData];
}

- (void)automaticScroll{
    if (self.titleArrayGroup.count == 0) {
        return;
    }
    NSInteger toIndex = self.currentIndex + 1;
    if (toIndex == self.titleArrayGroup.count) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        toIndex = 1;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    self.currentIndex = toIndex;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.showLeftView) {
        self.leftBackgroundView.frame = CGRectMake(0, 0, self.leftViewWidth, self.frame.size.height);
        self.collectionView.frame     = CGRectMake(self.leftViewWidth, 0, self.frame.size.width - self.leftViewWidth, self.frame.size.height);
    }else{
        self.leftBackgroundView.frame = CGRectMake(0, 0, 0, 0);
        self.collectionView.frame     = self.bounds;
    }
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setItemSize:self.collectionView.bounds.size];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

- (void)dealloc {
    self.collectionView.delegate   = nil;
    self.collectionView.dataSource = nil;
}

#pragma mark - Time
- (void)setupTimer{
    [self invalidateTimer];
    __weak __typeof(self)weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval block:^(NSTimer *timer) {
        [weakSelf automaticScroll];
    } repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleArrayGroup.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HeadlineCell *cell               = [collectionView dequeueReusableCellWithReuseIdentifier:[HeadlineCell cellIdentifier] forIndexPath:indexPath];
    cell.contentView.backgroundColor = self.contentBackgroundColor;
    cell.textLabel.numberOfLines     = self.numberOfLine;
    [cell configWithText:[self.titleArrayGroup objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.DidSelectedItemBlock) {
        if (indexPath.row == self.titleArrayGroup.count - 1) {
            self.DidSelectedItemBlock(0);
        }else{
            self.DidSelectedItemBlock(indexPath.row);
        }
    }
}

#pragma mark - setter
- (void)setTitleArray:(NSArray<NSAttributedString *> *)titleArray{
    _titleArray = titleArray;
    [self.titleArrayGroup removeAllObjects];
    if (titleArray.count > 0) {
        [self.titleArrayGroup addObjectsFromArray:titleArray];
        [self.titleArrayGroup addObject:titleArray.firstObject];
    }
    [self reloadData];
}

- (void)setLeftViewWidth:(CGFloat)leftViewWidth{
    _leftViewWidth = leftViewWidth;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setShowLeftView:(BOOL)showLeftView{
    _showLeftView = showLeftView;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self setupTimer];
}

@end
