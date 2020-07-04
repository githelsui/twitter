//
//  User.h
//  twitter
//
//  Created by Githel Lynn Suico on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

// MARK: Properties
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImgURL;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *headerURL;
@property (nonatomic, strong) NSString *tweetCount;
@property (nonatomic, strong) NSString *followerCount;
@property (nonatomic, strong) NSString *followingCount;

// MARK: Methods
// Create initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)usersWithArray:(NSArray *)dictionaries;
@end

NS_ASSUME_NONNULL_END
