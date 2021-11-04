//
//  LJImageTools.m
//  imageTools
//
//  Created by LiJie on 16/1/12.
//  Copyright © 2016年 LiJie. All rights reserved.
//

#import "LJImageTools.h"
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

@implementation LJImageTools


/**  缩放图片 */
+(UIImage*)changeImageSize:(UIImage*)originImage toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [originImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(UIImage*)changeImageSizeOther:(UIImage*)originImage toSize:(CGSize)size
{
    UIImage* newImage=nil;
    CGSize imageSize=originImage.size;
    
    CGFloat width=imageSize.width;
    CGFloat height=imageSize.height;
    CGFloat targetWidth=size.width;
    CGFloat targetHeight=size.height;
    
    CGFloat scaleFactor=0.0;
    CGFloat scaleWidth=targetWidth;
    CGFloat scaleHeight=targetHeight;
    CGPoint thumbnailPoint=CGPointZero;
    
    if (CGSizeEqualToSize(imageSize, size)==NO)
    {
        CGFloat widthFacor=targetWidth/width;
        CGFloat heightFactor=targetHeight/height;
        scaleFactor= widthFacor<heightFactor ? widthFacor : heightFactor;
        scaleWidth=width*scaleFactor;
        scaleHeight=height*scaleFactor;
        if (widthFacor<heightFactor)
        {
            thumbnailPoint.y=(targetHeight-scaleHeight)*0.5;
        }
        else if (widthFacor>heightFactor)
        {
            thumbnailPoint.x=(targetWidth-scaleWidth)*0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect=CGRectZero;
    thumbnailRect.origin=thumbnailPoint;
    thumbnailRect.size.width=scaleWidth;
    thumbnailRect.size.height=scaleHeight;
    [originImage drawInRect:thumbnailRect];
    newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)rotationImage:(UIImage *)image rotation:(UIImageOrientation)orientation{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

+(UIImage *)rotationImage:(UIImage *)image angle:(CGFloat)angle{
    long double rotate = 0.0;
    CGRect rect;
//    float translateX = 0;
//    float translateY = 0;
//    float scaleX = 1.0;
//    float scaleY = 1.0;
    rotate=angle*M_PI/180;
    rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
//    CGContextTranslateCTM(context, 0.0, rect.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
//    CGContextTranslateCTM(context, translateX, translateY);
    
//    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

+(UIImage *)rotationImage:(UIImage *)image angle:(CGFloat)angle clip:(BOOL)clip{
    long double rotate = 0.0;
    CGRect rect;
    double translateX = 0;
    double translateY = 0;
    
    //使之顺时针旋转
    angle=fabs(360-angle);
    
    //角度换成弧度
    NSInteger multiple=angle/360;
    angle=angle-360*multiple;
    rotate=(angle)*M_PI/180;
    
    rect = CGRectMake(0, 0, image.size.width*image.scale, image.size.height*image.scale);
    CGSize imgSize = CGSizeMake(image.size.width*image.scale, image.size.height*image.scale);
    
    //因为图片是一个矩形，以图片的左上角为原点，对角线的一半为半径，画出一个圆。
    //此时图片的中心点的坐标的绝对值就是（image.size.with/2, image.size.height/2)
    double radius=sqrtf(powf(imgSize.width, 2)+powf(imgSize.height, 2))/2.0;
    
    //求出这个矩形的对角线所形成的角  反三角函数
    double originrRadian=asin(imgSize.width/2.0/radius);
    //angle实际从对角线开始 旋转的角度
    double currentRadian=fabs(rotate-originrRadian);
    
    //旋转时矩形的中心点 都在圆上，求出旋转后中心点所对应得坐标点的绝对值。
    translateX=fabs(radius * sin( currentRadian));
    translateY=fabs(radius * cos( currentRadian));
    
    // X 和原中心点的差值
    if (rotate<originrRadian || rotate>M_PI+originrRadian) {
        translateX=fabs(translateX-imgSize.width/2);
    }else{
        translateX=fabs(translateX+imgSize.width/2);
    }
    if (rotate>M_PI+originrRadian*2) {
        translateX=-translateX;
    }
    
    // Y 和原中心点的差值
    if (rotate<M_PI_2+originrRadian || rotate>M_PI_2*3+originrRadian) {
        translateY=fabs(translateY-imgSize.height/2);
    }else{
        translateY=fabs(translateY+imgSize.height/2);
    }
    if (rotate<originrRadian*2) {
        //向上平移（设备上的向上，quartz2D里面的就是向下）为负数
        translateY=-translateY;
    }
    
    //因为quart2D的坐标系是原点在左下角，和设备的坐标系相反，所以Y轴的移动旋转都要反过来看
    //即我们在设备上要图片向下，即在quartz2D里面就是向上 translateY就要大于0
    //这里的旋转 位移 是将整个坐标系都改变，所以要进行下一个操作的时候，坐标系就和原先的位置不同了。
    //在quartz2D里面旋转是逆时针旋转的。（在他的坐标系里面看）（在我们设备上就是顺时针了）
    
    UIGraphicsBeginImageContext(imgSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //1.画布延Y轴下移height
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    //2.对Y轴做垂直翻转
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //先位移后旋转，位置不能颠倒
    CGContextTranslateCTM(context, imgSize.width/2, imgSize.height/2);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, -imgSize.width/2 , -imgSize.height/2);
    
    
    
    //是否剪裁图片
    if (!clip) {
        rect=CGRectApplyAffineTransform(rect, CGAffineTransformTranslate(CGAffineTransformRotate(CGAffineTransformMakeTranslation(imgSize.width/2, imgSize.height/2), rotate), -imgSize.width/2, -imgSize.height/2));
        double newWidth=rect.size.width;
        double newHeight=rect.size.height;
        
        double scareWidth=imgSize.width/newWidth;
        double scareHeight=imgSize.height/newHeight;
        double scare=MIN(scareWidth, scareHeight);
        CGContextScaleCTM(context, scare, scare);
        
        NSInteger type=angle/45;
        if (type==1 || type==2 || type==5 || type==6) {
            double temp=newWidth;
            if (imgSize.width>imgSize.height) {
                newWidth=newHeight;//宽的图片
            }else{
                newHeight=temp;//长的图片
            }
        }
        
        double offsetX=fabs(imgSize.width-newWidth*scare)/2/scare;
        double offsetY=fabs(imgSize.height-newHeight*scare)/2/scare;
        if (offsetX<0.001) {
            offsetX=fabs(rect.origin.x);
        }
        if (offsetY<0.001) {
            offsetY=fabs(rect.origin.y);
        }
        
        rect.origin=CGPointMake(offsetX, offsetY);
        rect.size=imgSize;
    }
    
    //最后绘制图片
    CGContextDrawImage(context, rect, image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    newPic = [UIImage imageWithCGImage:newPic.CGImage scale:image.scale orientation:UIImageOrientationUp];
    
    return newPic;
}

/**  等比例缩放 */
+(UIImage*)changeImage:(UIImage*)originImage toRatioSize:(CGSize)size
{
    CGFloat width=originImage.size.width;
    CGFloat height=originImage.size.height;
    
    float verticalRadio=size.height/height;
    float horizontalRadio=size.width/width;
    float radio=verticalRadio>horizontalRadio ? horizontalRadio : verticalRadio;
    width=width*radio;
    height=height*radio;
    
    return [self changeImageSize:originImage toSize:CGSizeMake(width, height)];
}

/**  安最短边，等比例压缩 */
+(UIImage*)changeImageRatioCompress:(UIImage*)originImage ratioCompressSize:(CGSize)size
{
    CGFloat width=originImage.size.width;
    CGFloat height=originImage.size.height;
    if (width<size.width && height<size.height)
    {
        return originImage;
    }
    else
    {
        return [self changeImage:originImage toRatioSize:size];
    }
}

/**  剪切图片 */
+(UIImage*)cutImagePart:(UIImage*)originImage cutRect:(CGRect)rect
{
    CGImageRef subImageRef=CGImageCreateWithImageInRect(originImage.CGImage, rect);
    CGRect smallBounds=CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef contex=UIGraphicsGetCurrentContext();
    CGContextDrawImage(contex, smallBounds, subImageRef);
    UIImage* newImage=[UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return newImage;
}
void releaseData(void *info, const void *data, size_t size) {
    free((void *)data);
}
// 裁剪圆角
void cornerImage(UInt32 *const img, int w, int h, CGFloat cornerRadius) {
    CGFloat c = cornerRadius;
    CGFloat min = w > h ? h : w;
    
    if (c < 0) { c = 0; }
    if (c > min * 0.5) { c = min * 0.5; }
    
    // 左上 y:[0, c), x:[x, c-y)
    for (int y=0; y<c; y++) {
        for (int x=0; x<c-y; x++) {
            UInt32 *p = img + y * w + x;    // p 32位指针，RGBA排列，各8位
            if (isCircle(c, c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 右上 y:[0, c), x:[w-c+y, w)
    int tmp = w-c;
    for (int y=0; y<c; y++) {
        for (int x=tmp+y; x<w; x++) {
            UInt32 *p = img + y * w + x;
            if (isCircle(w-c, c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 左下 y:[h-c, h), x:[0, y-h+c)
    tmp = h-c;
    for (int y=h-c; y<h; y++) {
        for (int x=0; x<y-tmp; x++) {
            UInt32 *p = img + y * w + x;
            if (isCircle(c, h-c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 右下 y~[h-c, h), x~[w-c+h-y, w)
    tmp = w-c+h;
    for (int y=h-c; y<h; y++) {
        for (int x=tmp-y; x<w; x++) {
            UInt32 *p = img + y * w + x;
            if (isCircle(w-c, h-c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
}
// 判断点 (px, py) 在不在圆心 (cx, cy) 半径 r 的圆内
static inline bool isCircle(float cx, float cy, float r, float px, float py) {
    if ((px-cx) * (px-cx) + (py-cy) * (py-cy) > r * r) {
        return false;
    }
    return true;
}
/**   添加圆角 */
+(UIImage*)addImageRound:(UIImage*)img roundSize:(CGFloat)c
{
//    // 1.CGDataProviderRef 把 CGImage 转 二进制流
//    CGDataProviderRef provider = CGImageGetDataProvider(img.CGImage);
//    void *imgData = (void *)CFDataGetBytePtr(CGDataProviderCopyData(provider));
//    int width = img.size.width * img.scale;
//    int height = img.size.height * img.scale;
//
//    // 2.处理 imgData
//    //    dealImage(imgData, width, height);
//    cornerImage(imgData, width, height, c);
//
//    // 3.CGDataProviderRef 把 二进制流 转 CGImage
//    CGDataProviderRef pv = CGDataProviderCreateWithData(NULL, imgData, width * height * 4, releaseData);
//    CGImageRef content = CGImageCreate(width , height, 8, 32, 4 * width, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast, pv, NULL, true, kCGRenderingIntentDefault);
//    UIImage *result = [UIImage imageWithCGImage:content];
//    CGDataProviderRelease(pv);      // 释放空间
//    CGImageRelease(content);
//
//    return result;
    
    
    int w = img.size.width * img.scale;
    int h = img.size.height * img.scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, c);
    CGContextAddArcToPoint(context, 0, 0, c, 0, c);
    CGContextAddLineToPoint(context, w-c, 0);
    CGContextAddArcToPoint(context, w, 0, w, c, c);
    CGContextAddLineToPoint(context, w, h-c);
    CGContextAddArcToPoint(context, w, h, w-c, h, c);
    CGContextAddLineToPoint(context, c, h);
    CGContextAddArcToPoint(context, 0, h, 0, h-c, c);
    CGContextAddLineToPoint(context, 0, c);
    CGContextClosePath(context);
    
    CGContextClip(context);     // 先裁剪 context，再画图，就会在裁剪后的 path 中画
    [img drawInRect:CGRectMake(0, 0, w, h)];       // 画图
    CGContextDrawPath(context, kCGPathFill);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return ret;
    
    
//    int w=img.size.width;
//    int h=img.size.height;
//
//        UIImage* tempImage=img;
//        CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
//        CGContextRef context=CGBitmapContextCreate(NULL, w, h, 8, 4*w, colorSpace, (uint32_t)kCGImageAlphaPremultipliedFirst);
//        CGRect rect=CGRectMake(0, 0, w, h);
//
//        CGContextBeginPath(context);
//        addRoundedRectToPath(context, rect, 5, 5);
//        CGContextClosePath(context);
//        CGContextClip(context);
//        CGContextDrawImage(context, CGRectMake(0, 0, w, h), tempImage.CGImage);
//        CGImageRef imageMasked=CGBitmapContextCreateImage(context);
//        UIImage* newImage=[UIImage imageWithCGImage:imageMasked];
//        CGContextRelease(context);
//        CGImageRelease(imageMasked);
//        CGColorSpaceRelease(colorSpace);
//        return  newImage;
}

//添加圆角
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw,fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

/**  获取网络图片大小 */
+(CGSize)getNetImageSizeWith:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil) return CGSizeZero;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getNetPNGImageSizeWith:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getNetGIFImageSizeWith:request];
    }
    else{
        size = [self getNetJPGImageSizeWith:request];
    }
    return size;
}



+(CGSize)getNetPNGImageSizeWith:(NSMutableURLRequest*)request
{
//    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
//    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if(data.length == 8)
//    {
//        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
//        [data getBytes:&w1 range:NSMakeRange(0, 1)];
//        [data getBytes:&w2 range:NSMakeRange(1, 1)];
//        [data getBytes:&w3 range:NSMakeRange(2, 1)];
//        [data getBytes:&w4 range:NSMakeRange(3, 1)];
//        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
//        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
//        [data getBytes:&h1 range:NSMakeRange(4, 1)];
//        [data getBytes:&h2 range:NSMakeRange(5, 1)];
//        [data getBytes:&h3 range:NSMakeRange(6, 1)];
//        [data getBytes:&h4 range:NSMakeRange(7, 1)];
//        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
//        return CGSizeMake(w, h);
//    }
    return CGSizeZero;
}
+(CGSize)getNetGIFImageSizeWith:(NSMutableURLRequest*)request
{
//    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
//    NSData* data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    if (data.length==4)
//    {
//        short w1=0, w2=0;
//        [data getBytes:&w1 range:NSMakeRange(0, 1)];
//        [data getBytes:&w2 range:NSMakeRange(1, 1)];
//        short w=w1 + (w2<<8);
//
//        short h1=0, h2=0;
//        [data getBytes:&h1 range:NSMakeRange(2, 1)];
//        [data getBytes:&h2 range:NSMakeRange(3, 1)];
//        short h=h1+(h2<<8);
//        return CGSizeMake(w, h);
//    }
    return CGSizeZero;
}
+(CGSize)getNetJPGImageSizeWith:(NSMutableURLRequest*)request
{
    return CGSizeZero;
//    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
//    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//
//    if ([data length] <= 0x58) {
//        return CGSizeZero;
//    }
//
//    if ([data length] < 210) {// 肯定只有一个DQT字段
//        short w1 = 0, w2 = 0;
//        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
//        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
//        short w = (w1 << 8) + w2;
//        short h1 = 0, h2 = 0;
//        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
//        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
//        short h = (h1 << 8) + h2;
//        return CGSizeMake(w, h);
//    } else {
//        short word = 0x0;
//        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
//        if (word == 0xdb) {
//            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
//            if (word == 0xdb) {// 两个DQT字段
//                short w1 = 0, w2 = 0;
//                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
//                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
//                short w = (w1 << 8) + w2;
//                short h1 = 0, h2 = 0;
//                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
//                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
//                short h = (h1 << 8) + h2;
//                return CGSizeMake(w, h);
//            } else {// 一个DQT字段
//                short w1 = 0, w2 = 0;
//                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
//                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
//                short w = (w1 << 8) + w2;
//                short h1 = 0, h2 = 0;
//                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
//                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
//                short h = (h1 << 8) + h2;
//                return CGSizeMake(w, h);
//            }
//        } else {
//            return CGSizeZero;
//        }
//    }
}

+(UIImage *)setBlurImage:(UIImage *)originImage blurAmount:(CGFloat)blurAmount
{
    if (blurAmount < 0.0 || blurAmount > 1.0) {
        blurAmount = 0.5;
    }
    
    int boxSize = (int)(blurAmount * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = originImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (!error) {
        error = vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        if (!error) {
            error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

+(UIImage*)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur
{
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    //@"inputRadius",
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"
                                  keysAndValues:kCIInputImageKey, inputImage, @"inputRadius", @(blur),
                        nil];
    
    CIImage *outputImage = filter.outputImage;
    
    CIContext* context=[CIContext contextWithOptions:nil];
    CGImageRef outImage = [context createCGImage:outputImage
                                        fromRect:[outputImage extent]];
    return [UIImage imageWithCGImage:outImage];
}


/**  根据颜色获取图片 */
+(UIImage*)getImageForColor:(UIColor*)color size:(CGSize)size{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}



@end
