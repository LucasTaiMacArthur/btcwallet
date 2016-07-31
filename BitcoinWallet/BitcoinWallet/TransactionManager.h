//
//  TransactionManager.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/25/16.
//
//

#ifndef TransactionManager_h
#define TransactionManager_h


@interface TransactionManager : NSObject

+ (id)globalManager;
- (void)createKeyPairsWithDummyData;
- (int)addTransHash:(NSString*)toAdd;
- (NSSet*)getTransactionHashes;

@end

#endif /* TransactionManager_h */
