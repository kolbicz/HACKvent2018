//
//  ViewController.m
//  HACKvent-2018
//
//  Created by Christoph Kolbicz on 30.09.18.
//  Copyright © 2018 hacking-lab.com. All rights reserved.
//

#import "ViewController.h"
#import "NSData+AES.h"

@interface ViewController (){
    NSString *key;
    NSString *flag;
    NSString *dec;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 1080, 100)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    float viewWidth = self.view.frame.size.width;
    float viewHeight = self.view.frame.size.height;
    
    //flag = @"HV18-Nc7c-VdEh-pCek-Bw08-jpM3";
    
    flag = @"xQ34V+MHmhC8V88KyU66q0DE4QeOxAbp1EGy9tlpkLw=";
    
    [self decryptFlag];
    
    NSString *msg = [NSString stringWithFormat:@"%@\n\n%@", @"HACKvent 2018 - now on your Apple TV!", dec];
    label.text = msg;
    
    [label sizeToFit];
    
    float labelWidth = label.frame.size.width;
    float labelHeight = label.frame.size.height;
    
    float xpos = (viewWidth/2.0f) - (labelWidth/2.0f);
    float ypos = (viewHeight/2.0f) - (labelHeight/2.0f);
    
    [label setFrame:CGRectMake(xpos,ypos,labelWidth,labelHeight)];
    
    [self.view addSubview:label];

}

- (void)decryptFlag {
    
    NSData *cipherData;
    //char key = @"xTD_0qPC@4zo!eQ$";
    char cstring[] = "uQA\\-nM@=1wlbN!";
    
    for (int i=0; i<strlen(cstring); i++){
        cstring[i] += 3;
    }
    
    NSString* key = @(cstring);
    //NSLog(@"Key: %@", key);
    
 /*
    NSString *base64Text;
 
    cipherData = [[flag dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptedDataWithKey:key];
    
    NSLog(@"Encrypted: %@", cipherData);
    
    base64Text = [cipherData base64EncodedStringWithOptions:0];
    
    NSLog(@"Encrypted base64: %@", base64Text);
  

    flag  = [[NSString alloc] initWithData:[cipherData AES128DecryptedDataWithKey:key]
                                        encoding:NSUTF8StringEncoding];
    
    NSLog(@"Decrypted: %@", flag);
    
   */
    cipherData = [[NSData alloc] initWithBase64EncodedString:flag
                                                     options:0];
    
    dec  = [[NSString alloc] initWithData:[cipherData AES128DecryptedDataWithKey:key]
                                        encoding:NSUTF8StringEncoding];
    //NSLog(@"Decrypted base64: %@", dec);
}


@end
