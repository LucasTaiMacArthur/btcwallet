//
//  ContactManager.m
//  BitcoinWallet
//
//  Created by Lucas Tai-MacArthur on 7/22/16.
//
//

#import <Foundation/Foundation.h>
#import "ContactManager.h"

@implementation ContactManager

static ContactManager *globalManager = nil;

+ (id)globalManager {
    if (globalManager == nil){
        globalManager = [[ContactManager alloc] init];
        return globalManager;
    }
    return globalManager;
}

- (void)createKeyPairsWithDummyData {
    NSString *line1 = [[NSString alloc]initWithFormat:@"John Smith,1JdJQftq3kQRTBVBMRJ4dcZe5yBJCuz6MR\n"];
    NSString *line2 = [[NSString alloc]initWithFormat:@"Jane Doe,1wuyDWpAzcz84XBWB5WLzHtHxnHb5Kqwo\n"];
    [self addKeyPair:line1];
    [self addKeyPair:line2];
}

// wrap the contacts file path
+ (NSString*)getContactDirectoryFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docurl = [paths objectAtIndex:0];
    NSString *fileurl = [[docurl stringByAppendingString:@"/contacts/"] retain];
    return fileurl;
}

- (int)addKeyPair:(NSString*)toAdd {
    NSString *fileurl = [ContactManager getContactFilePath];
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSData *dat1 = [fileman contentsAtPath:fileurl];
    NSData *toWrite = [NSData dataWithBytes:[toAdd UTF8String] length:[toAdd length]];
    NSMutableData *concatData = [NSMutableData dataWithData:dat1];
    [concatData appendData:toWrite];
    
    // remove file if it exists
    if ([fileman fileExistsAtPath:fileurl]) {
        printf("I've removed the file?\n");
        [fileman removeItemAtPath:fileurl error:nil];
    }
    
    // write new file with full data
    BOOL filecreat = [fileman createFileAtPath:fileurl contents:concatData attributes:nil];
    if (filecreat) {
        printf("Success - file written\n");
    }else {
        printf("Failure! - file not written\n");
    }
    
    return 1;
}

// create a password file at documents/contacts.txt
- (int)createContactDirectory {
    NSString *dirFilePath = [ContactManager getContactDirectoryFilePath];
    NSFileManager *fileman = [NSFileManager defaultManager];
    BOOL dirCreated = [fileman createDirectoryAtPath:dirFilePath withIntermediateDirectories:NO attributes:nil error:nil];
    if (dirCreated) {
        return 1;
    }else {
        return 0;
    }
}


- (int)contactDirectoryExists {
    NSString *dirFilePath = [ContactManager getContactDirectoryFilePath];
    NSFileManager *fileman = [NSFileManager defaultManager];
    return [fileman fileExistsAtPath:dirFilePath];
}

// take name (might have spaces), replace non ascii characters with percent
// in the name. returns that filepath or nil if it failed
- (NSString*)createIndividualContact:(NSString*)name{
    NSString *dirFilePath = [ContactManager getContactDirectoryFilePath];
     NSString *formattedContact = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    NSString *contactSelector = [NSString stringWithFormat:@"%@/",formattedContact];
    NSString *fileurl = [[dirFilePath stringByAppendingString:contactSelector] retain];
    printf("Individual contact was %s\n",[fileurl UTF8String]);

    // take formatted string and make a directory out of it
    NSFileManager *fileman = [NSFileManager defaultManager];
    BOOL dirCreated = [fileman createDirectoryAtPath:fileurl withIntermediateDirectories:NO attributes:nil error:nil];
    if (dirCreated) {
        return fileurl;
    }else {
        return nil;
    }

}

// create a password file at documents/contacts/NAME/contact.txt
- (int)createContactFileAtPath:(NSString*)path withName:(NSString*)name{
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSString *contactDefaultInfoPath = [path stringByAppendingString:@"contact.txt"];
    
    // marshall data to be added to the path
    NSString *fileContents = [NSString stringWithFormat:@"%@,false\n",name];
    NSData *fileContentsData = [[fileContents dataUsingEncoding:NSUTF8StringEncoding] retain];
    
    BOOL fileCreated = [fileman createFileAtPath:contactDefaultInfoPath contents:fileContentsData attributes:nil];
    if (fileCreated){
        return 1;
    }else {
        return 0;
    }
}

- (int)addContact:(NSString*)name {
    // create the contact
    
    NSString *filePath = [self createIndividualContact:name];
    if (filePath == nil){
        return 0;
    }else {
        int createdResult = [self createContactFileAtPath:filePath withName:name];
        if(createdResult){
            return 1;
        }else{
            return 0;
        }
    }
    
}

- (NSMutableDictionary*)getAllContactNames {
    NSFileManager *fileman = [NSFileManager defaultManager];
    NSString *contactDir = [ContactManager getContactDirectoryFilePath];
    NSArray *contents = [fileman contentsOfDirectoryAtPath:contactDir error:nil];
    printf("There are %lu contacts in the docs directory\n",(unsigned long)[contents count]);
    NSMutableDictionary *returnDict = [[[NSMutableDictionary alloc]init] retain];
    
    // for each contact directory, get contents of file /directory/contacts.txt
    NSString *contactsFile = @"/contact.txt";
    for (NSString *s in contents){
        // create specific path to the file for the contact dir
        printf("STR: %s\n",[s UTF8String]);
        NSString *toAddToGenericPath = [s stringByAppendingString:contactsFile];
        NSString *specificFullPathForContact = [contactDir stringByAppendingString:toAddToGenericPath];
        printf("FULL PATH WAS %s\n",[specificFullPathForContact UTF8String]);
        
        //get the contents of the file
        NSData *contactData = [fileman contentsAtPath:specificFullPathForContact];
        NSString *csvString = [[NSString alloc]initWithData:contactData encoding:NSUTF8StringEncoding];
        printf("%s\n",[csvString UTF8String]);
        
        //split the contents
        NSCharacterSet *splitSet = [NSCharacterSet characterSetWithCharactersInString:@"\n,"];
        NSArray *splitString = [[NSArray alloc] init];
        splitString = [csvString componentsSeparatedByCharactersInSet:splitSet];
        printf("Array Size is %lu",(unsigned long)[splitString count]);
        
        // split kv pairs for dict from line
        for(int i=0; i < [splitString count] - 1; i = i + 2) {
            NSString *name = [splitString objectAtIndex:i];
            id isFavorite = [splitString objectAtIndex:(i+1)];
            [returnDict setValue:isFavorite forKey:name];

        }

        
    }
    
    return returnDict;

}


@end
