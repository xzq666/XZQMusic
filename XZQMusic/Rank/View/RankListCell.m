//
//  RankListCell.m
//  XZQMusic
//
//  Created by qhzc-iMac-02 on 2020/5/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RankListCell.h"

@implementation RankListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7.5, 100, 100)];
    [self.contentView addSubview:self.coverImage];
    
    CALayer *topBGLayer = [[CALayer alloc] init];
    topBGLayer.frame = CGRectMake(115, 7.5, SCREEN_WIDTH-130, 100);
    topBGLayer.backgroundColor = CellViewBackgroundColor.CGColor;
    [self.contentView.layer addSublayer:topBGLayer];
    
    self.top1Label = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, SCREEN_WIDTH-170, 26)];
    self.top1Label.textColor = TitleUnSelectColor;
    self.top1Label.font = [UIFont systemFontOfSize:13.0];
    [topBGLayer addSublayer:self.top1Label.layer];
    
    self.top2Label = [[UILabel alloc] initWithFrame:CGRectMake(15, 37, SCREEN_WIDTH-140, 26)];
    self.top2Label.textColor = TitleUnSelectColor;
    self.top2Label.font = [UIFont systemFontOfSize:13.0];
    [topBGLayer addSublayer:self.top2Label.layer];
    
    self.top3Label = [[UILabel alloc] initWithFrame:CGRectMake(15, 63, SCREEN_WIDTH-140, 26)];
    self.top3Label.textColor = TitleUnSelectColor;
    self.top3Label.font = [UIFont systemFontOfSize:13.0];
    [topBGLayer addSublayer:self.top3Label.layer];
}

- (void)cellWithModel:(RankListModel *)model {
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    if (model.songList.count >= 3) {
        Song *song1 = model.songList[0];
        self.top1Label.text = [NSString stringWithFormat:@"1%@-%@", song1.songname, song1.singername];
        Song *song2 = model.songList[1];
        self.top2Label.text = [NSString stringWithFormat:@"2%@-%@", song2.songname, song2.singername];
        Song *song3 = model.songList[2];
        self.top3Label.text = [NSString stringWithFormat:@"3%@-%@", song3.songname, song3.singername];
    } else if (model.songList.count == 2) {
        Song *song1 = model.songList[0];
        self.top1Label.text = [NSString stringWithFormat:@"1%@-%@", song1.songname, song1.singername];
        Song *song2 = model.songList[1];
        self.top2Label.text = [NSString stringWithFormat:@"2%@-%@", song2.songname, song2.singername];
    } else if (model.songList.count == 1) {
        Song *song1 = model.songList[0];
        self.top1Label.text = [NSString stringWithFormat:@"1%@-%@", song1.songname, song1.singername];
    }
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
