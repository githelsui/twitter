//
//  ComposeViewController.m
//  twitter
//
//  Created by Githel Lynn Suico on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "Tweet.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) NSString *tweet;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpHandle];
}

- (void)setUpHandle{
    self.authorLabel.text = self.currentUser.name;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.currentUser.screenName];
    NSURL *posterURL = [NSURL URLWithString:self.currentUser.profileImgURL];
    [self.iconView setImageWithURL:posterURL];
}

- (void) postTweet{
    [[APIManager shared] postStatusWithText:self.tweet completion:^(Tweet *tweet, NSError *error){
        if(tweet){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tweet Successfully Posted"
                                                                           message:@""
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            [self.delegate didTweet:tweet];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Post Tweet"
                                                                           message:@"Network Error"
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (IBAction)closeTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)tweetTapped:(id)sender {
    NSString *text = self.tweetView.text;
    if([text length] != 0){
        self.tweet = text;
        [self postTweet];
        [self dismissViewControllerAnimated:true completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Post Tweet"
                                                                       message:@"Must be more than 0 characters."
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
