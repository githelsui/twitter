//
//  ReplyViewController.m
//  twitter
//
//  Created by Githel Lynn Suico on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ReplyViewController.h"
#import "Tweet.h"
#import "User.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface ReplyViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *replyingTo;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *countLabel;
@property (nonatomic, strong) NSString *reply;
@end

@implementation ReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpHandle];
    self.tweetView.delegate = self;
    // Do any additional setup after loading the view.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int characterLimit = 140;
    NSString *newText = [self.tweetView.text stringByReplacingCharactersInRange:range withString:text];
    self.countLabel.title = [NSString stringWithFormat:@"%lu", (unsigned long)newText.length];
    return newText.length < characterLimit;
}

- (void)setUpHandle{
    NSString *userToReplyTo = self.tweet.user.screenName;
    self.replyingTo.text = [NSString stringWithFormat:@"Replying to @%@", userToReplyTo];
    self.authorLabel.text = self.currentUser.name;
    NSURL *posterURL = [NSURL URLWithString:self.currentUser.profileImgURL];
    [self.iconView setImageWithURL:posterURL];
}

- (void) tweetReply{
    [[APIManager shared]reply:self.reply replyId:self.tweet.idStr completion:^(Tweet *tweet, NSError *error){
        if(tweet){
            [self.delegate didReply:tweet];
        }
    }];
}

- (IBAction)closeTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)tweetTapped:(id)sender {
    NSString *text = self.tweetView.text;
    if([text length] != 0){
        self.reply = text;
        [self tweetReply];
        [self dismissViewControllerAnimated:true completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Post Reply"
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
