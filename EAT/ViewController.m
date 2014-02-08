//
//  ViewController.m
//  EAT
//
//  Created by Lukas Kollmer on 08.02.14.
//  Copyright (c) 2014 Lukas Kollmer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImage *statusBarImage = [UIImage imageNamed:@"iOS7StatusBar.png"];
    [_imageView setImage:statusBarImage];
    
    
    [self loadWebView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)loadWebView {
    
    NSURL *myUrl = [NSURL URLWithString:@"http://prmg.de/shared/Schulkueche/Speiseplan.pdf"];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myUrl];
    
    [_webView loadRequest:myRequest];
    
    
}

@end
