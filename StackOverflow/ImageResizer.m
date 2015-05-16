//
//  ImageResizer.m
//  StackOverflow
//
//  Created by User on 5/13/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "ImageResizer.h"

@implementation ImageResizer

+(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size {
  UIGraphicsBeginImageContext(size);
  [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

@end