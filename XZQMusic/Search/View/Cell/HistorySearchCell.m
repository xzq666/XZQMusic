//
//  HistorySearchCell.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/9.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "HistorySearchCell.h"

@implementation HistorySearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.searchKeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-95, 35)];
    self.searchKeyLabel.tag = 15002;
    self.searchKeyLabel.textColor = TitleUnSelectColor;
    self.searchKeyLabel.font = [UIFont systemFontOfSize:15.5];
    [self.contentView addSubview:self.searchKeyLabel];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.frame = CGRectMake(SCREEN_WIDTH-55, 0, 35, 35);
    [self.deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(11, 11, 11, 11)];
    self.deleteBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteClick {
    if ([self.delegate respondsToSelector:@selector(deleteHistorySearchKey:)]) {
        [self.delegate deleteHistorySearchKey:self];
    }
}

- (void)cellWithKeyword:(NSString *)keyword {
    self.searchKeyLabel.text = keyword;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
