
//
//  ImageModel.m
//  TXXE
//
//  Created by River on 15/6/10.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "ImageModel.h"
#import "Constants.h"

@interface ImageModel ()

@end

@implementation ImageModel

- (void)uploadOrignalImageWithCompletionHandler:(void (^)(NSError *, NSDictionary *))completionHandler
{
    if (self.orignalImage) {
        NSURLRequest *request = [[self class] fillRequestWithImage:self.orignalImage];
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                NSLog(@"上传图片网络连接错误error = %@",connectionError);
                completionHandler(connectionError,nil);
            } else {
                NSError *decodeError = nil;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&decodeError];
                if (jsonResponse && ![jsonResponse isKindOfClass:[NSNull class]] && [jsonResponse[@"errno"] integerValue] == 0) {
                    NSLog(@"上传图片成功:%@",jsonResponse);
                    completionHandler(nil,jsonResponse[@"data"]);
                } else {
                    completionHandler(decodeError,nil);
                }
            }
        }];
    }
}

+ (NSURLRequest *)fillRequestWithImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *urlText = [NSString stringWithFormat:@"%@/common/FileUpload?fileExt=png",kServerHttpBaseURLString];
    NSURL *url = [NSURL URLWithString:urlText];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 60;
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    
    NSString *boundary = @"13AB0A19-0DC6-401D-B00C-85975ED7";
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    return request;
}

+ (void)uploadForLocalImages:(NSArray *)localImageModels completionHandler:(void (^)(NSError *, NSArray *))completionHandler
{
    dispatch_group_t uploadGroup = dispatch_group_create();
    NSMutableArray *imageUrlTexts = [NSMutableArray array];
    __block NSError *uploadError = nil;
    
    for (ImageModel *tempModel in localImageModels) {
        UIImage *image = [UIImage imageNamed:tempModel.localImagePath];
        NSURLRequest *request = [self fillRequestWithImage:image];
        
        dispatch_group_enter(uploadGroup);
        NSLog(@"开始上传图片");
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                NSLog(@"上传图片网络连接错误error = %@",connectionError);
                uploadError = connectionError;
            } else {
                NSError *decodeError = nil;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&decodeError];
                if (jsonResponse && ![jsonResponse isKindOfClass:[NSNull class]] && [jsonResponse[@"errno"] integerValue] == 0) {
                    [imageUrlTexts addObject:jsonResponse[@"data"][@"filePath"]];
                } else {
                    uploadError = [NSError errorWithDomain:@"ServiceError" code:10 userInfo:@{NSLocalizedDescriptionKey:jsonResponse[@"error"]}];
                    NSLog(@"图片服务器报错uploadError = %@",uploadError);
                }
            }
            dispatch_group_leave(uploadGroup);
        }];
    }
    
    dispatch_group_notify(uploadGroup, dispatch_get_main_queue(), ^{
        if (imageUrlTexts.count == localImageModels.count) {
            NSLog(@"所有图片都已经上传完毕,都是成功上传");
            completionHandler(nil,imageUrlTexts);
        } else {
            completionHandler(uploadError,nil);
        }
    });
}

- (BOOL)saveImageOnDiskWithSize:(CGSize)imageSize
{
    if (self.orignalImage) {
        NSString *nstempDirectory = NSTemporaryDirectory();
        NSString *tempImageDir = [nstempDirectory stringByAppendingPathComponent:@"tempImages"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:tempImageDir]) {
            [fileManager createDirectoryAtPath:tempImageDir
                   withIntermediateDirectories:NO
                                    attributes:NULL
                                         error:NULL];
        }
        
        if (self.orignalImage.size.width > imageSize.width || self.orignalImage.size.height > imageSize.height) {
            CGRect compressedImageRect = CGRectZero;
            if (self.orignalImage.size.height > imageSize.height) {
                compressedImageRect = CGRectMake(0, 0, imageSize.width, imageSize.width * self.orignalImage.size.height / self.orignalImage.size.width);
            }
            if (compressedImageRect.size.width > imageSize.width) {
                compressedImageRect = CGRectMake(0, 0, imageSize.height * compressedImageRect.size.width / compressedImageRect.size.height, imageSize.height);
            }
            if (CGRectEqualToRect(compressedImageRect, CGRectZero)) {
                compressedImageRect  = (CGRect){CGPointZero,self.orignalImage.size};
            }
            UIGraphicsBeginImageContextWithOptions(compressedImageRect.size, NO, 1.0);
            [self.orignalImage drawInRect:compressedImageRect];
            self.orignalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss_SSS"];
        NSData *imageData = UIImageJPEGRepresentation(self.orignalImage, 0.8);
        NSString *imageFileName = [formatter stringFromDate:[NSDate date]];
        imageFileName = [imageFileName stringByAppendingPathExtension:@"jpg"];
        self.localImagePath = [tempImageDir stringByAppendingPathComponent:imageFileName];
        if ([imageData writeToFile:self.localImagePath atomically:YES]) {
            @autoreleasepool {
                self.orignalImage = nil;
            }
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

@end