//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "LoginViewController.h"
#import "Tweet.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

@interface TimelineViewController ()  <ComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self fetchTweets];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) fetchTweets{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSMutableArray *tweets, NSError *error) {
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
        [self.refreshControl endRefreshing];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    cell.delegate = self;
    cell.tweet = tweet;
    cell.tweetLabel.text = tweet.text;
    cell.authorLabel.text = tweet.user.screenName;
    cell.usernameLabel.text = tweet.user.name;
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

- (void)didTweet:(Tweet *)tweet{
    [self.tweets addObject:tweet];
    [self fetchTweets];
    [self.tableView reloadData];
}

- (void)didRetweet:(Tweet *)tweet{
    [self.tweets addObject:tweet];
    [self fetchTweets];
    [self.tableView reloadData];
}

- (void)didFavorite:(Tweet *)tweet{
    [self fetchTweets];
    [self.tableView reloadData];
}

- (IBAction)logoutTapped:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ComposeSegue"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"DetailSegue"]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweets[indexPath.row];
        NSLog(@"tweet being passes %@", tweet);
        DetailViewController *detailController = [segue destinationViewController];
        detailController.tweet = tweet;
        detailController.delegate = self;
    }
}


@end
