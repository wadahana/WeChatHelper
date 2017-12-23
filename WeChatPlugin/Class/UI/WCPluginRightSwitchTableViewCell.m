//
//  WCPluginRightSwitchTableViewCell.m
//  IPAPatch
//
//  Created by 吴昕 on 28/07/2017.
//  Copyright © 2017 Weibo. All rights reserved.
//

#import "WCPluginRightSwitchTableViewCell.h"

@implementation WCPluginRightSwitchTableViewCell

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
        self.rightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0,0,43,32)];
        [self.contentView addSubview:self.rightSwitch];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.contentView.frame;
    CGSize size = self.rightSwitch.frame.size;
    self.rightSwitch.frame = CGRectMake(frame.size.width - size.width - 10, (frame.size.height - size.height)/2, size.width, size.height);
}
@end
