//
//  AddressModel.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/27/16.
//
//

#ifndef AddressModel_h
#define AddressModel_h

@interface AddressModel : NSObject
@property (strong,nonatomic) NSString* privateKey;
@property (strong,nonatomic) NSString* publicKey;
@property (strong,nonatomic) NSString* encodedAddress;
@end

#endif /* AddressModel_h */
