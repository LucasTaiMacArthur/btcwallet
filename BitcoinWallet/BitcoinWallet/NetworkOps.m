//
//  NetworkOps.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/8/16.
//
//

#import <Foundation/Foundation.h>
#include "NetworkOps.h"

@implementation NetworkOps : NSObject 

+ (NSString *)getAddressBalance: (NSString *)address changeWithLabel:(UILabel *)label {
    
    NSString *urlString = [NSString stringWithFormat:@"https:/www.blockexplorer.com/api/addr/%@/balance",address];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    __block NSString *to_ret = [[NSString alloc] init];
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithURL:apiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data){
            to_ret = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSString *str = [NSString stringWithFormat:@"Address Balance: %@",to_ret];
            label.text = str;
            
            
            }
        }
    ];
    [tsk resume];
    
    
    
    return to_ret;
    
}

+ (NSData *)getAddressQRCode: (NSString *)address changeWithData:(UIImageView *)img  {
    
    NSString *apiCall = [NSString stringWithFormat:@"https://api.qrserver.com/v1/create-qr-code/?data=%@&size=200x200",address];
    NSURL *url = [NSURL URLWithString:apiCall];
    __block NSData *to_ret = [[NSData alloc] init];
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data){
            printf("Recieved image data back from qrserver\n");
            UIImage *toPut = [[UIImage alloc]initWithData:data];
            img.image = toPut;
        }
    }
                                 ];
    [tsk resume];
    
    
    
    return to_ret;
    
}

@end
