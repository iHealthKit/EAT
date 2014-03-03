//
//  ViewController.h
//  EAT
//
//  Created by Lukas Kollmer on 08.02.14.
//  Copyright (c) 2014 Lukas Kollmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

@class Reachability;

@interface ViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate, UIPrintInteractionControllerDelegate>
{
    // Internet Reachability
    NSURLRequest *requestObj;
    Reachability *internetReachable;
    Reachability *hostReachable;
    
    BOOL internetActive;
    BOOL hostActive;
    
    
    // WebView
    NSURL *pdfURL;
    NSString *resourceDocPath;
    NSString *filePath;
    int pdfStored;
}


// Internet Connection
-(void) checkNetworkStatus:(NSNotification *)notice;

// Outlets
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
- (IBAction)actionButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
