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
- (NSDictionary*)getKeyTagMapping;
- (void)createKeyPairsWithDummyData;
- (int)addKeyPair:(NSString*) toAdd withTag:(NSString*)keypairTagName;
- (NSDictionary*)getTagPrivateKeyMapping;
- (NSDictionary*)getTagToHexEncodedPubKeyMap;

@end

#endif /* AddressManager_h */
