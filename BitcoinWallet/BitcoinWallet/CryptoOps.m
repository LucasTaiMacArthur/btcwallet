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

+ (NSString*)generateKeyPair {
    
    // generate keypair based on bitcoin curve
    EC_KEY *bitcoinKP = EC_KEY_new_by_curve_name(NID_secp256k1);
    if (EC_KEY_generate_key(bitcoinKP)){
        printf("Succesffully generated keypair \n");
    }else{
        printf("keypair gen unsuccessful\n");
    }
    // check keypair validity
    if (EC_KEY_check_key(bitcoinKP)){
        printf("generated keypair is valid \n");
    }else{
        printf("generated keypair is invalid \n");
    }
    
    // print to check
    EC_KEY_print_fp(stdout, bitcoinKP,0);
    
    // get public key in hex (i2o_ECPublicKey moves the provided pointer)
    uint8_t pub_bufsize = i2o_ECPublicKey(bitcoinKP,NULL);
    uint8_t *ptr_pub = malloc(pub_bufsize);
    uint8_t *ptr_pub_cpy = ptr_pub;
    int res = i2o_ECPublicKey(bitcoinKP,&ptr_pub_cpy);
    printf("HEX ENCODED PUBKEY FOLLOWS\n");
    for (int x = 0; x < pub_bufsize; x++) {
        printf("%.2x",ptr_pub[x]);
    }
    printf("\nHEX ENCODED PUBKEY ENDS\n");
    // get private key in hex (provided pointer also moved)
    uint8_t priv_buffsize = i2d_ECPrivateKey(bitcoinKP,NULL);
    uint8_t *ptr_priv = malloc(priv_buffsize);
    uint8_t *ptr_priv_cpy = ptr_priv;
    int result = i2d_ECPrivateKey(bitcoinKP,&ptr_priv_cpy);
    printf("HEX ENCODED PRIVKEY FOLLOWS\n");
    for (int x = 0; x < priv_buffsize; x++) {
        printf("%.2x",ptr_priv[x]);
    }
    printf("\nHEX ENCODED PRIVKEY ENDS\n");
    
    //hash the public key with sha256
    
    uint8_t *shaHash1 = malloc(SHA256_DIGEST_LENGTH);
    SHA256(ptr_pub, pub_bufsize, shaHash1);
    printf("HEX ENCODED SHA256 HASH FOLLOWS\n");
    for (int x = 0; x < SHA256_DIGEST_LENGTH; x++) {
        printf("%.2x",shaHash1[x]);
    }
    printf("\nHEX ENCODED SHA256 HASH ENDS\n");

    // hash the key with ripemd
    
    uint8_t *ripemdhash = malloc(RIPEMD160_DIGEST_LENGTH);
    RIPEMD160(shaHash1, 64, ripemdhash);
    printf("HEX ENCODED RIPEMD160 HASH FOLLOWS\n");
    for (int x = 0; x < RIPEMD160_DIGEST_LENGTH; x++) {
        printf("%.2x",ripemdhash[x]);
    }
    printf("\nHEX ENCODED RIPEMD160 HASH ENDS\n");
    
    printf("HEX ENCODED EXTENDED RIPEMD160 HASH FOLLOWS\n");

    // add 0x00 to the front of the hash
    uint8_t *extendedripemd = malloc(RIPEMD160_DIGEST_LENGTH + 1);
    extendedripemd[0] = 0x00;
    for (int x = 0; x < RIPEMD160_DIGEST_LENGTH; x++) {
        extendedripemd[x+1] = ripemdhash[x];
    }
    
    for (int x = 0; x < RIPEMD160_DIGEST_LENGTH + 1; x++) {
        printf("%.2x",extendedripemd[x]);
    }
    printf("\nHEX ENCODED EXTENDED RIPEMD160 HASH ENDS\n");

    
    // hash with sha256 again
    
    uint8_t *shaHash2 = malloc(SHA256_DIGEST_LENGTH);
    SHA256(extendedripemd, 21, shaHash2);
    printf("HEX ENCODED SHA256 HASH FOLLOWS\n");
    for (int x = 0; x < SHA256_DIGEST_LENGTH; x++) {
        printf("%.2x",shaHash2[x]);
    }
    printf("\nHEX ENCODED SHA256 HASH ENDS\n");
    
    // hash with sha256 again
    
    uint8_t *shaHash3 = malloc(SHA256_DIGEST_LENGTH);
    SHA256(shaHash2, SHA256_DIGEST_LENGTH, shaHash3);
    printf("HEX ENCODED SHA256 HASH FOLLOWS\n");
    for (int x = 0; x < SHA256_DIGEST_LENGTH; x++) {
        printf("%.2x",shaHash3[x]);
    }
    printf("\nHEX ENCODED SHA256 HASH ENDS\n");
    
    // get the checksum (first 4 bits of 3rd sha256 hash)
    uint8_t msb = shaHash3[0];
    uint8_t b2 = shaHash3[1];
    uint8_t b1 = shaHash3[2];
    uint8_t lsb = shaHash3[3];
    
    // put at the end of extended ripemd160 hash for binary bitcoin adrress
    
    uint8_t *binaryBCAddr = malloc(RIPEMD160_DIGEST_LENGTH + 5);
    for (int x = 0; x < RIPEMD160_DIGEST_LENGTH + 1; x++) {
        binaryBCAddr[x] = extendedripemd[x];
    }
    binaryBCAddr[RIPEMD160_DIGEST_LENGTH + 1] = msb;
    binaryBCAddr[RIPEMD160_DIGEST_LENGTH + 2] = b2;
    binaryBCAddr[RIPEMD160_DIGEST_LENGTH + 3] = b1;
    binaryBCAddr[RIPEMD160_DIGEST_LENGTH + 4] = lsb;
    
    printf("HEX ENCODED BC BINARY ADDR FOLLOWS\n");
    for (int x = 0; x < RIPEMD160_DIGEST_LENGTH + 5; x++) {
        printf("%.2x",binaryBCAddr[x]);
    }
    printf("\nHEX ENCODED BC BINARY ADDR ENDS\n");

    
    b58_sha256_impl = my_sha256;
    size_t sz = RIPEMD160_DIGEST_LENGTH + 5;
    char *base58 = malloc(1000);
    size_t final;
    const void* dat = binaryBCAddr;
    uint8_t ver = 0x00;
    
    if(b58enc(base58, &final, dat, sz)) {
        printf("BTC ADDR: %s\n",base58);
    }
    
    const char* finalb58 = base58;
    
    return [NSString stringWithUTF8String:finalb58];


    
}

bool my_sha256(void *digest, const void *data, size_t datasz){
    
    SHA256(digest, datasz, data);
    
    
    return 1;
}


@end
