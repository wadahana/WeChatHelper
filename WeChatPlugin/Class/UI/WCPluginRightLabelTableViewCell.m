//
//  WCPluginRightLabelTableViewCell.m
//  IPAPatch
//
//  Created by 吴昕 on 28/07/2017.
//  Copyright © 2017 Weibo. All rights reserved.
//

#import "WCPluginRightLabelTableViewCell.h"

@implementation WCPluginRightLabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        self.rightLabel.numberOfLines = 0;
        self.rightLabel.textColor = UIColorMake(100,100,100);
        [self.contentView addSubview:self.rightLabel];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.contentView.frame;
    UIFont * font = [self.rightLabel font];
    //CGSize size = [self.rightLabel.text sizeWithFont:font];
    CGSize size = [self.rightLabel.text sizeWithAttributes: @{@"NSFontAttributeName" : font}];
    self.rightLabel.frame = CGRectMake(frame.size.width - size.width - 5, (frame.size.height - size.height)/2, size.width, size.height);
}

@end
