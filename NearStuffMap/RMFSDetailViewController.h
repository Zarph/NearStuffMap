//
//  RMFSDetailViewController.h
//  NearStuffMap
//
//  Created by Marco Graciano on 5/29/13.
//  Copyright (c) 2013 Marco Graciano & Ramiro Guerrero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface RMFSDetailViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *customWebView;
}

@property (nonatomic, copy) NSString *fsVenueCanonicalURLString;



@end
