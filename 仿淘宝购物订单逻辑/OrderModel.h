//
//  OrderModel.h
//  仿淘宝购物订单逻辑
//
//  Created by macOfEthan on 17/4/22.
//  Copyright © 2017年 macOfEthan. All rights reserved.

// json中对象类型和model属性类型不一致时yymodel会自动将json数据中的变量类型转变为模型中的类型 以免各种崩

#import <Foundation/Foundation.h>
#import "YYModel.h"
@class ShopModel;
@class GoodsModel;

@interface OrderModel : NSObject

@property (nonatomic, strong) NSMutableArray <ShopModel *> *czyShopList;

@end

/* 店铺操作状态：normal / edit */
typedef NS_ENUM(NSInteger, CzyCellStyle)
{
    CzyCellStyleNoraml = 0, // 普通
    CzyCellStyleEdit        // 编辑
};

/*店铺模型*/
@interface ShopModel : NSObject
// >!店标
@property (nonatomic, copy) NSString *czyCompanyImgUrl;
// >!店名
@property (nonatomic, copy) NSString *czyCompanyName;
// >!id
@property (nonatomic, copy) NSString *czyCompanyId;
// >!商品数组
@property (nonatomic, strong) NSMutableArray <GoodsModel *> *czyGoodsList;

// >!是否选择商店
@property (nonatomic, assign) BOOL isShopSelected;
// >!商店操作状态
@property (nonatomic, assign) CzyCellStyle shopEditStyle;


// >!更新商店里每个商品的选择状态
- (void)updateGoodsSelectedState;
// >!更新商店选择状态
- (void)updateShopSeletedState;
// >!更新全选按钮状态
- (void)updateTotalBtnSelectedState:(BOOL)state;

// >!更新商店里每个商品的编辑状态
- (void)updateGoodsEditState:(CzyCellStyle)style;


@end

/*商品模型*/
@interface GoodsModel : NSObject

// >!商品id
@property (nonatomic, copy) NSString *czyGoodsId;
// >!数量
@property (nonatomic, copy) NSString *czyGoodsAmount;
// >!价格
@property (nonatomic, copy) NSString *czyGoodsPrice;
// >!库存
@property (nonatomic, copy) NSString *czyGoodsStock;
// >!购物车id
@property (nonatomic, copy) NSString *czyCartId;
// >!名称
@property (nonatomic, copy) NSString *czyGoodsName;
// >!图片url
@property (nonatomic, copy) NSString *czyGoodsUrl;
// >!userid
@property (nonatomic, copy) NSString *czyUserId;
// >!描述
@property (nonatomic, copy) NSString *czyGoodsSpecs;

// >!是否选择商品
@property (nonatomic, assign) BOOL isGoodsSelected;
// >!商品操作状态
@property (nonatomic, assign) CzyCellStyle goodEditStyle;

// >!商品对应的indexPath
@property (nonatomic, strong) NSIndexPath *goodsIndexpath;


@end


