//
//  UrlViewController.m
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import "UrlViewController.h"

@interface UrlViewController ()

@end

@implementation UrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWkWeb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Create WKWebView
- (void)createWkWeb {
    NSURLRequest *request = [NSURLRequest requestWithURL:self.myURL];
    self.wkWeb = [[WKWebView alloc] initWithFrame:self.view.frame];
    [self.wkWeb  loadRequest:request];
    self.wkWeb.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    self.view = self.wkWeb;
}

- (void)setURL:(NSString *)url {
    self.myURL = [NSURL URLWithString:url];
}

@end
