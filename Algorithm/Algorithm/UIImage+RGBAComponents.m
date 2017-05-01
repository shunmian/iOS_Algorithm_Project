//
//  UIImage+RGBAComponents.m
//  Algorithm
//
//  Created by LAL on 17/4/11.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "UIImage+RGBAComponents.h"
#import <objc/runtime.h>

static NSString *kRGBAComponentsKey = @"RGBAComponentsKey";
@implementation UIImage (RGBAComponents)


-(NSArray *)rgbaComponents{
    NSArray *array = objc_getAssociatedObject(self, &kRGBAComponentsKey);
    if(array == nil){
        array = [self getWholeImageRGVAComponents];
        objc_setAssociatedObject(self,&kRGBAComponentsKey,array,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return array;
}

-(void)setRgbaComponents:(NSArray *)rgbaComponents{
    objc_setAssociatedObject(self,&kRGBAComponentsKey,rgbaComponents,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSArray *)getWholeImageRGVAComponents{
    NSArray *oneDColors = [[self class] getRGBAsFromImage:self atX:0 andY:0 count:self.size.height*self.size.width];
    NSMutableArray *twoDColors = [NSMutableArray arrayWithCapacity:(int)self.size.height];
    for(int row = 0; row < (int)self.size.height; row++){
        twoDColors[row] = [NSMutableArray arrayWithCapacity:(int)self.size.width];
        for(int col = 0; col < (int)self.size.width;col++){
            twoDColors[row][col] = oneDColors[row*(int)self.size.width+col];
        }
    }
    return [NSArray arrayWithArray:twoDColors];
}

//x and y are the coordinates within the image to start getting RGBAs from and 'count' is the number of pixels from that point to get, going left to right, then row by row. Example Usage: To get RGBAs for an entire image: getRGBAsFromImage:image atX:0 andY:0 count:image.size.width*image.size.height To get RGBAs for the last row of an image: getRGBAsFromImage:image atX:0 andY:image.size.height-1 count:image.size.width
+ (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)x andY:(int)y count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    for (int i = 0 ; i < count ; ++i)
    {
        CGFloat alpha = ((CGFloat) rawData[byteIndex + 3] ) / 255.0f;
        CGFloat red   = ((CGFloat) rawData[byteIndex]     ) / alpha;
        CGFloat green = ((CGFloat) rawData[byteIndex + 1] ) / alpha;
        CGFloat blue  = ((CGFloat) rawData[byteIndex + 2] ) / alpha;
        byteIndex += bytesPerPixel;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    
    free(rawData);
    
    return result;
}

@end
