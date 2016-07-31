//
//  APINetworkOps.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/27/16.
//
//

#import <Foundation/Foundation.h>
#import "APINetworkOps.h"

@implementation APINetworkOps : NSObject

static NSString* apiAccessToken = @"e3301fb09644454b9609fc6634fb0fe8";

+ (void)generateAddressAndAddToAddressManagerWithTag:(NSString*)tag {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.blockcypher.com/v1/btc/test3/addrs"];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:apiURL];
    [request setHTTPMethod:@"POST"];
    
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        printf("data returned");
        NSString *stringreturned = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        printf("\ndata was %s\n",[stringreturned UTF8String]);
        
        NSDictionary *jsonData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:nil error:nil];
        for (NSString* key in [jsonData allKeys]){
            printf("Key was : %s\n",[key UTF8String]);
        }
        
        NSString *privateKey = [jsonData objectForKey:@"private"];
        NSString *publicKey = [jsonData objectForKey:@"public"];
        NSString *address = [jsonData objectForKey:@"address"];
        
        NSString *finalTag = [NSString stringWithFormat:@"%@-",tag];
        NSString *finalData = [NSString stringWithFormat:@"%@,%@,%@\n",privateKey,address,publicKey];

        
        printf("final string was %s%s\n",[finalTag UTF8String],[finalData UTF8String]);
        
        AddressManager *addrMan = [AddressManager globalManager];
        [addrMan addKeyPair:finalData withTag:finalTag];

        
    }];
                                 
    [tsk resume];
    
}

+ (NSString*)getTXSkeletonWithData:(NSData*)jsonSkeleton {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.blockcypher.com/v1/btc/test3/txs/new"];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:apiURL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonSkeleton];
    __block NSString* retVal = nil;
    
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        printf("data returned\n");
        NSError *err;
        NSDictionary *jsonData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:nil error:&err];
        if (err){
            printf("error\n");
        } else {
            NSData *translatedData = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:nil];
            retVal = [[[NSString alloc] initWithData:translatedData encoding:NSUTF8StringEncoding] retain];
            printf("STR FOLLOWS \n%s\n",[retVal UTF8String]);
        }
        
        
    }];
    
    [tsk resume];
    
    while (retVal == nil) {}
    
    return retVal;
    
}

+ (NSData*)generatePartialTXWithInput:(NSString*)input andOutput:(NSString*)output andValue:(NSNumber*)val; {
    NSMutableDictionary *rootObj = [[NSMutableDictionary alloc]init];

    // each endpoint is a dict
    
    NSMutableDictionary *inTX = [[NSMutableDictionary alloc]init];
    NSArray *originAddresses = @[input];
    [inTX setValue:originAddresses forKey:@"addresses"];
    
    NSMutableDictionary *outTX = [[NSMutableDictionary alloc]init];
    NSArray *destAddresses = @[output];
    [outTX setValue:destAddresses forKey:@"addresses"];
    [outTX setValue:val forKey:@"value"];
    
    // inputs and outputs are in the root of the object, they are arrays
    
    
    
    // assemble root objects
    [rootObj setObject:@[inTX] forKey:@"inputs"];
    [rootObj setObject:@[outTX] forKey:@"outputs"];
    
    // check json validity
    if([NSJSONSerialization isValidJSONObject:rootObj]){
        printf("Valid JSON Object\n");
        // create json object
        NSData *dictJSON = [NSJSONSerialization dataWithJSONObject:rootObj options:0 error:nil];
        NSString *jsonStr = [[NSString alloc]initWithData:dictJSON encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonStr);
        return dictJSON;
    }else {
        return nil;
    }

    
    
}

+ (NSString*)sendCompletedTransaction:(NSData*)transactionData forAddress:(NSString*)addressName {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.blockcypher.com/v1/btc/test3/txs/send?token=%@",apiAccessToken];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:apiURL];
    
    // string from data
    NSString *toPrint = [[NSString alloc]initWithData:transactionData encoding:NSUTF8StringEncoding];
    printf("RAW WHAT COMES INTO FUNC FOLLOWS \n %s \n ENDS HERE",[toPrint UTF8String]);
    // get address information
    AddressManager *addrMan = [AddressManager globalManager];
    NSDictionary *nameToPubKey = [addrMan getTagToHexEncodedPubKeyMap];
    NSString *hexPubKey = [nameToPubKey objectForKey:addressName];
    NSArray *pubkeyArray = @[hexPubKey];
    printf("The public key for %s is %s\n",[addressName UTF8String],[hexPubKey UTF8String]);
    
    NSMutableArray *orderedSignedHashes = [[NSMutableArray alloc] init];
    
    
    
    // get dict from json
    NSMutableDictionary *partialTX = (NSMutableDictionary*)[NSJSONSerialization JSONObjectWithData:transactionData options:NSJSONReadingMutableContainers error:nil];
    NSArray *toSignArr = [partialTX objectForKey:@"tosign"];
    for (NSString *unsignedHash in toSignArr) {
        NSString *signedHash = [CryptoOps signData:unsignedHash withAddress:addressName];
        printf("The hash signed was %s\n",[signedHash UTF8String]);
        [orderedSignedHashes addObject:signedHash];
        
    }
    
    // add the signed hashes and the pubkeys
    [partialTX setObject:orderedSignedHashes forKey:@"signatures"];
    [partialTX setObject:pubkeyArray forKey:@"pubkeys"];
    
    NSData *finalTX = [NSJSONSerialization dataWithJSONObject:partialTX options:0 error:nil];
    
    NSString *finalTXStr = [[NSString alloc]initWithData:finalTX encoding:NSUTF8StringEncoding];
    printf("RAW WHAT GOES OUT FUNC FOLLOWS \n %s \n ENDS HERE",[finalTXStr UTF8String]);

    
    
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:finalTX];
    __block NSString* retVal = nil;
    
    
    // do data signing, marshall pubkeys
    
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        printf("data returned");
        NSString *stringreturned = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        printf("\ndata was %s\n",[stringreturned UTF8String]);
        
        
        
        
    }];
    
    [tsk resume];
    
    return retVal;
    
}

+ (NSString*)getTXHashInfo:(NSString*)hash {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.blockcypher.com/v1/btc/test3/txs/%@",hash];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:apiURL];
    [request setHTTPMethod:@"GET"];
    __block NSDictionary* retVal = nil;
    
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        printf("data returned\n");
        NSError *err;
        NSDictionary *jsonData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:nil error:&err];
        if (err){
            printf("error\n");
        } else {
            retVal = jsonData;
        }
        
        
    }];
    
    [tsk resume];
    
    while (retVal == nil) {}
    
    return retVal;
    
}

+ (NSString*)scanTXFor:(NSString*)hash {
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.blockcypher.com/v1/btc/test3/txs/%@",hash];
    NSURL *apiURL =  [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:apiURL];
    [request setHTTPMethod:@"GET"];
    __block NSDictionary* retVal = nil;
    
    
    NSURLSessionDataTask *tsk = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        printf("data returned\n");
        NSError *err;
        NSDictionary *jsonData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:nil error:&err];
        if (err){
            printf("error\n");
        } else {
            retVal = jsonData;
        }
        
        
    }];
    
    [tsk resume];
    
    while (retVal == nil) {}
    
    return retVal;
    
}






@end
