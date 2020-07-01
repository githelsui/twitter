//
//  DetailViewController.m
//  twitter
//
//  Created by Githel Lynn Suico on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

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
    [self setTweetInfo];
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
    [self checkRetweets];
    
}

- (void)checkRetweets{
    int retweets = self.tweet.retweetCount;
    if(retweets == 1){
        self.retweetLabel.text = [NSString stringWithFormat:@"%d Retweet", retweets];
    } else {
        self.retweetLabel.text = [NSString stringWithFormat:@"%d Retweets", retweets];;
    }
}

- (void)updateFav{
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

- (void)updateRetweet{
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

- (IBAction)retweetTapped:(id)sender {
    
}

- (IBAction)favTapped:(id)sender {
    
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
