//
//  SearchResultCell.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/11.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "SearchResultCell.h"

@implementation SearchResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 10, 20, 20)];
    self.iconImage.image = [UIImage imageNamed:@"music"];
    [self.contentView addSubview:self.iconImage];
    
    self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, SCREEN_WIDTH-85, 20)];
    self.resultLabel.tag = 15003;
    self.resultLabel.textColor = TitleUnSelectColor;
    self.resultLabel.font = [UIFont systemFontOfSize:15.5];
    [self.contentView addSubview:self.resultLabel];
}

- (void)cellWithModel:(QQMusicModel *)model {
    NSString *singerInfo = @"";
    for (Singer *singer in model.singer) {
        singerInfo = singerInfo.length > 0 ? [NSString stringWithFormat:@"%@/%@", singerInfo, singer.name] : singer.name;
    }
    self.resultLabel.text = [NSString stringWithFormat:@"%@-%@", model.songname, singerInfo];
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
