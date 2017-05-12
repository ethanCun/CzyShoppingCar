# CzyShoppingCar
仿淘宝购物订单逻辑

设计模式MVC 控制器450行代码 cell 280行代码 实现类似淘宝购物车的选择，编辑，删除等功能
    
使用YYModel管理数据结构

#### 选择：

    关键逻辑代码：
    
    1， 点击全选按钮，更新其他按钮状态：
    
    // >!更新商里每个商品选择状态
    
    - (void)updateGoodsSelectedState
    {
        for (GoodsModel * model in self.czyGoodsList) {

            model.isGoodsSelected = self.isShopSelected;
        }
    }
    
    2，点击商店更新商品状态
    
    - (void)updateTotalBtnSelectedState:(BOOL)state
    {
        self.isShopSelected = state;

        for (GoodsModel * model in self.czyGoodsList) {

            model.isGoodsSelected = state;
        }
    }
    
    3, 点击商品更改商店和全选按钮状态
    
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
    

    效果图，
    
![image](https://github.com/ITIosEthan/CzyShoppingCar/blob/master/%E9%80%89%E6%8B%A9.gif)

    
    编辑：
    
    // >!更新商店内每个商品编辑状态
    
    - (void)updateGoodsEditState:(CzyCellStyle)style
    {
        for (GoodsModel * model in self.czyGoodsList) {

            model.goodEditStyle = style;
        }
    }
    
效果图，编辑：
![image](https://github.com/ITIosEthan/CzyShoppingCar/blob/master/%E7%BC%96%E8%BE%91.gif)

