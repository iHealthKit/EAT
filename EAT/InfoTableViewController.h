//
//  InfoTableViewController.h
//  EAT
//
//  Created by Lukas Kollmer on 16.02.14.
//  Copyright (c) 2014 Lukas Kollmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface InfoTableViewController : UITableViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *versionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionNumberLabel;
- (IBAction)cancelButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *contactViaIMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactViaFaceTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactViaMailLabel;
@end
