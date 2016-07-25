//
//  BitcoinTransaction.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/24/16.
//
//

#ifndef BitcoinTransaction_h
#define BitcoinTransaction_h

typedef enum BitcoinStatus{PENDING,REJECTED,ACCEPTED} BCTransactionStatus;

@interface BitcoinTransaction : NSObject

@property (strong,nonatomic) NSString *destination;
@property (strong,nonatomic) NSArray<NSString*>* originAddresses;
@property BCTransactionStatus transactionStatus;

@end


#endif /* BitcoinTransaction_h */
