//
//  MentionViewController.m
//  twitter
//
//  Created by Githel Lynn Suico on 7/3/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "MentionViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"

@interface MentionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tweets;
@end

@implementation MentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self fetchMentions];
}

- (void)fetchMentions{
    [[APIManager shared] getMentions:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded mentions timeline");
            self.tweets = tweets;
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
        } else {
            NSLog(@"😫😫😫 Error getting mentions timeline: %@", error.localizedDescription);
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
