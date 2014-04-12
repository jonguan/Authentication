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

@end

@implementation JGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self loadWebPage];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWebPage
{
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://localhost"]];
//    [self.webView loadRequest:urlRequest];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [connection start];
}

#pragma mark - NSURLConnection

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"NSURLConnection error %@", error);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
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
        
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"ssl1" ofType:@"der"];
        NSData *localCertData = [NSData dataWithContentsOfFile:cerPath];
        
        

        
        if ([remoteCertificateData isEqualToData:localCertData]) {
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

@end
