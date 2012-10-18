//
//  SoundCloudCell.h
//  SoundcloudDemo
//
//  Created by Slavko Krucaj on 19.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoundCloudCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *date;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UIImageView *waveform;
@property (nonatomic, weak) IBOutlet UIImageView *artwork;
@property (nonatomic, weak) IBOutlet UIView *waveformWrapper;

- (void)setArtworkForUrl:(NSString *)url;

@end
