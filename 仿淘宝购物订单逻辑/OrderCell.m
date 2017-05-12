//
//  OrderCell.m
//  仿淘宝购物订单逻辑
//
//  Created by macOfEthan on 17/4/16.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#define margin 12
#define btn_W 30
#define btn_H 30
#define edit_W 60
#define edit_H 10
#define cell_H 100
#define title_H 28

#import "OrderCell.h"

@interface OrderCell ()
{
    UIButton *_cellSelectBtn;
    UIImageView *_goodsImageView;
    
    // >!normal:
    UILabel *_goodsTitleLab;
    UILabel *_goodsCategoryLab;
    UILabel *_goodsPriceLab;
    UILabel *_goodsNumLab;
    
    // >!edit:
    UIButton *_goodsAddBtn;
    UIButton *_goodsMinusBtn;
    UITextField *_goodsEdittingNumTf;
    UIButton *_goodsCategoryBtn;
    UIButton *_goodsDeleteBtn;
}

@end

@implementation OrderCell

#pragma mark - Setter
- (void)setGoodsModel:(GoodsModel *)goodsModel
{
    _goodsModel = goodsModel;

    // 商品图片:
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:_goodsModel.czyGoodsUrl] placeholderImage:[UIImage imageNamed:@""]];
    _goodsTitleLab.text = _goodsModel.czyGoodsName;
    _goodsCategoryLab.text = _goodsModel.czyGoodsSpecs;
    
    // 更新按钮选择状态
    if (_goodsModel.isGoodsSelected == YES) {
        _cellSelectBtn.selected = YES;
    }else{
        _cellSelectBtn.selected = NO;
    }
    
    
    if (goodsModel.goodEditStyle == CzyCellStyleNoraml) {
        
        [self hiddenEditUI];
        
        // >!noraml :
        // price:
        NSMutableAttributedString * price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",_goodsModel.czyGoodsPrice]];
        [price addAttributes:@{NSFontAttributeName:CZY_FONT(9),NSForegroundColorAttributeName:CZY_RED} range:NSMakeRange(0, [@"￥" length])];
        [price addAttributes:@{NSFontAttributeName:CZY_FONT(11),NSForegroundColorAttributeName:CZY_RED} range:NSMakeRange([@"￥" length], [price length]-[@"￥" length])];
        _goodsPriceLab.attributedText = price;
        
        // num:
        NSMutableAttributedString * num = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"x%@",_goodsModel.czyGoodsAmount]];
        [price addAttributes:@{NSFontAttributeName:CZY_FONT(9),NSForegroundColorAttributeName:CZY_BLACK} range:NSMakeRange(0, [@"x" length])];
        [price addAttributes:@{NSFontAttributeName:CZY_FONT(11),NSForegroundColorAttributeName:CZY_BLACK} range:NSMakeRange([@"x" length], [price length]-[@"x" length])];
        _goodsNumLab.attributedText = num;
        

    }else{
    
        // >!selected:
        [self hiddenNormalUI];
        
        _goodsEdittingNumTf.text = goodsModel.czyGoodsAmount;
    }

    
}

#pragma mark - initialize
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initialGoodsCellUI];
    }
    return self;
}

- (void)initialGoodsCellUI
{
    /*Q1:self.frame 高度为44？*/
    _cellSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cellSelectBtn setImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
    [_cellSelectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    _cellSelectBtn.frame = CGRectMake(margin, cell_H/2-btn_H/2, btn_W, btn_H);
    [_cellSelectBtn addTarget:self action:@selector(goodsSeleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_cellSelectBtn];
    
    _goodsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cellSelectBtn.frame), margin, cell_H-2*margin, cell_H-2*margin)];
    _goodsImageView.backgroundColor = CZY_RED;
    [self.contentView addSubview:_goodsImageView];
    
    // >!normal:
    _goodsTitleLab  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodsImageView.frame)+margin, CGRectGetMinY(_goodsImageView.frame), CZY_WIDTH-CGRectGetMaxX(_goodsImageView.frame)-2*margin, title_H)];
    _goodsTitleLab.text = @"Asus/华硕 F540 F540UP顽石畅玩版15.6英寸商务办公笔记本电脑";
    _goodsTitleLab.font = CZY_FONT(11);
    _goodsTitleLab.textColor = CZY_BLACK;
    _goodsTitleLab.numberOfLines = 2;
    _goodsTitleLab.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_goodsTitleLab];
    
    _goodsCategoryLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_goodsTitleLab.frame), CGRectGetMaxY(_goodsTitleLab.frame), CGRectGetWidth(_goodsTitleLab.frame), title_H)];
    _goodsCategoryLab.text = @"颜色分类：纳米佛手H08;漂号：一套3只，全国包邮";
    _goodsCategoryLab.numberOfLines = 2;
    _goodsNumLab.lineBreakMode = NSLineBreakByCharWrapping;
    _goodsCategoryLab.textColor = CZY_BLACK;
    _goodsCategoryLab.font = CZY_FONT(11);
    [self.contentView addSubview:_goodsCategoryLab];
    
    _goodsPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_goodsTitleLab.frame), CGRectGetMaxY(_goodsCategoryLab.frame), 100, title_H)];
    _goodsPriceLab.text = @"￥18.0";
    _goodsPriceLab.textColor = CZY_RED;
    _goodsPriceLab.textAlignment = NSTextAlignmentLeft;
    _goodsPriceLab.font = CZY_FONT(11);
    [self.contentView addSubview:_goodsPriceLab];
    
    _goodsNumLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodsTitleLab.frame)-100, CGRectGetMinY(_goodsPriceLab.frame), 100, title_H)];
    _goodsNumLab.text = @"x10";
    _goodsNumLab.textColor = CZY_BLACK;
    _goodsNumLab.font = CZY_FONT(11);
    _goodsNumLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_goodsNumLab];
    
    // >! selected:
    _goodsMinusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodsMinusBtn addTarget:self action:@selector(goodsMinusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _goodsMinusBtn.frame = CGRectMake(CGRectGetMaxX(_goodsImageView.frame)+margin, CGRectGetMinY(_goodsImageView.frame), btn_W, btn_H);
    [_goodsMinusBtn setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
    [self.contentView addSubview:_goodsMinusBtn];
    
    _goodsEdittingNumTf = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_goodsMinusBtn.frame), CGRectGetMinY(_goodsImageView.frame), CZY_WIDTH-2*btn_W-margin-btn_W-CGRectGetMaxX(_goodsMinusBtn.frame), btn_H)];
    _goodsEdittingNumTf.text = @"1";
    _goodsEdittingNumTf.backgroundColor = [CZY_BLACK colorWithAlphaComponent:.05];
    _goodsEdittingNumTf.textAlignment = NSTextAlignmentCenter;
    _goodsEdittingNumTf.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_goodsEdittingNumTf];
    
    _goodsAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodsAddBtn addTarget:self action:@selector(goodsAddBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _goodsAddBtn.frame = CGRectMake(CZY_WIDTH-2*btn_W-margin-btn_W, CGRectGetMinY(_goodsImageView.frame), btn_W, btn_H);
    [_goodsAddBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [self.contentView addSubview:_goodsAddBtn];
    
    _goodsCategoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodsCategoryBtn addTarget:self action:@selector(goodsCategoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _goodsCategoryBtn.frame = CGRectMake(CGRectGetMinX(_goodsMinusBtn.frame), CGRectGetMaxY(_goodsMinusBtn.frame), CZY_WIDTH-2*btn_W-2*margin-CGRectGetMaxX(_goodsImageView.frame), CGRectGetHeight(_goodsImageView.frame)-btn_H);
    [_goodsCategoryBtn setTitle:@"颜色分类：纳米佛手H08;漂号：一套3只，全国包邮" forState:UIControlStateNormal];
    [_goodsCategoryBtn setTitleColor:CZY_BLACK forState:UIControlStateNormal];
    _goodsCategoryBtn.titleLabel.font = CZY_FONT(11);
    _goodsCategoryBtn.titleLabel.numberOfLines = 2;
    [_goodsCategoryBtn setImage:[UIImage imageNamed:@"arrowDown"] forState:UIControlStateNormal];
    _goodsCategoryBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, btn_W);
    _goodsCategoryBtn.imageEdgeInsets = UIEdgeInsetsMake(0, CGRectGetWidth(_goodsCategoryBtn.frame)-btn_W*.8, 0, 0);
    [self.contentView addSubview:_goodsCategoryBtn];
    
    _goodsDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodsDeleteBtn addTarget:self action:@selector(goodsDeleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _goodsDeleteBtn.frame = CGRectMake(CZY_WIDTH-btn_W*2, 0, btn_W*2, cell_H);
    [_goodsDeleteBtn setTitleColor:CZY_WHITE forState:UIControlStateNormal];
    [_goodsDeleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    _goodsDeleteBtn.backgroundColor = CZY_RED;
    [self.contentView addSubview:_goodsDeleteBtn];
}

#pragma mark - 选择商品
- (void)goodsSeleBtnClick:(UIButton *)sender
{
    self.goodsModel.isGoodsSelected = !self.goodsModel.isGoodsSelected;
    
    if (self.goodsSelectStateBlock) {
        self.goodsSelectStateBlock();
    }
}

#pragma mark - 减少数量
- (void)goodsMinusBtnClicked:(UIButton *)sender
{
    NSInteger amount = [_goodsEdittingNumTf.text integerValue];
    
    if (amount <= 1) {
        
        UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"再少就没了" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVc addAction:sure];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:nil];
        return;
    }
    
    amount--;
    
    self.goodsModel.czyGoodsAmount = [NSString stringWithFormat:@"%ld", amount];
    
    _goodsEdittingNumTf.text = self.goodsModel.czyGoodsAmount;
    
    if (self.goodsMinusAmountBlock) {
        self.goodsMinusAmountBlock(amount);
    }
}

#pragma mark - 增加数量
- (void)goodsAddBtnClicked:(UIButton *)sender
{
    NSInteger amount = [_goodsEdittingNumTf.text integerValue];
    
    amount++;
    
    self.goodsModel.czyGoodsAmount = [NSString stringWithFormat:@"%ld", amount];
    
    _goodsEdittingNumTf.text = self.goodsModel.czyGoodsAmount;
    
    if (self.goodsAddAmountBlock) {
        self.goodsAddAmountBlock(amount);
    }
}

#pragma mark - 点击分类
- (void)goodsCategoryBtnClicked:(UIButton *)sender
{
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"暂未编写" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVc addAction:sure];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark - 点击删除
- (void)goodsDeleteBtnClicked:(UIButton *)sender
{
    if (self.goodsDeleteBlock) {
        self.goodsDeleteBlock(self.goodsModel.goodsIndexpath);
    }
}

#pragma mark - 编辑UI切换
- (void)hiddenNormalUI
{
    _goodsTitleLab.hidden = YES;
    _goodsCategoryLab.hidden = YES;
    _goodsPriceLab.hidden = YES;
    _goodsNumLab.hidden = YES;
    
    _goodsAddBtn.hidden = NO;
    _goodsMinusBtn.hidden = NO;
    _goodsEdittingNumTf.hidden = NO;
    _goodsCategoryBtn.hidden = NO;
    _goodsDeleteBtn.hidden = NO;
}
- (void)hiddenEditUI
{
    _goodsTitleLab.hidden = NO;
    _goodsCategoryLab.hidden = NO;
    _goodsPriceLab.hidden = NO;
    _goodsNumLab.hidden = NO;
    
    _goodsAddBtn.hidden = YES;
    _goodsMinusBtn.hidden = YES;
    _goodsEdittingNumTf.hidden = YES;
    _goodsCategoryBtn.hidden = YES;
    _goodsDeleteBtn.hidden = YES;
}

#pragma mark - other
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
