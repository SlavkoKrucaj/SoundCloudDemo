//
//  SoundCloudViewController.m
//  SoundcloudDemo
//
//  Created by Slavko Krucaj on 18.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "SoundCloudViewController.h"
#import "SoundCloudCell.h"

@interface SoundCloudViewController ()

@end

@implementation SoundCloudViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationAppereance];

    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
}

- (void)setupNavigationAppereance {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarLandscape"] forBarMetrics:UIBarMetricsLandscapePhone];
    
    UIImage *image = [UIImage imageNamed:@"logout_button"];
    CGRect imageFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *someButton = [[UIButton alloc] initWithFrame:imageFrame];
    [someButton setBackgroundImage:image forState:UIControlStateNormal];
    [someButton setShowsTouchWhenHighlighted:YES];
    //    [someButton addTarget:self action:@selector(sendmail)
    //         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightNavBbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem=rightNavBbutton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"soundcloud_cell";
    SoundCloudCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIFont *font = [UIFont fontWithName:@"BurstMyBubble" size:20];

    cell.title.font = font;
    cell.date.font = font;

    cell.title.text = @"Neki veliki probni tekst. Bla blsdjs dsaffsdasfd";
    cell.date.text = @"29.06.2012";
    
    CGRect newFrame = cell.waveformWrapper.frame;
    newFrame.size.width = 0;
    cell.waveformWrapper.frame = newFrame;

    [cell setArtworkForUrl:@"http://i1.sndcdn.com/artworks-000032213422-8zje8d-crop.jpg?be5bc4b"];
    
    [UIView animateWithDuration:1 animations:^{
        CGRect newFrame = cell.waveformWrapper.frame;
        newFrame.size.width = self.view.frame.size.width;
        cell.waveformWrapper.frame = newFrame;
    }];
    
    return cell;
}

@end
