//
//  RankDetailCell.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/21.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RankDetailCell.h"

@implementation RankDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 45)];
    self.rankLabel.tag = 15006;
    self.rankLabel.textAlignment = NSTextAlignmentCenter;
    self.rankLabel.font = [UIFont systemFontOfSize:19.0];
    self.rankLabel.textColor = TitleSelectColor;
    [self.contentView addSubview:self.rankLabel];
    
    self.rankImage = [[UIImageView alloc] initWithFrame:CGRectMake(22.5, 20, 25, 25)];
    [self.contentView addSubview:self.rankImage];
    
    self.songNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, SCREEN_WIDTH-90, 25)];
    self.songNameLabel.tag = 15007;
    self.songNameLabel.font = [UIFont systemFontOfSize:15.0 weight:1.1];
    [self.contentView addSubview:self.songNameLabel];
    
    self.describeLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 35, SCREEN_WIDTH-90, 20)];
    self.describeLabel.tag = 15008;
    self.describeLabel.textColor = TitleUnSelectColor;
    self.describeLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.describeLabel];
}

- (void)cellWithModel:(QQMusicModel *)model rankNum:(NSInteger)index showImage:(NSString *)imageUrl {
    if (imageUrl.length > 0) {
        [self.rankLabel setHidden:YES];
        [self.rankImage setHidden:NO];
        self.rankImage.image = [UIImage imageNamed:imageUrl];
    } else {
        [self.rankLabel setHidden:NO];
        [self.rankImage setHidden:YES];
        self.rankLabel.text = [NSString stringWithFormat:@"%zd", index];
    }
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
