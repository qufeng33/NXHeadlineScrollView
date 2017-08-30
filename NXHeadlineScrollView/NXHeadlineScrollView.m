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
@property (assign, nonatomic) NSInteger        lastIndex;
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
    self.style                   = HeadlineStyleOneLine;
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupTimer];
        self.currentIndex = 0;
        self.lastIndex = self.style == HeadlineStyleOneLine ? self.titleArrayGroup.count - 1 : self.titleArrayGroup.count - 2;
        [self.collectionView reloadData];
    });
}

- (void)automaticScroll{
    if (self.titleArrayGroup.count == 0) {
        return;
    }
    
    NSInteger toIndex = self.currentIndex + (self.style == HeadlineStyleOneLine ? 1 : 2);
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
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
    
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
    CGFloat collectionViewHeight = self.collectionView.bounds.size.height;
    CGSize itemSize = self.style == HeadlineStyleOneLine? CGSizeMake(collectionViewWidth, collectionViewHeight):CGSizeMake(collectionViewWidth, collectionViewHeight / 2);
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setItemSize:itemSize];
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

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.currentIndex == self.lastIndex) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        self.currentIndex = 0;
    }
}

#pragma mark - setter
- (void)setTitleArray:(NSArray<NSAttributedString *> *)titleArray{
    _titleArray = titleArray;
    [self.titleArrayGroup removeAllObjects];
    if (titleArray.count > 0) {
        
        if (self.style == HeadlineStyleOneLine) {
            [self.titleArrayGroup addObjectsFromArray:titleArray];
            [self.titleArrayGroup addObject:titleArray.firstObject];
        }
        
        else if (self.style == HeadlineStyleTwoLine){
            [self.titleArrayGroup addObjectsFromArray:titleArray];

            if (titleArray.count % 2 > 0) {
                [self.titleArrayGroup addObject:[[NSAttributedString alloc] initWithString:@" "]];
            }
            [self.titleArrayGroup addObject:titleArray.firstObject];
            [self.titleArrayGroup addObject:titleArray.count > 2 ? [titleArray objectAtIndex:1] : [[NSAttributedString alloc] initWithString:@" "]];
        }
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
