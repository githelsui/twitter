//
//  DetailViewController.h
//  twitter
//
//  Created by Githel Lynn Suico on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property (nonatomic, strong) Tweet *tweet;
@end

NS_ASSUME_NONNULL_END
