//
//  main.m
//  mp4_metadata_extractor
//
//  Created by Grigory Zubankov on 13/04/14.
//  Copyright (c) 2014 Grigory Zubankov. All rights reserved.
//

// Foundation
#import <Foundation/Foundation.h>
#include <mp4v2/mp4v2.h>


NSString* extensionFromArtworkType(MP4TagArtworkType type)
{
  switch (type)
  {
    case MP4_ART_BMP:
      return @".bmp";
    case MP4_ART_GIF:
      return @".gif";
    case MP4_ART_JPEG:
      return @".jpg";
    case MP4_ART_PNG:
      return @".jpg";
    default:
      return @".undefinded";
  }
}


int main(int argc, const char * argv[])
{
  @autoreleasepool
  {
    NSURL* urlSource = [NSURL fileURLWithPath:[NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding]];
    
    MP4FileHandle	fileHandle = MP4Read([[urlSource path] UTF8String]);
    const MP4Tags* tags = MP4TagsAlloc();
    MP4TagsFetch( tags, fileHandle );

    if (tags->artwork)
    {
      for (NSInteger i = 0; i < tags->artworkCount; i++)
      {
        NSURL* urlTarget = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@-%ld-%@", [urlSource lastPathComponent], i, extensionFromArtworkType(tags->artwork[i].type)]];
        NSData *artwork = [NSData dataWithBytes:tags->artwork[i].data length:tags->artwork[i].size];
        NSError* error;
        [artwork writeToURL:urlTarget options:NSDataWritingAtomic error:&error];
        if (!error)
        {
          NSLog(@"Artwork has written as %@", [urlTarget lastPathComponent]);
        }
        else
        {
          NSLog(@"Error writing artwork %ld", i);
        }
      }
    }

    MP4TagsFree(tags);

  }
  return 0;
}

