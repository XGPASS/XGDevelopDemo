//
//  XGSoundHelper.h
//  XGSoundHelper

#import <Foundation/Foundation.h>

@interface XGSoundHelper : NSObject

+ (void)clearSoundCache;
+ (void)playSoundFromURL:(NSURL *)soundFileURL asAlert:(BOOL)alert;
+ (void)playSoundFromFile:(NSString *)soundFileName fromBundle:(NSBundle *)bundle asAlert:(BOOL)alert;

@end
