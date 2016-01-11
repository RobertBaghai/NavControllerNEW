//
//  UrlViewController.h
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface UrlViewController : UIViewController

@property (nonatomic, strong) NSURL *myURL;
@property (nonatomic, strong) WKWebView *wkWeb;
- (void)setURL:(NSString *)url;

@end
