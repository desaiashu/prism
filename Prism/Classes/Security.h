//
//  Security.h
//  Prism
//
//  Created by Ashutosh Desai on 9/4/13.
//  Copyright (c) 2013 makegameswithus inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Security : NSObject

#define PUBLIC_TAG @"com.ashudesai.prism.publickey"
#define PRIVATE_TAG @"com.ashudesai.prism.privatekey"

+ (void) generateKeyPair;
+ (void) addPeerPublicKey:(NSString*)peerName keyString:(NSString *)publicKeyString;

+ (NSString*) encryptRSA:(NSString*)plainTextString peer:(NSString*)peerName;
+ (NSString*) decryptRSA:(NSString*)cipherString;

@end
