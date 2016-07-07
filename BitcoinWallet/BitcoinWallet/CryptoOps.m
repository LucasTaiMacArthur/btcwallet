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

+ (void)generateKeyPair {
    
    
    EC_KEY *bitcoinKP = EC_KEY_new_by_curve_name(NID_secp256k1);
    if (EC_KEY_generate_key(bitcoinKP)){
        printf("Succesffully generated keypair \n");
    }else{
        printf("keypair gen unsuccessful\n");
    }
    
    if (EC_KEY_check_key(bitcoinKP)){
        printf("generated keypair is valid \n");
    }else{
        printf("generated keypair is invalid \n");
    }
    
    EC_KEY_print_fp(stdout, bitcoinKP, 0);
    
    
    
    
    
    
    
}



@end
