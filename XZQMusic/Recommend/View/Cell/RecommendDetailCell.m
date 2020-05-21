//
//  RecommendDetailCell.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/20.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RecommendDetailCell.h"

@implementation RecommendDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.songNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 25)];
    self.songNameLabel.tag = 15004;
    self.songNameLabel.font = [UIFont systemFontOfSize:15.0 weight:1.1];
    [self.contentView addSubview:self.songNameLabel];
    
    self.describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, SCREEN_WIDTH-40, 20)];
    self.describeLabel.tag = 15005;
    self.describeLabel.textColor = TitleUnSelectColor;
    self.describeLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.describeLabel];
}

- (void)cellWithModel:(QQMusicModel *)model {
    self.songNameLabel.text = model.songname;
    NSString *singerInfo = @"";
    for (Singer *singer in model.singer) {
        singerInfo = singerInfo.length > 0 ? [NSString stringWithFormat:@"%@/%@", singerInfo, singer.name] : singer.name;
    }
    singerInfo = model.albumname.length > 0 ? [NSString stringWithFormat:@"%@·%@", singerInfo, model.albumname] : singerInfo;
    self.describeLabel.text = singerInfo;
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
