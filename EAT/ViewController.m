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
    
    [_navigationBarTitle setTitle:@"EAT."];
    
    [self setURLRequest];
    [self setWRefreshControl];
    [self loadWebView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setURLRequest {
    
    NSURL *myUrl = [NSURL URLWithString:@"http://prmg.de/shared/Schulkueche/Speiseplan.pdf"];
    urlRequest = [NSURLRequest requestWithURL:myUrl];
    
    [self loadWebView];
    
}

- (void)setWRefreshControl {
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [_webView.scrollView addSubview:refreshControl];
    
}


- (void)loadWebView {
    
    
    [_webView loadRequest:urlRequest];
    
}

-(void)handleRefresh:(UIRefreshControl *)refresh {
    
    
    [self loadWebView];
    [refresh endRefreshing];
}

@end
