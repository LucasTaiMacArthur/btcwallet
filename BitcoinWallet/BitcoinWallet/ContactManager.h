//
//  ContactManager.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/22/16.
//
//

#ifndef ContactManager_h
#define ContactManager_h

@interface ContactManager : NSObject
+ (id)globalManager;
- (int)addKeyPair:(NSString*)toAdd;
- (NSDictionary*)getKeyPairs;
@end


#endif /* ContactManager_h */
