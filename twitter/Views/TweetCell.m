//
//  TweetCell.m
//  twitter
//
//  Created by Githel Lynn Suico on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self refreshFav];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)didTapFavorite:(id)sender{
    NSLog(@"tweet that has been liked = %@", self.tweet);
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error faving tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
    [self refreshFav];
}

- (void)refreshFav{
    UIImage *favIcon;
    if(self.tweet.favorited){
        favIcon = [UIImage imageNamed:@"favor-icon-red.png"];
        NSString *favCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        NSMutableAttributedString *attributedFav = [[NSMutableAttributedString alloc] initWithAttributedString:[ self.favButton attributedTitleForState:UIControlStateNormal]];
        [attributedFav replaceCharactersInRange:NSMakeRange(0, attributedFav.length) withString:favCount];
        [self.favButton setAttributedTitle:attributedFav forState:UIControlStateNormal];
    } else {
        favIcon = [UIImage imageNamed:@"favor-icon.png"];
    }
    [self.favButton setImage:favIcon forState:UIControlStateNormal];
}

@end
