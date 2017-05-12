//
//  OrderHeaderView.h
//  仿淘宝购物订单逻辑
//
//  Created by macOfEthan on 17/4/16.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

// >!选择状态回调
typedef void(^ShopSelectStateRefreshBlock)(void);
// >!编辑状态回调
typedef void(^ShopEditStateRefreshBlock)(void);

@interface OrderHeaderView : UIView

// >!店铺模型
@property (nonatomic, strong) ShopModel *shopModel;
// >!选择状态回调
@property (nonatomic, strong) ShopSelectStateRefreshBlock shopSelectStateRefreshBlock;
// >!编辑状态回调
@property (nonatomic, strong) ShopEditStateRefreshBlock shopEditStateRefreshBlock;


@end
