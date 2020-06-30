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
    [self refreshRetweet];
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

- (IBAction)retweetTapped:(id)sender {
    NSLog(@"tweet that has been retweeted = %@", self.tweet);
    self.tweet.retweeted = YES;
    self.tweet.retweetCount += 1;
    [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
        }
    }];
    [self refreshRetweet];
    [self.delegate didTweet:self.tweet];
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

- (void)refreshRetweet{
    UIImage *retweetIcon;
      if(self.tweet.retweeted){
          retweetIcon = [UIImage imageNamed:@"retweet-icon-green.png"];
          NSString *retweetCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
          NSMutableAttributedString *attributedRetweet = [[NSMutableAttributedString alloc] initWithAttributedString:[ self.retweetButton attributedTitleForState:UIControlStateNormal]];
          [attributedRetweet replaceCharactersInRange:NSMakeRange(0, attributedRetweet.length) withString:retweetCount];
          [self.retweetButton setAttributedTitle:attributedRetweet forState:UIControlStateNormal];
      } else {
          retweetIcon = [UIImage imageNamed:@"retweet-icon.png"];
      }
      [self.retweetButton setImage:retweetIcon forState:UIControlStateNormal];
}

@end
