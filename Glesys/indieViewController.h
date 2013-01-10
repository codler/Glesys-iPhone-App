//
//  indieViewController.h
//  Glesys
//
//  Created by Han Lin Yap on 2012-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface indieViewController : UIViewController <UITextFieldDelegate> {
    NSMutableData* responseData;
    CGPoint svos;
}

@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UITextField *instanceID;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *APIKey;

- (IBAction)refresh:(id)sender;
//- (void) APIFetch;
- (IBAction)keyboardEnd:(id)sender;

@end
