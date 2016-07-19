//
//  AddressManager.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/18/16.
//
//

#ifndef AddressManager_h
#define AddressManager_h

@interface AddressManager : NSObject


+ (id)globalManager;
- (NSDictionary*)getKeyPairs;
- (void)createKeyPairsWithDummyData;
- (int)addKeyPair:(NSString*) toAdd;

@end

#endif /* AddressManager_h */
