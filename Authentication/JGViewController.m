//
//  JGViewController.m
//  Authentication
//
//  Created by Jon Guan on 4/11/14.
//  Copyright (c) 2014 Scanadu, Inc. All rights reserved.
//

#import "JGViewController.h"

#define SAVE_CERT   NO

@interface JGViewController ()

@property (nonatomic, assign) BOOL useFirstCert;

@end

@implementation JGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWebPage
{
    [self logText:@"Starting ssl connection..."];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://localhost"]];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [connection start];
}

#pragma mark - UI Methods
- (IBAction)didClickButton:(UIButton *)sender
{
    
    self.useFirstCert = (sender == self.certOneButton);
    
    [self loadWebPage];
}

#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self logText:error.localizedDescription];
    
    NSLog(@"NSURLConnection error %@", error);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self logText:response.description];
    NSLog(@"response is %@", response);
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {

    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString: NSURLAuthenticationMethodServerTrust]) {

        SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
        SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
        NSData *remoteCertificateData = CFBridgingRelease(SecCertificateCopyData(certificate));
        
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:[self certificateName] ofType:@"der"];
        NSData *localCertData = [NSData dataWithContentsOfFile:cerPath];
        
        

        
        if ([remoteCertificateData isEqualToData:localCertData]) {
            [self logText:@"Certificate is the same; accepting credentials..."];
            NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        }
        else {
            if (SAVE_CERT) {
                // Write remote to file to diff
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"remotecert.crt"];
                [remoteCertificateData writeToFile:appFile atomically:YES];
            }
            
            [[challenge sender] cancelAuthenticationChallenge:challenge];
        }
    }
}

- (NSString *)certificateName
{
    return (self.useFirstCert) ? @"ssl" : @"ssl1";
}

#pragma mark - Utility methods
- (void)logText:(NSString *)text
{
    if (text == nil) {
        return;
    }
    NSMutableString *textViewText = [self.textView.text mutableCopy];
    [textViewText appendFormat:@"%@\n", text];
    self.textView.text = textViewText;

    // Scroll textview to latest text
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
}
@end
