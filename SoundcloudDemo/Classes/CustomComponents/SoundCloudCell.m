//
//  SoundCloudCell.m
//  SoundcloudDemo
//
//  Created by Slavko Krucaj on 19.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "SoundCloudCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+Crop.h"

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

- (void)setWaveformForUrl:(NSString *)url forSoundCloudItem:(SoundCloudItem *)item {
    
    if (item.waveformImage) {
        self.waveform.image = item.waveformImage;
        
        [UIView animateWithDuration:1 animations:^{
            CGRect newFrame = self.waveformWrapper.frame;
            newFrame.size.width = self.frame.size.width;
            self.waveformWrapper.frame = newFrame;
        }];
    } else {
        NSLog(@"Fotka je nil");
    }

}


@end
