//
//  User.m
//  twitter
//
//  Created by Githel Lynn Suico on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        NSString *imgURL = dictionary[@"profile_image_url_https"];
        NSString *fileType = @".jpg";
        NSString *baseURL = [imgURL substringToIndex:[imgURL length] - 11];
        NSString *fullURL = [baseURL stringByAppendingString:fileType];
        NSLog(@"%@", fullURL);
        self.profileImgURL = fullURL;
    }
    return self;
}

+ (NSMutableArray *)usersWithArray:(NSArray *)dictionaries{
    NSMutableArray *users = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        User *user = [[User alloc] initWithDictionary:dictionary];
        [users addObject:user];
    }
    return users;
}

@end
