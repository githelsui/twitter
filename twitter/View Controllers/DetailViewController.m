//
//  DetailViewController.m
//  twitter
//
//  Created by Githel Lynn Suico on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileIcon;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favButton;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateFav];
    [self updateRetweet];
    // Do any additional setup after loading the view.
}

- (void)setTweetInfo{
    NSLog(@"tweet here %@", self.tweet);
    NSURL *iconURL = [NSURL URLWithString:self.tweet.user.profileImgURL];
    [self.profileIcon setImageWithURL:iconURL];
    self.profileIcon.layer.cornerRadius = 10;
    self.authorLabel.text = self.tweet.user.screenName;
    self.usernameLabel.text = self.tweet.user.name;
    self.dateLabel.text = self.tweet.originalDate;
    self.timeLabel.text = self.tweet.timeString;
    self.tweetLabel.text = self.tweet.text;
    NSString *favCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    NSMutableAttributedString *attributedFav = [[NSMutableAttributedString alloc] initWithAttributedString:[ self.favButton attributedTitleForState:UIControlStateNormal]];
    [attributedFav replaceCharactersInRange:NSMakeRange(0, attributedFav.length) withString:favCount];
    [self.favButton setAttributedTitle:attributedFav forState:UIControlStateNormal];
    [self.cell.favButton setAttributedTitle:attributedFav forState:UIControlStateNormal];
    NSString *retweetCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    NSMutableAttributedString *attributedRetweet = [[NSMutableAttributedString alloc] initWithAttributedString:[ self.retweetButton attributedTitleForState:UIControlStateNormal]];
    [attributedRetweet replaceCharactersInRange:NSMakeRange(0, attributedRetweet.length) withString:retweetCount];
    [self.retweetButton setAttributedTitle:attributedRetweet forState:UIControlStateNormal];
    [self.cell.retweetButton setAttributedTitle:attributedRetweet forState:UIControlStateNormal];
    [self checkRetweets];
}

- (void)checkRetweets{
    int retweets = self.tweet.retweetCount;
    if(retweets == 1){
        self.retweetLabel.text = [NSString stringWithFormat:@"%d Retweet", retweets];
    } else {
        self.retweetLabel.text = [NSString stringWithFormat:@"%d Retweets", retweets];
    }
}

- (void)updateFav{
    UIImage *favIcon;
    if(self.tweet.favorited){
        favIcon = [UIImage imageNamed:@"favor-icon-red.png"];
    } else {
        favIcon = [UIImage imageNamed:@"favor-icon.png"];
    }
    [self.cell.favButton setImage:favIcon forState:UIControlStateNormal];
    [self.favButton setImage:favIcon forState:UIControlStateNormal];
    [self setTweetInfo];
}

- (void)updateRetweet{
    UIImage *retweetIcon;
    if(self.tweet.retweeted){
        retweetIcon = [UIImage imageNamed:@"retweet-icon-green.png"];
    } else {
        retweetIcon = [UIImage imageNamed:@"retweet-icon.png"];
    }
    [self.cell.retweetButton setImage:retweetIcon forState:UIControlStateNormal];
    [self.retweetButton setImage:retweetIcon forState:UIControlStateNormal];
    [self.delegate didRetweet:self.tweet];
    [self setTweetInfo];
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
    [self updateRetweet];
    [self setTweetInfo];
}

- (IBAction)favTapped:(id)sender {
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
    [self updateFav];
    [self setTweetInfo];
}

- (IBAction)replyTapped:(id)sender {
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
