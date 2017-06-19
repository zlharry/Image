//
//  YHChoicePicView.m
//  Image
//
//  Created by harry on 2017/6/13.
//  Copyright © 2017年 harry. All rights reserved.
//

#import "YHChoicePicView.h"

#import "YHChoicePicViewCell.h"
//#import "YHChoicePicViewCellModel.m"
#import "YHChoicePreView.h"

#define CELL_ID @"YHChoicePicViewCell_id"   // CELL 重用ID
#define COLUMNS 3 // 显示的列数
#define COLUMN_Padding 2 // 列间距
#define ROW_Padding 2 // 行间距

@interface YHChoicePicView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, YHChoicePicViewCellDelegate>

/** 手机图片资源数组 */
@property (nonatomic, strong) NSArray<YHChoicePicViewCellModel *> *pics;

/** 用户选择的图片资源数组 */
@property (nonatomic, strong) NSMutableArray<YHChoicePicViewCellModel *>  *selectedPics;

/** 滚动视图 */
@property (nonatomic, weak) UICollectionView *collectionView;

/** 底部预览的View */
@property (nonatomic, weak) YHChoicePreView *preView;

/** 选择完 一张图片 后需要干的事情 */
@property (nonatomic, copy) YHChoicePicViewDidFinishedSelectOneImageBlock didFinishedSelectImageBlock;

/** 选择完 多张图片 后需要干的事情 */
@property (nonatomic, copy) YHChoicePicViewDidFinishedSelectImagesBlock didFinishedSelectImagesBlock;

/** 最大选择照片数量 */
@property (nonatomic, assign) NSInteger maxNumber;

@end

@implementation YHChoicePicView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor yellowColor];
    }
    
    return self;
}


/** 创建一个图片选择View,同时设置选择完 多张图片 成功或失败后的相应动作 */
- (instancetype)initWithMaxNumber:(NSInteger)maxNumber didFinishedSelectImagesBlock:(YHChoicePicViewDidFinishedSelectImagesBlock)didFinishedSelectImagesBlock
{
    if (self = [super init]) {
        self.didFinishedSelectImagesBlock = didFinishedSelectImagesBlock;
        self.maxNumber = maxNumber;
    }
    return self;
}

/** 创建一个图片选择View,同时设置选择完 一张图片 成功或失败后的相应动作 */
- (instancetype)initWithMaxNumber:(NSInteger)maxNumber didFinishedSelectImageBlock:(YHChoicePicViewDidFinishedSelectOneImageBlock)didFinishedSelectImageBlock
{
    if (self = [super init]) {
        self.didFinishedSelectImageBlock = didFinishedSelectImageBlock;
        self.maxNumber = maxNumber;
    }
    return self;
}

#pragma mark - 工具方法
/** 给所有未选择的添加遮盖／取消遮盖 */
- (void)coverNotSelected:(BOOL)cover
{
    for (YHChoicePicViewCellModel *model in self.pics) {
        if (!model.selected) {
            model.canSelect = cover;
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - 延迟加载
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat sizeW = (self.frame.size.width - (COLUMNS + 1) * COLUMN_Padding) / COLUMNS;
        CGFloat sizeH = sizeW;
        layout.itemSize = CGSizeMake(sizeW, sizeH); // 每个Item的大小(宽度和高度)
        layout.minimumLineSpacing = ROW_Padding; // 行间距
        layout.minimumInteritemSpacing = COLUMN_Padding; //  列间距
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [self addSubview:collectionView];
        _collectionView = collectionView;
        
        collectionView.backgroundColor = [UIColor clearColor];
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        collectionView.contentInset = UIEdgeInsetsMake(ROW_Padding, COLUMN_Padding, ROW_Padding, COLUMN_Padding);
        
        [collectionView registerClass:[YHChoicePicViewCell class] forCellWithReuseIdentifier:CELL_ID];
        
    }
    
    return _collectionView;
}

- (NSMutableArray<YHChoicePicViewCellModel *> *)selectedPics
{
    if (!_selectedPics) {
        _selectedPics = [NSMutableArray array];
    }
    return _selectedPics;
}

- (YHChoicePreView *)preView
{
    if (!_preView) {
        YHChoicePreView *preView = [[YHChoicePreView alloc] init];
        [self addSubview:preView];
        _preView = preView;
    }
    
    return _preView;
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupFrames];
    
    
    // 1.判断是否有
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        // 这里便是无访问权限
        NSLog(@"没有访问权限");
    }
    else
    {
        NSLog(@"有访问权限");
        [self showAllPicsWithAscending:YES];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.pics.count - 1 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:NO];
    }
    
}

- (void)setupFrames
{
    
    CGFloat preW = self.frame.size.width;
    CGFloat preH = 40;
    CGFloat preX = 0;
    CGFloat preY = self.frame.size.height - preH;
    self.preView.frame = CGRectMake(preX, preY, preW, preH);
    
    CGFloat collX = 0;
    CGFloat collY = 0;
    CGFloat collW = self.frame.size.width;
    CGFloat collH = self.frame.size.height - preH - 1;
    self.collectionView.frame = CGRectMake(collX, collY, collW, collH);
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YHChoicePicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    
    
    YHChoicePicViewCellModel *model = self.pics[indexPath.item];
    cell.model = model;
    cell.delegate = self;
    
    return cell;
}

#pragma mark -UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat width = collectionView.frame.size.width / 4;
//    return CGSizeMake(width, width);
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, // top
                            0, // left
                            0, // bottom
                            0); // right
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld  ---  %ld", (long)indexPath.section, (long)indexPath.item);
    
    // 预览所有的图片
}

#pragma mark - YHChoicePicViewCellDelegate
/** 用户点击了某个照片的勾 */
- (void)choicePicViewCell:(UICollectionViewCell *)cell didClickedSelectBtn:(UIButton *)selectBrn
{
    NSInteger item = [[self.collectionView indexPathForCell:cell] item];
    
//    NSLog(@"点击了%ld的勾", item);
    
    YHChoicePicViewCellModel *model = self.pics[item];
    model.selected = !model.selected;
    
    if (model.selected) {
        [self.selectedPics addObject:model];
        
        // 添加了以后如果已经达到上限
        if (self.selectedPics.count == self.maxNumber) {
            
            [self coverNotSelected:NO];
        }
    }
    else
    {
        [self.selectedPics removeObject:model];
        if (self.selectedPics.count == self.maxNumber - 1) {
            
            [self coverNotSelected:YES];
        }
    }
    
    NSLog(@"%@", self.selectedPics);
    
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:item inSection:0]]];
    
    // 预览已经选择的图片
}

#pragma mark - 获取相册内所有照片资源
/** 加载所有的手机图片资源 */
- (void)getAllPicsWithAscending:(BOOL)ascending
{
    __block NSMutableArray<YHChoicePicViewCellModel *> *models = [NSMutableArray<YHChoicePicViewCellModel *> array];
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:option];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        
        
        [models addObject:[YHChoicePicViewCellModel modelWithAsset:asset]];
    }];
    self.pics = models;
//    PHCachingImageManager *manager = (PHCachingImageManager *)[PHCachingImageManager defaultManager];
//    
//    [manager startCachingImagesForAssets:self.pics
//                              targetSize:CGSizeMake(400, 400)
//                             contentMode:PHImageContentModeAspectFill
//                                 options:nil];
}

/** 显示所有图片资源 */
- (void)showAllPicsWithAscending:(BOOL)ascending
{
    [self getAllPicsWithAscending:ascending];
    [self.collectionView reloadData];
}


@end
