//
//  ImageModel.h
//  TXXE
//
//  Created by River on 15/6/10.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageModel : NSObject

@property (nonatomic , copy) NSString *localImagePath;
@property (nonatomic , strong) UIImage *orignalImage;

- (void)uploadOrignalImageWithCompletionHandler:(void(^)(NSError *error,NSDictionary *callback))completionHandler;

+ (void)uploadForLocalImages:(NSArray *)localImageModels completionHandler:(void(^)(NSError *error,NSArray *imageUrlTexts))completionHandler;

/**
 *  将从相机上获取到的orignalImage存入到磁盘中，将文件路径放到localImagePath上
 *  保存成功后，将orignalImage占用的内存收回
 *
 */
- (BOOL)saveImageOnDiskWithSize:(CGSize)imageSize;

@end
