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
- (int)createContactDirectory;
- (int)contactDirectoryExists;
+ (id)globalManager;
- (NSString*)createIndividualContact:(NSString*)name;
- (int)addContact:(NSString*)name;
- (NSDictionary*)getAllContactNames;
@end


#endif /* ContactManager_h */
