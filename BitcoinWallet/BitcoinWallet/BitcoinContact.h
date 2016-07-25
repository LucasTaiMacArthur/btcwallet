//
//  BitcoinContact.h
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/23/16.
//
//

#ifndef BitcoinContact_h
#define BitcoinContact_h

@interface BitcoinContact : NSObject

@property (strong,nonatomic) NSString* name;
@property Boolean isFavorite;
@property (strong,nonatomic) NSString* qrURL;
@property (strong,nonatomic) NSString* profilePicURL;


@end


#endif /* BitcoinContact_h */
