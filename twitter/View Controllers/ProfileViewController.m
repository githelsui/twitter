//
//  ProfileViewController.m
//  twitter
//
//  Created by Githel Lynn Suico on 7/3/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) User *currentUser;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self fetchCurrentUser];
}

- (void) setHeader{
    NSURL *icon = [NSURL URLWithString:self.currentUser.profileImgURL];
    [self.iconView setImageWithURL:icon];
    self.iconView.layer.cornerRadius = 35;
    NSURL *header = [NSURL URLWithString:self.currentUser.headerURL];
    [self.headerView setImageWithURL:header];
    self.authorLabel.text = self.currentUser.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.currentUser.screenName];
    self.bioLabel.text = self.currentUser.bio;
    self.tweetLabel.text = [NSString stringWithFormat:@"%@ Tweets", self.currentUser.tweetCount];
    self.followersLabel.text = [NSString stringWithFormat:@"%@ Followers", self.currentUser.followerCount];
    self.followingLabel.text = [NSString stringWithFormat:@"%@ Following", self.currentUser.followingCount];
}

- (void) fetchCurrentUser{
    [[APIManager shared] getCurrentUser:(^ (User *user, NSError *error) {
        if (user) {
            self.currentUser = user;
            [self setHeader];
            [self fetchTweets];
        } else {
            NSLog(@"😫😫😫 Error getting current user: %@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Failure"
                                                                           message:@"Cannot Load Tweets"
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    })];
}

- (void) fetchTweets{
    [[APIManager shared] getUserTimeline:self.currentUser completion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            self.tweets = tweets;
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Failure"
                                                                           message:@"Cannot Load Tweets"
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    cell.tweet = tweet;
    cell.tweetLabel.text = tweet.text;
    cell.authorLabel.text = tweet.user.name;
    cell.usernameLabel.text =  [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    cell.dateLabel.text = tweet.createdAtString;
    NSURL *posterURL = [NSURL URLWithString:tweet.user.profileImgURL];
    [cell.profileView setImageWithURL:posterURL];
    cell.profileView.layer.cornerRadius = 31;
    NSString *favCount = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    NSMutableAttributedString *attributedFav = [[NSMutableAttributedString alloc] initWithAttributedString:[ cell.favButton attributedTitleForState:UIControlStateNormal]];
    [attributedFav replaceCharactersInRange:NSMakeRange(0, attributedFav.length) withString:favCount];
    [cell.favButton setAttributedTitle:attributedFav forState:UIControlStateNormal];
    NSString *retweets = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    NSMutableAttributedString *attributedRetweet = [[NSMutableAttributedString alloc] initWithAttributedString:[ cell.retweetButton attributedTitleForState:UIControlStateNormal]];
    [attributedRetweet replaceCharactersInRange:NSMakeRange(0, attributedRetweet.length) withString:retweets];
    [cell.retweetButton setAttributedTitle:attributedRetweet forState:UIControlStateNormal];
    [cell refreshFav];
    [cell refreshRetweet];
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = UIColor.whiteColor;
    cell.selectedBackgroundView = backgroundView;
    return cell;
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
