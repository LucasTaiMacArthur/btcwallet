//
//  ViewController.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/5/16.
//
//

#import <UIKit/UIKit.h>

#ifndef WINOBJC
#include <openssl/md5.h>
#import <openssl/sha.h>
#endif

#include "CryptoOps.h"
#include "NetworkOps.h"
#include "MainViewController.h"
#include "PasswordManager.h"

@interface ViewController : UIViewController


@end

