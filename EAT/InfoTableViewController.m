//
//  InfoTableViewController.m
//  EAT
//
//  Created by Lukas Kollmer on 16.02.14.
//  Copyright (c) 2014 Lukas Kollmer. All rights reserved.
//

#import "InfoTableViewController.h"

@interface InfoTableViewController ()

@end

@implementation InfoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLabels];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLabels {
    
    
    [_versionNameLabel setText:@"Version:"];
    [_versionNumberLabel setText:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    [_contactViaIMessageLabel setTextAlignment:NSTextAlignmentCenter];
    [_contactViaFaceTimeLabel setTextAlignment:NSTextAlignmentCenter];
    [_contactViaMailLabel setTextAlignment:NSTextAlignmentCenter];
    
    [_contactViaIMessageLabel setTextColor:[UIColor colorWithRed:(0) green:(122/255) blue:(1) alpha:(1.0)]];
    [_contactViaFaceTimeLabel setTextColor:[UIColor colorWithRed:(0) green:(122/255) blue:(1) alpha:(1.0)]];

    [_contactViaMailLabel setTextColor:[UIColor colorWithRed:(0) green:(122/255) blue:(1) alpha:(1.0)]];

    //NSSt *hi = @"hi";


    [_contactViaIMessageLabel setText:@"Contact via iMessage"];
    [_contactViaFaceTimeLabel setText:@"Contact via FaceTime"];
    [_contactViaMailLabel setText:@"Contact via Mail"];
    
}

# pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self contactViaIMessage];
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        [self contactViaFaceTime];
    }
    
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        [self contactViaMail];
    }
    
    
    NSLog(@"row %ld section %ld selected", (long)indexPath.row, (long)indexPath.section);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}



- (void)contactViaIMessage {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[@"lukas.kollmer@me.com"];
    NSString *message = [NSString stringWithFormat:@""];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)contactViaFaceTime {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"facetime://lukas.kollmer@me.com"]];
    
    
}




# pragma mark - E-Mail

- (void)contactViaMail {
    
    // Email Subject
    NSString *emailTitle = @"EAT. Support";
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"lukas.kollmer@me.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)cancelButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
