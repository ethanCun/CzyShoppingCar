//
//  OrderHeaderView.m
//  仿淘宝购物订单逻辑
//
//  Created by macOfEthan on 17/4/16.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#define margin 12
#define btn_W 30
#define btn_H 30
#define edit_W 80
#define edit_H 10

#import "OrderHeaderView.h"

@interface OrderHeaderView ()
{
    UIButton * _selectBtn;
    UILabel * _shopNameLab;
    UIButton * _shopEditBtn;
}

@end

@implementation OrderHeaderView

#pragma mark - Setter

- (void)setShopModel:(ShopModel *)shopModel
{
    _shopModel = shopModel;
    
    _shopNameLab.text = shopModel.czyCompanyName;
    
    // 选择
    if (_shopModel.isShopSelected == YES) {
        _selectBtn.selected = YES;
    }else{
        _selectBtn.selected = NO;
    }
    
    // 编辑
    if (_shopModel.shopEditStyle == CzyCellStyleNoraml) {
        [_shopEditBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }else{
        [_shopEditBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
}

#pragma mark - initialize
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initHeaderView];
    }
    return self;
}


- (void)initHeaderView
{
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(margin, CGRectGetHeight(self.bounds)/2-btn_H/2, btn_W, btn_H);
    [_selectBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(headerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectBtn];
    
    _shopEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shopEditBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_shopEditBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _shopEditBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_shopEditBtn addTarget:self action:@selector(shopEdit:) forControlEvents:UIControlEventTouchUpInside];
    _shopEditBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-edit_W, 0, edit_W, CGRectGetHeight(self.bounds));
    [self addSubview:_shopEditBtn];
    
    _shopNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectBtn.frame)+margin, CGRectGetHeight(self.bounds)/2-7, CGRectGetMinX(_shopEditBtn.frame)-CGRectGetMaxX(_selectBtn.frame)-margin, 14)];
    _shopNameLab.font = [UIFont systemFontOfSize:14];
    [self addSubview:_shopNameLab];
}

#pragma mark - 点击头部按钮
- (void)headerBtnClicked:(UIButton *)sender
{
    self.shopModel.isShopSelected = !self.shopModel.isShopSelected;
    
    if (self.shopSelectStateRefreshBlock) {
        self.shopSelectStateRefreshBlock();
    }
}

#pragma mark - 点击店铺编辑
- (void)shopEdit:(UIButton *)sender
{
    (self.shopModel.shopEditStyle == CzyCellStyleNoraml) ? (self.shopModel.shopEditStyle = CzyCellStyleEdit) : (self.shopModel.shopEditStyle = CzyCellStyleNoraml);
    
    // 更新店铺里每个商品的选择状态
    [self.shopModel updateGoodsEditState:self.shopModel.shopEditStyle];
    
    if (self.shopEditStateRefreshBlock) {
        self.shopEditStateRefreshBlock();
    }
}

@end
