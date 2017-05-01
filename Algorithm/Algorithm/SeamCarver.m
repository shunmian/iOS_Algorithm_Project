//
//  SeamCarver.m
//  Algorithm
//
//  Created by LAL on 17/4/11.
//  Copyright © 2017年 LAL. All rights reserved.
//

#import "SeamCarver.h"
#import "UIImage+RGBAComponents.h"
#import "UIColor+RGBAComponents.h"
#import "IndexMinPriorityQueue.h"

@interface SeamCarver()
@property (nonatomic, strong) NSArray *colorMatrix;
@end

@implementation SeamCarver
/*
-(instancetype)initWithImage:(UIImage *)image{
    if(self = [self init]){
        _height = image.size.height;
        _width = image.size.width;
        _colorMatrix = image.rgbaComponents;
    }
    return self;
}

-(UIImage *)image{
    //
    //Constructing RGBA data
    //
    //height and width are integers denoting the dimensions of the image
    unsigned char *rawData = malloc(self.width*self.height*4);
    
    //populating rawData with pixel colour values and alpha information
    for (int i=0; i<self.width*self.height;++i){
        int row = i/(int)self.width;
        int col = i%(int)self.width;
        UIColor *color = self.colorMatrix[row][col];
        const CGFloat* components = CGColorGetComponents(color.CGColor);
        rawData[4*i] = components[0];
        rawData[4*i+1] = components[1];
        rawData[4*i+2] = components[2];
        rawData[4*i+3] = components[3]; //alpha
    }
    
    //
     Once we have the raw data, we convert it into a UIImage.
     The following code does the required work.
 
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,rawData,self.width*self.height*4,NULL);
    
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4*self.width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageRef =
    CGImageCreate(self.width,self.height,8,32,4*self.width,colorSpaceRef,bitmapInfo,provider,NULL,NO,renderingIntent);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    //
     newImage is the final image that is constructed from raw RGBA data.
     Do remember to release the allocated parts.
     
    return newImage;
}

-(NSNumber *)energyAtRow:(int)row andCol:(int)col{
    if(col < 0 || col > self.width-1 || row < 0 || row > self.height-1){
        [NSException raise:@"index out of bounds" format:@"%@",self];
    }
    
    if(col == 0|| col== self.width-1 || row ==0 || row == self.height-1){
        return @(195075.0);
    }
    
    CGFloat totalGradient =  [self squareOfXGradientAtRow:row andCol:col] + [self squareOfYGradientAtRow:row andCol:col] ;
    return [NSNumber numberWithFloat:totalGradient];
}


-(NSArray *)findVerticalSeam{
    NSArray *energyMatrix = [self toEnergyMatrixWithHeight:self.width andWidth:self.height isTranspose:FALSE];
    return [self findSeamWithEnergyMatrix:energyMatrix];
}

-(NSArray *)findHorizontalSeam{
    NSArray *energyMatrix = [self toEnergyMatrixWithHeight:self.height andWidth:self.width isTranspose:TRUE];
    return [self findSeamWithEnergyMatrix:energyMatrix];
}

-(void)removeVerticalSeamWithSeam:(NSArray *)seam{
    if(seam.count != self.height || self.width <=1)
        [NSException raise:@"Illeagal Argument" format:@"%@",_cmd];
    
    NSMutableArray *copy = [self create2DMutableArrayWithRow:self.height andCol:self.width-1];
    for (int row = 0; row < self.height; row++){
        for(int col = 0; col < self.width; col++){
            if(col < ((NSNumber *)seam[row]).integerValue) copy[row][col] = self.colorMatrix[row][col];
            else  copy[row][col+1] = self.colorMatrix[row][col];
        }
    }
    self.width--;
    self.colorMatrix = copy;
}

-(void)removeHorizontalSeamWithSeam:(NSArray *)seam{
    if(seam.count != self.width || self.height <=1)
        [NSException raise:@"Illeagal Argument" format:@"%@",_cmd];
    
    NSMutableArray *copy = [self create2DMutableArrayWithRow:self.height-1 andCol:self.width];
    for (int row = 0; row < self.height-1; row++){
        for(int col = 0; col < self.width; col++){
            if(row < ((NSNumber *)seam[col]).integerValue) copy[row][col] = self.colorMatrix[row][col];
            else copy[row][col] = self.colorMatrix[row+1][col];
        }
    }
    self.height--;
    self.colorMatrix = copy;
}

#pragma mark - helper

-(CGFloat)squareOfXGradientAtRow:(int)row andCol:(int)col{
    UIColor *c1 = self.colorMatrix[row][col-1];
    UIColor *c2 = self.colorMatrix[row][col+1];
    CGFloat r = [c1 redComponent] - [c2 redComponent];
    CGFloat g = [c1 greenComponent] - [c2 greenComponent];
    CGFloat b = [c1 blueComponent] - [c2 blueComponent];
    return r*r+g*g+b*b;
}

-(CGFloat)squareOfYGradientAtRow:(int)row andCol:(int)col{
    UIColor *c1 = self.colorMatrix[row-1][col];
    UIColor *c2 = self.colorMatrix[row+1][col];
    CGFloat r = [c1 redComponent] - [c2 redComponent];
    CGFloat g = [c1 greenComponent] - [c2 greenComponent];
    CGFloat b = [c1 blueComponent] - [c2 blueComponent];
    return r*r+g*g+b*b;
}

-(NSArray *)toEnergyMatrixWithHeight:(int)height andWidth:(int)width isTranspose:(BOOL)isTranspose{
    NSMutableArray *eMatrix = [NSMutableArray arrayWithCapacity:self.height];
    for(int row = 0; row < height; row++){
        eMatrix[row] = [NSMutableArray arrayWithCapacity:self.width];
        for(int col = 0; col < width; col++){
            if(isTranspose) eMatrix[row][col] = [self energyAtRow:col andCol:row];
            else eMatrix[row][col] = [self energyAtRow:row andCol:col];
        }
    }
    return [NSArray arrayWithArray:eMatrix];
}

-(NSArray *)findSeamWithEnergyMatrix:(NSArray *)eMatrix{
    
    NSMutableArray *energyTo = [self create2DMutableArrayWithRow:self.height andCol:self.width];
    for(int row = 0; row < self.height; row++){
        for(int  col = 0; col < self.width; col++){
            if(row == 0) energyTo[row][col] = @195075.0;
            else energyTo[row][col] = @(INFINITY);
        }
    }
    NSMutableArray *seam = [NSMutableArray arrayWithCapacity:self.height];
    NSMutableArray *edgeTo = [self create2DMutableArrayWithRow:self.height andCol:self.width];
    IndexMinPriorityQueue *pq = [[IndexMinPriorityQueue alloc] initWithCapacity:self.width];

    // calculate energyTo by relax pixels
    for (int row = 0; row < self.height - 1; row++){
        for(int col = 0; col < self.width; col++){
            for(int k = col-1; k <=col+1; k++){
                if(k>=0 && k < self.width){
                    NSNumber *eCurrent = (NSNumber *)(energyTo[row+1][k]);
                    NSNumber *ePre = (NSNumber *)(energyTo[row][col]);
                    NSNumber *delta = (NSNumber *)(energyTo[row+1][k]);
                    if(eCurrent.floatValue > ePre.floatValue + delta.floatValue){
                        energyTo[row+1][k] = @(ePre.floatValue + delta.floatValue);
                        edgeTo[row+1][k] = @([self rowAndColTo1DWithRow:row andCol:col]);
                    }
                }
            }
        }
    }
    
    // find the minimum index in last row
    for (int col = 0; col < self.width; col++){
        [pq insertIndex:col WithValue:@(self.height-1)];
    }
    seam[self.height-1] = [pq minIndex];
    
    // back-track
    for (int row = self.height-1; row > 9; row--){
        NSNumber *seamCurrentRow = seam[row];
        NSNumber *seamCol = edgeTo[seamCurrentRow.integerValue][row];
        seam[row-1] = @((seamCol.integerValue)%self.width);
    }
    return [NSArray arrayWithArray:seam];
}

-(NSMutableArray *)create2DMutableArrayWithRow:(int)row andCol:(int) col{
    NSMutableArray *energyTo = [NSMutableArray arrayWithCapacity:row];
    for(int r = 0; r < row; r++){
        energyTo[r] = [NSMutableArray arrayWithCapacity:col];
    }
    return energyTo;
}

-(int)rowAndColTo1DWithRow:(int)row andCol:(int)col{
    return row*self.width+col;
}
*/
@end
