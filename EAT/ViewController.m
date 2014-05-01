//
//  ViewController.m
//  EAT
//
//  Created by Lukas Kollmer on 08.02.14.
//  Copyright (c) 2014 Lukas Kollmer. All rights reserved.
//

#import "ViewController.h"
#import "Reachability.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setTitle:@"EAT."];

    pdfURL = [NSURL URLWithString:@"http://prmg.de/shared/Schulkueche/Speiseplan.pdf"];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setURL:pdfURL forKey:@"pdfURL"];
    [userDefaults synchronize];
    
    [self startInternetStatusObserver];
    [self setRefreshControl];
    [self setPdfRequest];

    
}

- (void)viewDidAppear:(BOOL)animated {
    
    //[self setPdfRequest];
    
}
 
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"observer removed");
}


# pragma  mark - Internet Connection Status

- (void)startInternetStatusObserver {
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification
    NSLog(@"observer started");
    
}


-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            internetActive = NO;
            NSLog(@"InternetActive: %i", internetActive);
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            internetActive = YES;
            NSLog(@"InternetActive: %i", internetActive);
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            internetActive = YES;
            NSLog(@"InternetActive: %i", internetActive);
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            hostActive = NO;
            NSLog(@"hostActive: %i", hostActive);
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            hostActive = YES;
            NSLog(@"hostActive: %i", hostActive);
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            hostActive = YES;
            NSLog(@"hostActive: %i", hostActive);
            
            break;
        }
    }
}

# pragma  mark - PDF

- (void)storePDF {
    
    // Read NSUser defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    filePath = [userDefaults valueForKey:@"filePath"];
    
    
    if (filePath != nil) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error: nil];
        NSLog(@"old file deleted");
    }
    
    // Get the PDF Data from the url in a NSData Object
    NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[
                                                             NSURL URLWithString:@"http://prmg.de/shared/Schulkueche/Speiseplan.pdf"]];
    
    // Store the Data locally as PDF File
    resourceDocPath = [[NSString alloc] initWithString:[
                                                                  [[[NSBundle mainBundle] resourcePath] stringByDeletingLastPathComponent]
                                                                  stringByAppendingPathComponent:@"Documents"
                                                                  ]];
    
    filePath = [resourceDocPath
                          stringByAppendingPathComponent:@"Speiseplan.pdf"];
    [pdfData writeToFile:filePath atomically:YES];
    NSLog(@"PDF stored");
    
    
    [userDefaults setValue:resourceDocPath forKey:@"resourceDocPath"];
    [userDefaults setValue:filePath forKey:@"filePath"];
    [userDefaults synchronize];
    
    
}

- (void)getLocalPDF {
    
    // Read NSUser defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    filePath = [userDefaults valueForKey:@"filePath"];
    
    // Create Request for the file that was saved in your documents folder
    NSURL *url = [NSURL fileURLWithPath:filePath];
    requestObj = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:requestObj];
    
    NSLog(@"local PDF displayed");
    
}


- (void)getWebPDF {
    
    requestObj = [NSURLRequest requestWithURL:pdfURL];
    [_webView loadRequest:requestObj];
    NSLog(@"load Request");

    
    [self storePDF];
    
}


- (void)setPdfRequest {
    
    // Read NSUser defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    filePath = [userDefaults valueForKey:@"filePath"];
    
    NSLog(@"FilePath: %@", filePath);
    
    if (filePath == nil && internetActive == 0) {
        //[self storePDF];
        [self getWebPDF];
    }
    
    if (filePath == nil && internetActive == 1) {
        [self showNoConnectionAlert];
    }
    
    if (filePath != nil && internetActive == 1) {
        [self getLocalPDF];
        
    }
    
    if (filePath != nil && internetActive == 0
        ) {
        //[self storePDF];
        [self getWebPDF];
    }

    
    /*
    if (filePath == nil) {
        if (internetActive == 0) {
            [self getWebPDF];
        }
        else {
            [self showNoConnectionAlert];
        }
    } else {
        if (internetActive == 1) {
            [self getLocalPDF];
        }
        else {
            [self getWebPDF];
        }
    }
    */
}

- (void)showNoConnectionAlert {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"No Connection"
                                                   message: @"Your internet connection appears to be offline. \nIn future, this shouldn't be a problem because the pdf is downloaded and stored local once you are connected to the internet."
                                                  delegate: self
                                         cancelButtonTitle:@"Dismiss"
                                         otherButtonTitles:nil];
    
    [alert show];
    
}

#pragma  mark - webView

- (void)setRefreshControl {
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [_webView.scrollView addSubview:refreshControl];
    
}


-(void)handleRefresh:(UIRefreshControl *)refresh {
    
    
    [self setPdfRequest];
    [refresh endRefreshing];
}


- (IBAction)actionButton:(id)sender {


    /*
    NSString* someText = @"Hi";
    NSArray* dataToShare = @[someText];  // ...or whatever pieces of data you want to share.
    NSArray *pdfToShare = [NSData dataWithContentsOfFile:PDFFileWithName];

    UIActivityViewController* activityViewController =
            [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                              applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:^{}];
    */

    NSString *path = [[NSBundle mainBundle] pathForResource:@"Speiseplan" ofType:@"pdf"];
    NSData *dataFromPath = [NSData dataWithContentsOfFile:path];

    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];

    if(printController && [UIPrintInteractionController canPrintData:dataFromPath]) {

        printController.delegate = self;

        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [path lastPathComponent];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        printController.printInfo = printInfo;
        printController.showsPageRange = YES;
        printController.printingItem = dataFromPath;

        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %ld", error.domain, (long)error.code);
            }
        };

        [printController presentAnimated:YES completionHandler:completionHandler];

    }



}
@end
