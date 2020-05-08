//
//  SingerListCell.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "SingerListCell.h"

@implementation SingerListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, 50, 50)];
    [self.contentView addSubview:self.avatarImage];
    
    self.singerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 20, SCREEN_WIDTH-120, 50)];
    self.singerNameLabel.tag = 15001;
    self.singerNameLabel.textColor = TitleUnSelectColor;
    self.singerNameLabel.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:self.singerNameLabel];
}

- (void)cellWithModel:(SingerListModel *)model {
    __weak typeof(self) weakSelf = self;
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg", SingerAvatarUrl, model.Fsinger_mid]] placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        weakSelf.avatarImage.image = [image drawRectWithRoundedCorner];
    }];
    
    self.singerNameLabel.text = model.Fsinger_name;
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
