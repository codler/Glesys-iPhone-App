//
//  indieViewController.m
//  Glesys
//
//  Created by Han Lin Yap on 2012-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "indieViewController.h"

@implementation indieViewController
@synthesize info;
@synthesize instanceID;
@synthesize username;
@synthesize APIKey;

- (void) APIFetch {
    responseData = [NSMutableData new];
    
    NSString *baseURL = @"https://api.glesys.com";
    NSLog(@"%@", instanceID.text);
    NSString *param = [NSString stringWithFormat:@"/server/status/serverid/%@/format/json/", instanceID.text];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, param]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    //NSData *requestData = [@"name=testname&suggestion=testing123" dataUsingEncoding:NSUTF8StringEncoding];
    
    //[request setHTTPMethod:@"POST"];
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    //[request setHTTPBody: requestData];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (IBAction)refresh:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setValue:instanceID.text forKey:@"instanceID"];
    [defaults setValue:username.text forKey:@"username"];
    [defaults setValue:APIKey.text forKey:@"APIKey"];
    
    [defaults synchronize];
    
    [self APIFetch];
}

- (IBAction)keyboardEnd:(id)sender {
    [sender resignFirstResponder];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    instanceID.text = [defaults objectForKey:@"instanceID"];
    username.text = [defaults objectForKey:@"username"];
    APIKey.text = [defaults objectForKey:@"APIKey"];
    
    [self APIFetch];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        NSLog(@"received authentication challenge");
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:@""
                                                                    password:@""
                                                                 persistence:NSURLCredentialPersistenceForSession];
        NSLog(@"credential created");
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
        NSLog(@"responded to authentication challenge");    
    }
    else {
        NSLog(@"previous authentication failure");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
    NSLog(@"didreceiveresponse");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
    NSLog(@"didreceivedata");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Oh noes! %@", [error localizedDescription]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&myError];
    NSLog(@"%@", res);
    
    NSDictionary *json = [[res objectForKey:@"response"] objectForKey:@"server"];
    
    NSDictionary *cpu = [json objectForKey:@"cpu"];
    NSDictionary *memory = [json objectForKey:@"memory"];
    NSDictionary *disk = [json objectForKey:@"disk"];
    NSDictionary *transfer = [json objectForKey:@"transfer"];
    NSDictionary *uptime = [json objectForKey:@"uptime"];
    
    
    NSString *s = @"";
    s = [NSString stringWithFormat:@"%@ CPU: %@/%@ %@\n", s, [cpu objectForKey:@"usage"], [cpu objectForKey:@"max"], [cpu objectForKey:@"unit"]];
    s = [NSString stringWithFormat:@"%@ Memory: %@/%@ %@\n", s, [memory objectForKey:@"usage"], [memory objectForKey:@"max"], [memory objectForKey:@"unit"]];
    s = [NSString stringWithFormat:@"%@ Disk: %@/%@ %@\n", s, [disk objectForKey:@"usage"], [disk objectForKey:@"max"], [disk objectForKey:@"unit"]];
    s = [NSString stringWithFormat:@"%@ Bandwidth: %@/%@ %@\n", s, [transfer objectForKey:@"usage"], [transfer objectForKey:@"max"], [transfer objectForKey:@"unit"]];
    s = [NSString stringWithFormat:@"%@ Uptime: %@ %@\n", s, [uptime objectForKey:@"current"], [uptime objectForKey:@"unit"]];
    
    info.text = s;
 /*   
    info.text = [[[json objectForKey:@"cpu"] objectForKey:@"max"] stringValue];
    NSLog(@"%@", [[[json objectForKey:@"transfer"] objectForKey:@"unit"] class]);
    NSLog(@"%@", [[[[res objectForKey:@"response"] objectForKey:@"status"] objectForKey:@"timestamp"] class]);
    NSLog(@"%@", [[[json objectForKey:@"cpu"] objectForKey:@"unit"] class]);
    info.text = [[json objectForKey:@"cpu"] objectForKey:@"unit"];
*/
}
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}*/

- (void)viewDidUnload {
    [self setInstanceID:nil];
    [self setUsername:nil];
    [self setAPIKey:nil];
    [super viewDidUnload];
}
@end
