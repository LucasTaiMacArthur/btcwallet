//
//  CryptoOps.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/7/16.
//
//

#import "CryptoOps.h"
#import <Foundation/Foundation.h>
#include <stdio.h>
#include <string.h>


@implementation CryptoOps

+ (NSString*)signData:(NSString*)privBytes withAddress:(NSString*)tag {
    
    // create BTC Key with bytes privBytes
    // get the private key from the public key tag
    AddressManager *addrMan = [AddressManager globalManager];
    NSDictionary *tagToPrivDict = [addrMan getTagPrivateKeyMapping];
    NSDictionary *tagToHexPub = [addrMan getTagToHexEncodedPubKeyMap];

    NSString *privKey = [tagToPrivDict objectForKey:tag];
    NSData *privkeyAsBytes = [self hexEncodedStringToData:privKey];
    
    NSData *correctedPrivBytes = [self hexEncodedHashToData:privBytes];
    
    // this needs a char to hex conversion
    // each 2 chars should be interpreted as a byte
    
    #ifndef WINOBJC
    BTCKey *transactionPkey = [[BTCKey alloc]initWithPrivateKey:privkeyAsBytes];
    #endif

	NSData *signedHash;

	#ifndef WINOBJC
    signedHash = [transactionPkey signatureForHash:correctedPrivBytes];
    #endif
    // concat into a c string, then into a NSString
    
    NSString *signedHasAsString = [self dataToHexEncodedString:signedHash];
    
    printf("\nSigned Hash was %s\n",[signedHasAsString UTF8String]);
    
    return signedHasAsString;
}

+ (NSData*)hexEncodedHashToData:(NSString*)data{
    // priv key always size 32
    int len = [data length]/2.0;
    unsigned char byteArray[len];
    const char *hexEncodedData = [data UTF8String];
    char* tmpPtr = hexEncodedData;
    
    
    size_t i;
    
    // iterate over 32 bytes, sscanf 2 chars from byte array, process them
    for (i = 0 ; i < len; i++){
        // scan for 2 unsigned chars (hhx) and interpret them as a hex number
        sscanf(tmpPtr, "%2hhx",&byteArray[i]);
        // forward the string by 2 char
        tmpPtr = tmpPtr + 2;
    }
    printf("\nDONE\n");
    // test output
    for (int i = 0; i < len; i++){
        printf("%02x",byteArray[i]);
    }
    
    NSData *correctDat = [[NSData alloc]initWithBytes:byteArray length:len];
    
    
    return correctDat;
}


+ (NSData*)hexEncodedStringToData:(NSString*)test{
    // priv key always size 32
    unsigned char byteArray[32];
    const char *hexEncodedPkey = [test UTF8String];
    char* tmpPtr = hexEncodedPkey;

    
    size_t i;
    
    // iterate over 32 bytes, sscanf 2 chars from byte array, process them
    for (i = 0 ; i < 32; i++){
        // scan for 2 unsigned chars (hhx) and interpret them as a hex number
        sscanf(tmpPtr, "%2hhx",&byteArray[i]);
        // forward the string by 2 char
        tmpPtr = tmpPtr + 2;
    }
    
    // test output
    for (int i = 0; i < 32; i++){
        printf("%02x",byteArray[i]);
    }
    
    NSData *correctDat = [[NSData alloc]initWithBytes:byteArray length:32];
    
    
    return correctDat;
}

+ (NSString*)dataToHexEncodedString:(NSData*)test{
    
    NSUInteger len = [test length];
    NSMutableString *toRet = [[NSMutableString alloc]initWithCapacity:(len * 2)];
    
    const unsigned char *dataBytes = (const unsigned char*)[test bytes];
    
    for(int i = 0; i < len; i++){
        [toRet appendString:[NSString stringWithFormat:@"%02hhx",dataBytes[i]]];
    }
    
    NSLog(@"\n%@\n",toRet);
    
    
    return toRet;
    
}

@end
