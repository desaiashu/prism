//
//  Security.m
//  Prism
//
//  Created by Ashutosh Desai on 9/4/13.
//  Copyright (c) 2013 makegameswithus inc. All rights reserved.
//

#import "Security.h"
#import "NSData+Base64.h"

@implementation Security

static SecKeyRef publicKey = NULL;
static SecKeyRef privateKey = NULL;
static CFMutableDictionaryRef dict = NULL;

+(void)generateKeyPair
{
	dict = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	
	NSData *publicTag = [PUBLIC_TAG dataUsingEncoding:NSUTF8StringEncoding];
	NSData *privateTag = [PRIVATE_TAG dataUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableDictionary *queryPrivateKey = [[NSMutableDictionary alloc] init];
		
	[queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
	[queryPrivateKey setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
	[queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[queryPrivateKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
	
	OSStatus err1 = SecItemCopyMatching((__bridge CFDictionaryRef)queryPrivateKey, (CFTypeRef *)&privateKey);
	
	if (err1 == errSecSuccess)
	{
		//In for testing
		NSMutableDictionary *queryPublicKey = [[NSMutableDictionary alloc] init];
		
		[queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
		[queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
		[queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
		[queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
		
		OSStatus err2 = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKey);
		//In for testing
	}
	else
	{
		NSMutableDictionary *privateKeyAttr = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *publicKeyAttr = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *keyPairAttr = [[NSMutableDictionary alloc] init];
		
		//		SecKeyRef publicKey = NULL;
		
		[keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA
						forKey:(__bridge id)kSecAttrKeyType];
		[keyPairAttr setObject:[NSNumber numberWithInt:2048]
						forKey:(__bridge id)kSecAttrKeySizeInBits];
		
		
		[privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
		[privateKeyAttr setObject:privateTag forKey:(__bridge id)kSecAttrApplicationTag];
		
		[publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
		[publicKeyAttr setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
		
		[keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
		[keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
		
		OSStatus err3 = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKey, &privateKey);
		
//		if(publicKey) CFRelease(publicKey);
//		if(privateKey) CFRelease(privateKey);
	}
	
	if (![[NSUserDefaults standardUserDefaults] objectForKey:PUBLIC_TAG])
	{
		NSData * publicKeyData = nil;
		
		NSMutableDictionary * queryPublicKey = [[NSMutableDictionary alloc] init];
		
		[queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
		[queryPublicKey setObject:publicTag forKey:(__bridge id)kSecAttrApplicationTag];
		[queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
		[queryPublicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnData];
		
		CFDataRef publicKeyDataRef;
		OSStatus err4 = SecItemCopyMatching((__bridge CFDictionaryRef)queryPublicKey, (CFTypeRef *)&publicKeyDataRef);
		publicKeyData = (__bridge_transfer NSData*)publicKeyDataRef;
		
		NSString *publicKeyString = [publicKeyData base64EncodedString];
		[[NSUserDefaults standardUserDefaults] setObject:publicKeyString forKey:PUBLIC_TAG];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

+ (NSString*) encryptRSA:(NSString*)plainTextString peer:(NSString*)peerName
{
	if (peerName)
		return [Security encryptRSA:plainTextString key:[Security getPeerPublicKey:peerName]];
	return [Security encryptRSA:plainTextString key:publicKey];
}

+(NSString *)encryptRSA:(NSString *)plainTextString key:(SecKeyRef)publicKey
{
	size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
	uint8_t *cipherBuffer = malloc(cipherBufferSize);
	uint8_t *nonce = (uint8_t *)[plainTextString UTF8String];
	SecKeyEncrypt(publicKey,
				  kSecPaddingOAEP,
				  nonce,
				  strlen( (char*)nonce ),
				  &cipherBuffer[0],
				  &cipherBufferSize);
	NSData *encryptedData = [NSData dataWithBytes:cipherBuffer length:cipherBufferSize];
	return [encryptedData base64EncodedString];
}

+(NSString *)decryptRSA:(NSString *)cipherString
{
	size_t plainBufferSize = SecKeyGetBlockSize(privateKey);
	uint8_t *plainBuffer = malloc(plainBufferSize); NSData *incomingData = [NSData dataFromBase64String:cipherString];
	uint8_t *cipherBuffer = (uint8_t*)[incomingData bytes];
	size_t cipherBufferSize = SecKeyGetBlockSize(privateKey); SecKeyDecrypt(privateKey,
																			kSecPaddingOAEP,
																			cipherBuffer,
																			cipherBufferSize,
																			plainBuffer,
																			&plainBufferSize);
	NSData *decryptedData = [NSData dataWithBytes:plainBuffer length:plainBufferSize];
	NSString *decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding]; return decryptedString;
}

+ (void)addPeerPublicKey:(NSString *)peerName keyString:(NSString *)publicKeyString
{
    SecKeyRef peerKey = [Security getPeerPublicKey:peerName];
	
	if (!peerKey)
	{
		NSData *publicKeyData = [NSData dataFromBase64String:publicKeyString];
		
		NSData *peerTag = [NSData dataFromBase64String:[@"com.ashudesai.prism." stringByAppendingString:peerName]];
		NSMutableDictionary *peerPublicKeyAttr = [[NSMutableDictionary alloc] init];
		
		[peerPublicKeyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
		[peerPublicKeyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
		[peerPublicKeyAttr setObject:peerTag forKey:(__bridge id)kSecAttrApplicationTag];
		[peerPublicKeyAttr setObject:publicKeyData forKey:(__bridge id)kSecValueData];
		[peerPublicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];

		OSStatus err = SecItemAdd((__bridge CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&peerKey);
		
		if (err == errSecSuccess)
			CFDictionaryAddValue(dict, (CFStringRef)peerName, peerKey);
		
		if (peerKey) CFRelease(peerKey);
	}
}

+ (SecKeyRef)getPeerPublicKey:(NSString *)peerName
{
    SecKeyRef peerKey = (SecKeyRef)CFDictionaryGetValue(dict, (CFStringRef)peerName);
	
	if (!peerKey)
	{		
		NSData *peerTag = [NSData dataFromBase64String:[@"com.ashudesai.prism." stringByAppendingString:peerName]];
		NSMutableDictionary *peerPublicKeyAttr = [[NSMutableDictionary alloc] init];
		
		[peerPublicKeyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
		[peerPublicKeyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
		[peerPublicKeyAttr setObject:peerTag forKey:(__bridge id)kSecAttrApplicationTag];
		[peerPublicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
		
		OSStatus err = SecItemCopyMatching((__bridge CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&peerKey);
		
		if (err == errSecSuccess)
			CFDictionaryAddValue(dict, (CFStringRef)peerName, peerKey);
	}
	
	return peerKey;
//	if (peerKey) CFRelease(peerKey);
}



@end
