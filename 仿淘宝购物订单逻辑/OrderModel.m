//
//  OrderModel.m
//  仿淘宝购物订单逻辑
//
//  Created by macOfEthan on 17/4/22.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"czyShopList":[ShopModel class]};
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation ShopModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"czyCompanyImgUrl = %@, czyCompanyName = %@, czyCompanyId = %@", _czyCompanyImgUrl, _czyCompanyName, _czyCompanyId];
}


+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass
{
    return @{@"czyGoodsList":[GoodsModel class]};
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}

// >!更新商里每个商品选择状态
- (void)updateGoodsSelectedState
{
    for (GoodsModel * model in self.czyGoodsList) {
        
        model.isGoodsSelected = self.isShopSelected;
    }
}

// >!更新商店选择状态
- (void)updateShopSeletedState
{
    // 数量为0
    if (self.czyGoodsList.count == 0) {
        self.isShopSelected = NO;
        return;
    }
    
    for (GoodsModel * model in self.czyGoodsList) {
        
        // 一个未选中 则为未选中
        if (model.isGoodsSelected == NO) {
            self.isShopSelected = NO;
            return;
        }
    }
    
    self.isShopSelected = YES;
}

// >!更新全选按钮状态
- (void)updateTotalBtnSelectedState:(BOOL)state
{
    self.isShopSelected = state;
    
    for (GoodsModel * model in self.czyGoodsList) {
        
        model.isGoodsSelected = state;
    }
}

// >!更新商店内每个商品编辑状态
- (void)updateGoodsEditState:(CzyCellStyle)style
{
    for (GoodsModel * model in self.czyGoodsList) {
        
        model.goodEditStyle = style;
    }
}

@end

@implementation GoodsModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"czyGoodsId = %@, czyGoodsAmount = %@, czyGoodsPrice = %@, czyGoodsStock = %@, czyCartId = %@, czyGoodsName = %@, czyGoodsUrl = %@, czyUserId = %@, czyGoodsSpecs = %@", _czyGoodsId, _czyGoodsAmount, _czyGoodsPrice, _czyGoodsStock, _czyCartId, _czyGoodsName, _czyGoodsUrl, _czyUserId, _czyGoodsSpecs];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}


#if 0
// >!返回一个字典 将模型属性名映射到json的key 可以将一个json里面的多个key映射到一个或者多个属性 如：@{@“key”：@【@“key1”，@“key2”】}  以第一个不为空的key为准， 若没有， 则映射到与属性名相同的key
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"A":@"a"};
}

// >! 黑名单 如果实现了该方法 则处理过程中会忽略该方法返回数组里面模型的属性
+ (nullable NSArray<NSString *> *)modelPropertyBlacklist
{
    return @[@"A"];
}

// >!白名单 如果实现了该方法 则处理过程中会忽略该方法返回数组模型外模型的所有属性
+ (nullable NSArray<NSString *> *)modelPropertyWhitelist
{
    return @[@"b"];
}
#endif
// >!当json转换为model完成后 该方法会被调用
// >!你可以在这里进行校验 如果校验不通过 返回NO
// >!你也可以在这里做一些自动转换不能进行的工作
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    
    if ([dic[@"b"] isEqualToString:@"456"] == YES) {
        return YES;
    }
    return YES;
}

// >!当model转换为json完成后 该方法会被调用
// >!你可以在这里进行校验 如果校验不通过 返回NO
// >!你也可以在这里做一些自动转换不能进行的工作
//- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic
//{
//    if ([dic[@"b"] isEqualToString:@"456"] == YES) {
//        return YES;
//    }
//    return YES;
//}


@end

