//
//  SoundCloudViewController.m
//  SoundcloudDemo
//
//  Created by Slavko Krucaj on 18.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "SoundCloudViewController.h"
#import "SoundCloudCell.h"
#import "DocumentHandler.h"
#import "SCUI.h"
#import "JSONKit.h"
#import "SoundCloudItem.h"
#import "AFNetworking.h"
#import "SoundCloudDataFetch.h"

@interface SoundCloudViewController ()
@property (nonatomic, strong) UIView *loginView;
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

- (void)setupLoginView {
    self.loginView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.loginView.backgroundColor = [UIColor orangeColor];
    self.loginView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(50, 350, 220, 50);
    [loginButton setImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor clearColor];
    [loginButton addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    loginButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    
    [self.loginView addSubview:loginButton];
    [self.view addSubview:self.loginView];
    self.tableView.scrollEnabled = NO;
    
    [self accountChanged];

}

- (void)accountChanged {
    if ([SCSoundCloud account]) {
        [UIView animateWithDuration:0.3 animations:^{
            self.loginView.alpha = 0.;
            self.tableView.scrollEnabled = YES;

            //setup logout button
            UIImage *image = [UIImage imageNamed:@"logout_button"];
            CGRect imageFrame = CGRectMake(0, 0, image.size.width, image.size.height);
            
            UIButton *someButton = [[UIButton alloc] initWithFrame:imageFrame];
            [someButton setBackgroundImage:image forState:UIControlStateNormal];
            [someButton setShowsTouchWhenHighlighted:YES];
            [someButton addTarget:self action:@selector(doLogout) forControlEvents:UIControlEventTouchUpInside];
            
            UIBarButtonItem *rightNavBbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
            self.navigationItem.rightBarButtonItem=rightNavBbutton;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.loginView.alpha = 1.;
            self.tableView.scrollEnabled = NO;
            
            self.navigationItem.rightBarButtonItem = nil;
        }];
    
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    
    [self setupNavigationAppereance];
    [self setupFetchedResultsController];
    [self setupLoginView];
    
}

- (void)doLogin {
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
        
        SCLoginViewController *loginViewController;
        loginViewController = [SCLoginViewController loginViewControllerWithPreparedURL:preparedURL
                                                                      completionHandler:^(NSError *error){
                                                                          
                                                                          if (SC_CANCELED(error)) {
                                                                              NSLog(@"Canceled!");
                                                                          } else if (error) {
                                                                              NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                                                                          } else {
                                                                              [self accountChanged];
                                                                              [SoundCloudDataFetch fetchData];
                                                                          }
                                                                      }];
        
        [self presentViewController:loginViewController animated:YES completion:^{
            //do nothing
        }];
        
    }];

}

- (void)doLogout {
    [[DocumentHandler sharedDocumentHandler] dropDatabase];
    [SCSoundCloud removeAccess];
    [self accountChanged];

}

- (void)setupNavigationAppereance {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarLandscape"] forBarMetrics:UIBarMetricsLandscapePhone];    
}

- (void)setupFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SoundCloudItem"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    // no predicate because we want ALL the Photographers
    
    [[DocumentHandler sharedDocumentHandler] performWithDocument:^(UIManagedDocument *document){
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:document.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        
        if ([SCSoundCloud account]) {
            [SoundCloudDataFetch fetchData];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"soundcloud_cell";
    
    //pagination
    NSUInteger numberOfObjects = [[[self.fetchedResultsController sections] objectAtIndex:indexPath.section] numberOfObjects];
    if (indexPath.row > numberOfObjects - 2) {
        [SoundCloudDataFetch fetchData];
        NSLog(@"Dohvacam podatke");
    }
    
    //setup cell
    
    SoundCloudCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    SoundCloudItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIFont *font = [UIFont fontWithName:@"BurstMyBubble" size:20];

    cell.title.font = font;
    cell.date.font = font;

    cell.title.text = [item.name stringByAppendingString:@"\n slavko \n jhkjh"];
    cell.date.text = @"29.06.2012";
    
    CGRect newFrame = cell.waveformWrapper.frame;
    newFrame.size.width = 0;
    cell.waveformWrapper.frame = newFrame;

    [cell setArtworkForUrl:item.artworkUrl];
    
    [cell setWaveformForUrl:item.waveformUrl forSoundCloudItem:item];
    
    return cell;
}

@end
