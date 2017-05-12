//
//  OrderCell.h
//  仿淘宝购物订单逻辑
//
//  Created by macOfEthan on 17/4/16.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"


// >!商品选择按钮点击状态
typedef void(^GoodsSelectStateBlock)(void);
// >!增加数量回调
typedef void(^GoodsAddAmountBlock)(NSInteger);
// >!减少数量回调
typedef void(^GoodsMinusAmountBlock)(NSInteger);
// >!删除商品的回调
typedef void(^GoodsDeleteBlock)(NSIndexPath * indexPath);

@interface OrderCell : UITableViewCell

// >!商品模型
@property (nonatomic, strong) GoodsModel *goodsModel;
// >!cell状态
@property (nonatomic, assign) CzyCellStyle cellStyle;
// >!商品选择状态回调
@property (nonatomic, strong) GoodsSelectStateBlock goodsSelectStateBlock;
// >!增加数量回调
@property (nonatomic, strong) GoodsAddAmountBlock goodsAddAmountBlock;
// >!减少数量回调
@property (nonatomic, strong) GoodsMinusAmountBlock goodsMinusAmountBlock;
// >!删除商品的回调
@property (nonatomic, strong) GoodsDeleteBlock goodsDeleteBlock;


@end
