//
//  BaseCharacters.m
//
//  Created by Robert C. Nix on 2010.04.14.
//  Copyright 2010 nicerobot.org. All rights reserved.
//

#import "BaseCharacters.h"

static NSString *bases[BASES+1];

static BaseCharacters *sharedInstance = nil;

@implementation BaseCharacters

#pragma mark -
#pragma mark class instance methods

#pragma mark -
#pragma mark Singleton methods

+ (void) initialize {
  for (int i=0; i<BASES+1; i++) {
    bases[i] = nil;
  }
  bases[2] = @"01";
  bases[4] = [[NSString stringWithFormat:@"%@23",bases[2]] retain];
  bases[8] = [[NSString stringWithFormat:@"%@4567",bases[4]] retain];
  bases[10] = [[NSString stringWithFormat:@"%@89",bases[8]] retain];
  bases[16] = [[NSString stringWithFormat:@"%@abcdef",bases[10]] retain];
  bases[26] = @"abcdefghijklmnopqrstuvwxyz";
  // Alternate base32 chosen for readabilty, excluding "ilou"
  bases[32] = [[NSString stringWithFormat:@"%@ghjkmnpqrstvwxyz",bases[16]] retain];
  bases[52] = [[NSString stringWithFormat:@"%@%@",[bases[26] uppercaseString],bases[26]] retain];
  bases[56] = @"ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789";
  bases[64] = [[NSString stringWithFormat:@"%@%@+/",bases[52],bases[10]] retain];
  bases[85] = [[NSString stringWithFormat:@"%@%@!#$%&()*+-;<=>?@^_`{|}~",bases[10],bases[52]] retain];
  bases[94] = [[NSString stringWithFormat:@"%@[/]\\\"':,.",bases[85]] retain];
}

+ (BaseCharacters*)sharedInstance
{
  @synchronized(self)
  {
    if (sharedInstance == nil)
      sharedInstance = [[BaseCharacters alloc] init];
  }
  return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
  @synchronized(self) {
    if (sharedInstance == nil) {
      sharedInstance = [super allocWithZone:zone];
      return sharedInstance;  // assignment and return on first allocation
    }
  }
  return nil; // on subsequent allocation attempts return nil
}

+ (NSString*) get:(int) base {
  if (2 <= base && base <= BASES) {
    if (!bases[base]) {
      NSRange r = NSMakeRange(0, base);
      if (base<10) {
        bases[base] = [[NSString stringWithString:[bases[10] substringWithRange:r]] retain];
      } else if (base<32) {
        bases[base] = [[NSString stringWithString:[bases[32] substringWithRange:r]] retain];
      } else if (base<56) {
        bases[base] = [[NSString stringWithString:[bases[56] substringWithRange:r]] retain];
      } else if (base<64) {
        bases[base] = [[NSString stringWithString:[bases[64] substringWithRange:r]] retain];
      } else if (base<94) {
        bases[base] = [[NSString stringWithString:[bases[94] substringWithRange:r]] retain];
      }
    }
    return [bases[base] copy];
  }
  return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (id)retain {
  return self;
}

- (NSUInteger)retainCount {
  return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release {
  //do nothing
}

- (id)autorelease {
  return self;
}

@end