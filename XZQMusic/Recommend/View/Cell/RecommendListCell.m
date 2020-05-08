//
//  RecommendListCell.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RecommendListCell.h"

@implementation RecommendListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 60, 60)];
    [self.contentView addSubview:self.coverImage];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, SCREEN_WIDTH-105, 25)];
    self.nameLabel.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:self.nameLabel];
    
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 30, SCREEN_WIDTH-105, 35)];
    self.descLabel.tag = 15000;
    self.descLabel.font = [UIFont systemFontOfSize:14.0];
    self.descLabel.textColor = TitleUnSelectColor;
    self.descLabel.numberOfLines = 2;
    [self.contentView addSubview:self.descLabel];
}

- (void)cellWithModel:(DiscListModel *)model {
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.nameLabel.text = model.creator.name;
    self.descLabel.text = model.dissname;
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
