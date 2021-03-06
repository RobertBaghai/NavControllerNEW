//
//  DataAccessObject.m
//  Nav Controller Re-Done
//
//  Created by Robert Baghai on 1/8/16.
//  Copyright © 2016 Robert Baghai. All rights reserved.
//

#import "DataAccessObject.h"
#import "Company.h"
#import "Product.h"

@implementation DataAccessObject

#pragma mark - Shared Instance Method
+ (instancetype)sharedInstance {
    static dispatch_once_t cp_singleton_once_token;
    static DataAccessObject *sharedInstance;
    dispatch_once(&cp_singleton_once_token, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.companyList = [[NSMutableArray alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Hard Coded Values
- (void)getCompaniesAndProducts {
    Company *apple = [[Company alloc] init];
    apple.companyName = @"Apple Mobile Devices";
    apple.companyLogo = [UIImage imageNamed: @"apple.jpg"];
    apple.stockCode = @"AAPL";
    Product *iPad = [[Product alloc] init];
    iPad.productName = @"iPad";
    iPad.productLogo = [UIImage imageNamed:@"ipad.jpg"];
    iPad.productUrl = @"https://www.apple.com/ipad/";
    Product *iPod = [[Product alloc] init];
    iPod.productName = @"iPod Touch";
    iPod.productLogo = [UIImage imageNamed:@"ipod.jpg"];
    iPod.productUrl = @"https://www.apple.com/ipod-touch/";
    Product *iPhone = [[Product alloc] init];
    iPhone.productName = @"iPhone";
    iPhone.productLogo = [UIImage imageNamed:@"iphone.jpg"];
    iPhone.productUrl = @"https://www.apple.com/iphone/";
    apple.companyProducts = [[NSMutableArray alloc] initWithObjects:iPad, iPod, iPhone, nil];
    
    Company *samsung = [[Company alloc] init];
    samsung.companyName = @"Samsung Mobile Devices";
    samsung.companyLogo = [UIImage imageNamed:@"samsung.jpg"];
    samsung.stockCode = @"SSUN.DE";
    Product *galaxy = [[Product alloc] init];
    galaxy.productName = @"Galaxy S5";
    galaxy.productLogo = [UIImage imageNamed:@"s5.jpg"];
    galaxy.productUrl = @"http://www.samsung.com/global/microsite/galaxys5/features.html";
    Product *note = [[Product alloc] init];
    note.productName = @"Galaxy Note";
    note.productLogo = [UIImage imageNamed:@"note.jpg"];
    note.productUrl = @"https://www.samsung.com/us/mobile/galaxy-note/";
    Product *tab = [[Product alloc] init];
    tab.productName = @"Galaxy Tab";
    tab.productLogo = [UIImage imageNamed:@"tablet.jpg"];
    tab.productUrl = @"https://www.samsung.com/us/explore/tab-s2-features-and-specs/?cid=ppc-";
    samsung.companyProducts = [[NSMutableArray alloc] initWithObjects:galaxy, note, tab, nil];
    
    Company *htc = [[Company alloc] init];
    htc.companyName = @"HTC Mobile Devices";
    htc.companyLogo = [UIImage imageNamed:@"htc.png"];
    htc.stockCode = @"GOOG";
    Product *htcOne = [[Product alloc] init];
    htcOne.productName = @"HTC One M9";
    htcOne.productLogo = [UIImage imageNamed:@"htcone.jpg"];
    htcOne.productUrl = @"https://www.htc.com/us/smartphones/htc-one-m9/";
    Product *nexus = [[Product alloc] init];
    nexus.productName = @"Google Nexus";
    nexus.productLogo = [UIImage imageNamed:@"nexus.jpg"];
    nexus.productUrl = @"https://store.google.com/product/nexus_6p?utm_source=en-ha-na-sem&utm_medium=text&utm_content=skws&utm_campaign=nexus6p&gclid=CjwKEAjws7OwBRCn2Ome5tPP8gESJAAfopWsF1f3gGR_3ME1Ixcmv8sq_vO9pzHjJwS6Sf_ztXnn_hoCiRDw_wcB";
    Product *camera = [[Product alloc] init];
    camera.productName = @"RE Camera";
    camera.productLogo = [UIImage imageNamed:@"camera.jpg"];
    camera.productUrl = @"https://www.htc.com/us/re/re-camera/";
    htc.companyProducts = [[NSMutableArray alloc] initWithObjects: htcOne, nexus, camera, nil];
    
    self.companyList = [NSMutableArray arrayWithArray:@[apple, samsung, htc]];
}

#pragma mark - Update Stocks
- (void) updateStockPrices {
    for (int i = 0; i < self.companyList.count; i++) {
        [self.companyList[i] setStockPrice:self.stockPrices[i]];
    }
}

@end
