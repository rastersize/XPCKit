//
//  XPCUUID.m
//  XPCKit
//
//  Created by Steve Streza on 7/26/11. Copyright 2011 XPCKit.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "XPCUUID.h"


@implementation XPCUUID

@synthesize UUIDRef = _uuidRef;

+(XPCUUID *)UUID{
	CFUUIDRef uuidRef = CFUUIDCreate(NULL);
	XPCUUID *uuid = [[self alloc] initWithUUIDRef:uuidRef];
	CFRelease(uuidRef);
	return uuid;
}

+(XPCUUID *)UUIDWithXPCObject:(xpc_object_t)xpc{
	const uint8_t *bytes = xpc_uuid_get_bytes(xpc);
	
	CFUUIDBytes uuidBytes;
#define CopyByte(__idx) uuidBytes.byte ## __idx = bytes[__idx]
	CopyByte(0);
	CopyByte(1);
	CopyByte(2);
	CopyByte(3);
	CopyByte(4);
	CopyByte(5);
	CopyByte(6);
	CopyByte(7);
	CopyByte(8);
	CopyByte(9);
	CopyByte(10);
	CopyByte(11);
	CopyByte(12);
	CopyByte(13);
	CopyByte(14);
	CopyByte(15);
#undef CopyByte
	
	CFUUIDRef uuidRef = CFUUIDCreateFromUUIDBytes(NULL, uuidBytes);
	XPCUUID *uuid = [[self alloc] initWithUUIDRef:uuidRef];

	CFRelease(uuidRef);
	
	return uuid;
}

-(xpc_object_t)newXPCObject {
	CFUUIDBytes uuidBytes = CFUUIDGetUUIDBytes(self.UUIDRef);
	UInt8 *bytes = malloc(sizeof(UInt8) * 16);

#define CopyByte(__idx) bytes[__idx] = uuidBytes.byte ## __idx
	CopyByte(0);
	CopyByte(1);
	CopyByte(2);
	CopyByte(3);
	CopyByte(4);
	CopyByte(5);
	CopyByte(6);
	CopyByte(7);
	CopyByte(8);
	CopyByte(9);
	CopyByte(10);
	CopyByte(11);
	CopyByte(12);
	CopyByte(13);
	CopyByte(14);
	CopyByte(15);
#undef CopyByte
	
	xpc_object_t xpcUUID = xpc_uuid_create(bytes);
	
	free(bytes);
	return xpcUUID;
}

-(NSString *)UUIDString{
	NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, self.UUIDRef);
	return uuidString;
}

-(NSString *)description{
	return [NSString stringWithFormat:@"<%@ %@>",[self class],self.UUIDString];
}

-(BOOL)isEqual:(id)object{
	return [[self description] isEqual:[object description]];
}

-(NSUInteger)hash{
	return [[self description] hash];
}

-(instancetype)initWithUUIDRef:(CFUUIDRef)uuidRef{
    self = [super init];
    if (self) {
		_uuidRef = CFRetain(uuidRef);
    }
    
    return self;
}

-(instancetype)initWithUUIDString:(NSString *)uuidString{
	CFUUIDRef uuidRef = CFUUIDCreateFromString(NULL, (__bridge CFStringRef)uuidString);
	self = [self initWithUUIDRef:uuidRef];
	CFRelease(uuidRef);
	
	return self;
}

-(void)dealloc{
	if(_uuidRef){
		CFRelease(_uuidRef);
		_uuidRef = nil;
	}
}

- (id)copyWithZone:(NSZone * __unused)zone
{
	// We are immutable as such we can just return self.
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
	NSString *uuidString = [aDecoder decodeObjectForKey:@"XPCUUIDString"];
	self = [self initWithUUIDString:uuidString];
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
	[aCoder encodeObject:self.UUIDString forKey:@"XPCUUIDString"];
}

@end
