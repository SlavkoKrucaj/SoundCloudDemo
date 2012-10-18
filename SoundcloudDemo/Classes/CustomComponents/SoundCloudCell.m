//
//  SoundCloudCell.m
//  SoundcloudDemo
//
//  Created by Slavko Krucaj on 19.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "SoundCloudCell.h"
#import "UIImageView+AFNetworking.h"

@implementation SoundCloudCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setArtworkForUrl:(NSString *)url {
    [self.artwork setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"image_holder"]];
}
@end
