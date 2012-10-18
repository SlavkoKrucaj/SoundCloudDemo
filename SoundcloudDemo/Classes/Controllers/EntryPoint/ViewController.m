//
//  ViewController.m
//  SoundcloudDemo
//
//  Created by Slavko Krucaj on 17.10.2012..
//  Copyright (c) 2012. slavko.krucaj. All rights reserved.
//

#import "ViewController.h"
#import "SCUI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    if (![SCSoundCloud account]) {
//        //user not loged in
//        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
//        view.backgroundColor = [UIColor orangeColor];
//        [self.view addSubview:view];
//    }
}




- (IBAction)login:(id)sender {
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
        
        SCLoginViewController *loginViewController;
        loginViewController = [SCLoginViewController loginViewControllerWithPreparedURL:preparedURL
                                                                      completionHandler:^(NSError *error){
                                                                          
                                                                          if (SC_CANCELED(error)) {
                                                                              NSLog(@"Canceled!");
                                                                          } else if (error) {
                                                                              NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                                                                          } else {
                                                                              NSLog(@"Done!");
                                                                          }
                                                                      }];
        
        [self presentViewController:loginViewController animated:YES completion:^{
            //do nothing
        }];
        
    }];

}

- (IBAction)test:(id)sender {
    [SCRequest performMethod:SCRequestMethodGET
                           onResource:[NSURL URLWithString:@"https://api.soundcloud.com/users/25974038/favorites.json"]
                      usingParameters:nil
                          withAccount:[SCSoundCloud account]
               sendingProgressHandler:nil
                      responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                          // Handle the response
                          if (error) {
                              NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                          } else {
                              NSLog(@"Data je %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                          }
                      }];
}


- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Tu sam %@", [SCSoundCloud account].identifier);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
