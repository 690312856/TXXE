//
//  PhotoCollectionCell.m
//  TXXE
//
//  Created by River on 15/6/11.
//  Copyright (c) 2015年 Andy_Lee. All rights reserved.
//

#import "PhotoCollectionCell.h"

@implementation PhotoCollectionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setImageModel:(ImageModel *)imageModel
{
    if (_imageModel != imageModel) {
        _imageModel = imageModel;
        self.imageView.image = [UIImage imageWithContentsOfFile:_imageModel.localImagePath];
    }
}
- (IBAction)deleteBtnAction:(id)sender {
    
    if (self.clickBlock) {
        self.clickBlock(sender);
    }
}
@end
