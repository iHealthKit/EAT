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
    
    UIImage *statusBarImage = [UIImage imageNamed:@"iOS7StatusBar.png"];
    [_imageView setImage:statusBarImage];
    
    [_navigationBarTitle setTitle:@"EAT."];

    pdfURL = [NSURL URLWithString:@"http://prmg.de/shared/Schulkueche/Speiseplan.pdf"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setURL:pdfURL forKey:@"pdfURL"];
    [userDefaults synchronize];
    
    [self startInternetStatusObserver];
    [self setRefreshControl];
    [self setPdfRequest];
    
}

 
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


# pragma  mark - Internet Connection Status

- (void)startInternetStatusObserver {
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.prmg.de"];
    [hostReachable startNotifier];
    
    // now patiently wait for the notification
    
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
    //pdfStored = 1;
    
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setURL:pdfURL forKey:@"pdfURL"];
    [userDefaults setInteger:pdfStored forKey:@"pdfStored"];
    [userDefaults setValue:resourceDocPath forKey:@"resourceDocPath"];
    [userDefaults setValue:filePath forKey:@"filePath"];
    [userDefaults synchronize];
    
    
    // Now create Request for the file that was saved in your documents folder
    NSURL *url = [NSURL fileURLWithPath:filePath];
    requestObj = [NSURLRequest requestWithURL:url];
    
    //[_webView setDelegate:self];
    //[_webView loadRequest:requestObj];
    [self loadWebView];
    
}

- (void)getLocalPDF {
    
    // Read NSUser defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    filePath = [userDefaults valueForKey:@"filePath"];
    
    // Create Request for the file that was saved in your documents folder
    NSURL *url = [NSURL fileURLWithPath:filePath];
    requestObj = [NSURLRequest requestWithURL:url];
    
    NSLog(@"local PDF displayed");
    
    [self loadWebView];
    
}


- (void)getWebPDF {
    
    NSURL *myUrl = [NSURL URLWithString:@"http://prmg.de/shared/Schulkueche/Speiseplan.pdf"];
    requestObj = [NSURLRequest requestWithURL:myUrl];
    
    [self storePDF];
    [self loadWebView];

    
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
    
    if (filePath != nil && internetActive == 0) {
        //[self storePDF];
        [self getWebPDF];
    }
    

    


    /*
    NSURL *planURL = [NSURL URLWithString:@"http://prmg.de/shared/Schulkueche/Speiseplan.pdf"];
    [userDefaults setURL:planURL forKey:@"planURL"];
    [userDefaults synchronize];
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


- (void)loadWebView {
    
    
    [_webView loadRequest:requestObj];
    //[self storePDF];
    
}

-(void)handleRefresh:(UIRefreshControl *)refresh {
    
    
    [self setPdfRequest];
    [refresh endRefreshing];
}

@end
