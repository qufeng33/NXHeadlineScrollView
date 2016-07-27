//
//  NXHeadlineScrollView.m
//  NXHeadlineScrollViewDemo
//
//  Created by 蒋瞿风 on 16/7/27.
//  Copyright © 2016年 nightx. All rights reserved.
//

#import "NXHeadlineScrollView.h"
#import "HeadlineCell.h"

@interface NXHeadlineScrollView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;
@property (weak, nonatomic) NSTimer          *timer;

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
    self.showLeftView            = YES;
    self.leftViewWidth           = 0;
    self.autoScrollTimeInterval  = 3;
    self.contentBackgroundColor  = [UIColor whiteColor];
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

    UIView *leftBackgroundView             = [[UIView alloc] init];
    self.leftBackgroundView                = leftBackgroundView;
    [self addSubview:self.leftBackgroundView];
}

- (void)reloadData{
    [self.collectionView reloadData];
}

- (void)automaticScroll{
    if (self.titlesArray.count == 0) {
        return;
    }
    NSInteger currentIndex = [self.collectionView indexPathsForVisibleItems].lastObject.row;
    NSInteger toIndex = currentIndex + 1 > self.titlesArray.count - 1 ? 0:currentIndex + 1;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
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
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titlesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HeadlineCell *cell               = [collectionView dequeueReusableCellWithReuseIdentifier:[HeadlineCell cellIdentifier] forIndexPath:indexPath];
    cell.contentView.backgroundColor = self.contentBackgroundColor;
    cell.textLabel.numberOfLines     = self.numberOfLine;
    [cell configWithText:[self.titlesArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.DidSelectedItemBlock) {
        self.DidSelectedItemBlock(indexPath.row);
    }
}

- (void)setTitlesArray:(NSArray<NSAttributedString *> *)titlesArray{
    _titlesArray = titlesArray;
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
    [self invalidateTimer];
    [self setupTimer];
}

@end
