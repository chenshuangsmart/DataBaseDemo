//
//  StudentCell.m
//  CoreDataDemo
//
//  Created by cs on 2019/3/22.
//  Copyright © 2019 cs. All rights reserved.
//

#import "StudentCell.h"
#import "UIView+CSLFrame.h"

@interface StudentCell()
/** row veiw */
@property(nonatomic, strong)UIView *rowView;
/** status img */
@property(nonatomic, strong)UIImageView *iconImgView;
/** name */
@property(nonatomic, strong) UILabel *nameLbe;
/** age */
@property(nonatomic, strong) UILabel *ageLbe;
/** end time | surplus time */
@property(nonatomic, strong)UILabel *sexLbe;
/** height */
@property(nonatomic, strong)UILabel *heightLbe;
/** number */
@property(nonatomic, strong)UILabel *numberLbe;
@end

@implementation StudentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [self drawUI];
    }
    return self;
}

- (void)drawUI {
    [self.contentView addSubview:self.rowView];
    
    self.iconImgView.x = 10;
    self.iconImgView.y = 5;
    [self.rowView addSubview:self.iconImgView];
    
    self.nameLbe.x = self.iconImgView.right + 10;
    self.nameLbe.y = self.iconImgView.y;
    [self.rowView addSubview:self.nameLbe];
    
    self.sexLbe.x = self.nameLbe.right + 10;
    self.sexLbe.y = self.nameLbe.y;
    [self.rowView addSubview:self.sexLbe];
    
    self.ageLbe.x = self.sexLbe.right + 10;
    self.ageLbe.y = self.nameLbe.y;
    [self.rowView addSubview:self.ageLbe];
    
    self.numberLbe.x = self.iconImgView.right + 10;
    self.numberLbe.bottom = self.iconImgView.bottom;
    [self.rowView addSubview:self.numberLbe];
    
    self.heightLbe.x = self.numberLbe.right + 10;
    self.heightLbe.y = self.numberLbe.y;
    [self.rowView addSubview:self.heightLbe];
}

- (void)setStudent:(Student *)student {
    _student = student;
    
    if ([student.sex isEqualToString:@"男"]) {
        self.iconImgView.image = [UIImage imageNamed:@"man"];
    } else {
        self.iconImgView.image = [UIImage imageNamed:@"women"];
    }
    
    self.nameLbe.text = student.name;
    [self.nameLbe sizeToFit];
    self.nameLbe.y = 5;
    self.nameLbe.x = self.iconImgView.right + 10;
    
    self.sexLbe.text = student.sex;
    [self.sexLbe sizeToFit];
    self.sexLbe.y = self.nameLbe.y;
    self.sexLbe.x = self.nameLbe.right + 10;
    
    self.ageLbe.text = [NSString stringWithFormat:@"age:%d",student.age];
    [self.ageLbe sizeToFit];
    self.ageLbe.y = self.nameLbe.y;
    self.ageLbe.x = self.sexLbe.right + 10;
    
    self.numberLbe.text = [NSString stringWithFormat:@"number:%d",student.number];
    [self.numberLbe sizeToFit];
    self.numberLbe.bottom = self.iconImgView.bottom;
    self.numberLbe.x = self.iconImgView.right + 10;
    
    self.heightLbe.text = [NSString stringWithFormat:@"height:%d",student.height];
    [self.heightLbe sizeToFit];
    self.heightLbe.y = self.numberLbe.y;
    self.heightLbe.x = self.numberLbe.right + 10;
}

#pragma mark - lazy

- (UIView *)rowView {
    if (_rowView == nil) {
        _rowView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth - 20, 60)];
        _rowView.backgroundColor = [UIColor whiteColor];
        _rowView.layer.cornerRadius = 2;
        _rowView.layer.masksToBounds = YES;
    }
    return _rowView;
}

- (UIImageView *)iconImgView {
    if (_iconImgView == nil) {
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _iconImgView.layer.cornerRadius = 25;
        _iconImgView.layer.masksToBounds = YES;
    }
    return _iconImgView;
}

- (UILabel *)nameLbe {
    if (_nameLbe == nil) {
        _nameLbe = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
        _nameLbe.textColor = [UIColor blackColor];
    }
    return _nameLbe;
}

- (UILabel *)sexLbe {
    if (_sexLbe == nil) {
        _sexLbe = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
        _sexLbe.textColor = [UIColor blackColor];
    }
    return _sexLbe;
}

- (UILabel *)ageLbe {
    if (_ageLbe == nil) {
        _ageLbe = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
        _ageLbe.textColor = [UIColor blackColor];
    }
    return _ageLbe;
}

- (UILabel *)heightLbe {
    if (_heightLbe == nil) {
        _heightLbe = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
        _heightLbe.textColor = [UIColor blackColor];
    }
    return _heightLbe;
}

- (UILabel *)numberLbe {
    if (_numberLbe == nil) {
        _numberLbe = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 20)];
        _numberLbe.textColor = [UIColor blackColor];
    }
    return _numberLbe;
}

@end
