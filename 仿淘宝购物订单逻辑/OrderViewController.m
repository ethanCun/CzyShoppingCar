//
//  OrderViewController.m
//  仿淘宝购物订单逻辑
//
//  Created by macOfEthan on 17/4/16.
//  Copyright © 2017年 macOfEthan. All rights reserved.

#define margin 12
#define kBtnW 60
#define kBtnH 30
#define kEditW 60
#define kEditH 10
#define kBottomH 50

#define ORDER_W [UIScreen mainScreen].bounds.size.width
#define ORDER_H [UIScreen mainScreen].bounds.size.height

#import "OrderViewController.h"
#import "OrderHeaderView.h"
#import "OrderModel.h"
#import "OrderCell.h"

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView * _tableView;

    // >!底部视图
    UIView * _bottomView;
    UIButton * _totalSelectedBtn;
    UILabel * _totalPriceLab;
    UILabel * _freightLab;
    UIButton * _accountBTn; //结算
}

@property (nonatomic, strong) OrderModel *orderModel;


@property (nonatomic, strong) UIBarButtonItem *rightBBi;


@end

@implementation OrderViewController

#pragma mark - lazy load
- (OrderModel *)orderModel
{
    if (!_orderModel) {
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"CzyShopPlist.plist" ofType:nil];
        NSDictionary *orderDic = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        self.orderModel = [OrderModel yy_modelWithJSON:orderDic];
    }
    return _orderModel;
}

- (UIBarButtonItem *)rightBBi
{
    if (!_rightBBi) {
        self.rightBBi = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
        [self.rightBBi setTitleTextAttributes:@{NSForegroundColorAttributeName:CZY_BLACK,NSForegroundColorAttributeName:CZY_FONT(13)} forState:UIControlStateNormal];
    }
    return _rightBBi;
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"购物车";
    self.navigationItem.prompt = @"仿淘宝购物车界面与逻辑";
    
    self.navigationItem.rightBarButtonItem = self.rightBBi;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
    
    [self initBottomView];
}

#pragma mark - 右边编辑按钮
- (void)edit:(UIBarButtonItem *)sender
{
    
    if ([_rightBBi.title isEqualToString:@"编辑"]) {
        _rightBBi.title = @"完成";
        
        for (ShopModel * shopModel in self.orderModel.czyShopList) {
            
            // 更新店铺编辑状态
            shopModel.shopEditStyle = CzyCellStyleEdit;
            
            for (GoodsModel * goodModel in shopModel.czyGoodsList) {
                
                // 更新商品编辑状态
                goodModel.goodEditStyle = CzyCellStyleEdit;
            }
        }
    }else{
        _rightBBi.title = @"编辑";
        
        for (ShopModel * shopModel in self.orderModel.czyShopList) {
            
            shopModel.shopEditStyle = CzyCellStyleNoraml;
            
            for (GoodsModel * goodModel in shopModel.czyGoodsList) {
                
                goodModel.goodEditStyle = CzyCellStyleNoraml;
            }
        }
        
    }
    
    [_tableView reloadData];
    
}

#pragma mark - 底部视图实例化
- (void)initBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CZY_HEIGHT-49-kBottomH, CZY_WIDTH, kBottomH)];
    _bottomView.backgroundColor = CZY_WHITE;
    _bottomView.userInteractionEnabled = YES;
    [self.view addSubview:_bottomView];
    
    _totalSelectedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _totalSelectedBtn.frame = CGRectMake(margin, kBottomH/2-kBtnH/2, kBtnW, kBtnH);
    [_totalSelectedBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    [_totalSelectedBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [_totalSelectedBtn setTitle:@"\040\040全选" forState:UIControlStateNormal];
    _totalSelectedBtn.titleLabel.font = CZY_FONT(12);
    [_totalSelectedBtn setTitleColor:CZY_BLACK forState:UIControlStateNormal];
    [_totalSelectedBtn addTarget:self action:@selector(totalSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_totalSelectedBtn];
    
    _accountBTn = [UIButton buttonWithType:UIButtonTypeCustom];
    _accountBTn.frame = CGRectMake(CZY_WIDTH-kBtnW*1.5, 0, kBtnW*1.5, kBtnW);
    [_accountBTn setTitle:@"结算(0)" forState:UIControlStateNormal];
    [_accountBTn setTitleColor:CZY_WHITE forState:UIControlStateNormal];
    _accountBTn.titleLabel.font = CZY_FONT(14);
    _accountBTn.backgroundColor = CZY_ORANGE;
    [_accountBTn setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
    [_accountBTn addTarget:self action:@selector(accountBTnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_accountBTn];
    
    _freightLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_accountBTn.frame)-kBtnW, kBtnH/2-14/2, kBtnW, kBtnH)];
    _freightLab.text = @"不含运费";
    _freightLab.textColor = CZY_BLACK;
    _freightLab.font = CZY_FONT(13);
    [_bottomView addSubview:_freightLab];
    
    _totalPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_totalSelectedBtn.frame), kBottomH/2-14/2, CGRectGetMinX(_freightLab.frame)-CGRectGetMaxX(_totalSelectedBtn.frame), 14)];
    _totalPriceLab.font = CZY_FONT(14);
    _totalPriceLab.textColor = CZY_BLACK;
    NSMutableAttributedString * priceStr = [[NSMutableAttributedString alloc] initWithString:@"合计：￥0.00"];
    [priceStr addAttributes:@{NSFontAttributeName:CZY_FONT(14),NSForegroundColorAttributeName:CZY_ORANGE} range:NSMakeRange(0, [@"合计：" length])];
    [priceStr addAttributes:@{NSFontAttributeName:CZY_FONT(12),NSForegroundColorAttributeName:CZY_ORANGE} range:NSMakeRange([@"合计：" length], [@"￥" length])];
    [priceStr addAttributes:@{NSFontAttributeName:CZY_FONT(14), NSForegroundColorAttributeName:CZY_ORANGE} range:NSMakeRange([@"合计：￥" length], [@"0.00" length])];
    _totalPriceLab.attributedText = priceStr;
    _totalPriceLab.textAlignment = NSTextAlignmentCenter;
    [_bottomView addSubview:_totalPriceLab];
}

#pragma mark - tableView实例化
- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ORDER_W, ORDER_H) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[OrderCell class] forCellReuseIdentifier:NSStringFromClass([OrderCell class])];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderModel.czyShopList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.orderModel.czyShopList[section] czyGoodsList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderCell class])];
    
    if (cell == nil) {
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([OrderCell class])];
    }
    
    ShopModel * shopModel = self.orderModel.czyShopList[indexPath.section];
    
    GoodsModel * goodsModel = shopModel.czyGoodsList[indexPath.row];
    
    goodsModel.goodsIndexpath = indexPath;
    
    cell.goodsModel = goodsModel;
    
    // >!商品选择状态回调
    cell.goodsSelectStateBlock = ^(){
        
        // 更新店铺选择状态
        [shopModel updateShopSeletedState];
        
        [_tableView reloadData];
        
        // 更新全选状态
        [self updateTotalSelectState];
        
        // 更新总价格
        [self goodsThatSeletedTotalPriceAccounted];
        // 更新结算数量
        [self goodsThatSelectedTotalAmountAccounted];
    };
    
    // >!增加商品数量回调
    cell.goodsAddAmountBlock = ^(NSInteger amount){

        // 更新总价格
        [self goodsThatSeletedTotalPriceAccounted];
    };
    
    // >!减少商品数量回调
    cell.goodsMinusAmountBlock = ^(NSInteger amount){
        
        // 更新总价格
        [self goodsThatSeletedTotalPriceAccounted];
    };
    
    // >!删除商品回调
    cell.goodsDeleteBlock = ^(NSIndexPath * goodsIndexPath){
        
        [[self.orderModel.czyShopList[goodsIndexPath.section] czyGoodsList] removeObjectAtIndex:indexPath.row];
        
        // 删除没有商品的商店
        if ([[self.orderModel.czyShopList[goodsIndexPath.section] czyGoodsList] count] ==0) {
            [self.orderModel.czyShopList removeObjectAtIndex:goodsIndexPath.section];
        }
        
        
        
        [_tableView reloadData];
    };
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderHeaderView * headerView = [[OrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, ORDER_W, 44)];

    headerView.shopModel = self.orderModel.czyShopList[section];
    
    __weak typeof(headerView) weakHeaderView = headerView;
    
    // >!店铺选择状态回调
    headerView.shopSelectStateRefreshBlock = ^(){
        
        // 更新店铺里每个商品选择状态
        [weakHeaderView.shopModel updateGoodsSelectedState];
        // 更新全选状态
        [self updateTotalSelectState];
        [_tableView reloadData];
        // 计算总价格
        [self goodsThatSeletedTotalPriceAccounted];
        // 更新结算数量
        [self goodsThatSelectedTotalAmountAccounted];
    };
    
    // >!店铺编辑状态回调
    headerView.shopEditStateRefreshBlock = ^(){
    
        [_tableView reloadData];

        for (ShopModel * shopModel in self.orderModel.czyShopList) {
            
            if (shopModel.shopEditStyle == CzyCellStyleNoraml) {
                
                _rightBBi.title = @"编辑";
                
                return ;
            }
        }
        
        _rightBBi.title = @"完成";
    };
    
    return headerView;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction * similar = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"找相似" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"找相似" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVc addAction:sure];
        [self presentViewController:alertVc animated:YES completion:nil];
    }];
    
    similar.backgroundColor = CZY_ORANGE;
    
    UITableViewRowAction * delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self.orderModel.czyShopList[indexPath.section].czyGoodsList removeObjectAtIndex:indexPath.row];
        
        if ([[self.orderModel.czyShopList[indexPath.section] czyGoodsList] count] == 0) {
            [self.orderModel.czyShopList removeObjectAtIndex:indexPath.section];
        }
        
        [_tableView reloadData];
    }];
    
    delete.backgroundColor = CZY_RED;
    
    return @[delete, similar];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}


#pragma mark - 点击全选按钮
- (void)totalSelectBtnClicked:(UIButton *)sender
{
    sender.selected = ! sender.selected;
    
    // 找到每一个店铺 更新状态
    for (ShopModel * shopModel in self.orderModel.czyShopList) {
        
        [shopModel updateTotalBtnSelectedState:sender.selected];
    }
    
    [_tableView reloadData];
    
    // 计算总价格
    [self goodsThatSeletedTotalPriceAccounted];
    // 更新结算数量
    [self goodsThatSelectedTotalAmountAccounted];
}

#pragma mark - 点击结算按钮
- (void)accountBTnClicked:(UIButton *)sender
{
    for (ShopModel * shopModel in self.orderModel.czyShopList) {
        
        for (GoodsModel * goodsModel in shopModel.czyGoodsList) {
            
            if (goodsModel.isGoodsSelected) {
                
                UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"跳转到订单生成界面,网络请求orderId,prepayId等" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertVc addAction:sure];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:nil];
                
                return;
            }
        }
    }
    
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"您还未选择任何商品" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVc addAction:sure];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - 更新全选状态
- (void)updateTotalSelectState
{
    for (ShopModel * model in self.orderModel.czyShopList) {
        
        if (model.isShopSelected == NO) {
            _totalSelectedBtn.selected = NO;
            return ;
        }
    }
    
    _totalSelectedBtn.selected = YES;
}

#pragma mark - 结算价格
- (void)goodsThatSeletedTotalPriceAccounted
{
    CGFloat totalPrice = 0.f;
    
    for (ShopModel * shopModel in self.orderModel.czyShopList) {
        
        for (GoodsModel * goodModel in shopModel.czyGoodsList) {
            
            if (goodModel.isGoodsSelected) {
                
                totalPrice += [goodModel.czyGoodsPrice floatValue] * [goodModel.czyGoodsAmount floatValue];
            }
        }
    }
    
    NSMutableAttributedString * priceStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计：￥%.2f",totalPrice]];
    [priceStr addAttributes:@{NSFontAttributeName:CZY_FONT(14),NSForegroundColorAttributeName:CZY_ORANGE} range:NSMakeRange(0, [@"合计：" length])];
    [priceStr addAttributes:@{NSFontAttributeName:CZY_FONT(12),NSForegroundColorAttributeName:CZY_ORANGE} range:NSMakeRange([@"合计：" length], [@"￥" length])];
    [priceStr addAttributes:@{NSFontAttributeName:CZY_FONT(14), NSForegroundColorAttributeName:CZY_ORANGE} range:NSMakeRange([@"合计：￥" length], [[NSString stringWithFormat:@"%.2f",totalPrice] length])];
    _totalPriceLab.attributedText = priceStr;
}

#pragma mark - 结算数量
- (void)goodsThatSelectedTotalAmountAccounted
{
    NSUInteger amount = 0;
    
    for (ShopModel * shopModel in self.orderModel.czyShopList) {
        
        for (GoodsModel * goodsModel in shopModel.czyGoodsList) {
            
            if (goodsModel.isGoodsSelected) {
                
                amount ++;
            }
        }
    }
    
    [_accountBTn setTitle:[NSString stringWithFormat:@"结算(%ld)", amount] forState:UIControlStateNormal];
}

@end
