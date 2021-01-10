//
//  AttributedStringEditTextView.m
//  ProductName
//
//  Created by wxl on 15/12/14.
//  Copyright © 2015年 Aim. All rights reserved.
//

#import "AttributedStringEditTextView.h"

@implementation AttributedStringEditTextView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)layoutSubviews {
    self.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 15);
}

- (void)didFinishPickingImage:(UIImage *)image {
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    
    textAttachment.image = [self imageCompressForWidth:image targetWidth:414*3];
    
    CGSize size = image.size;
    CGFloat width = ScreenWidth-10-20;
    CGFloat scale = size.width/width;
    CGFloat height = size.height/scale;
    textAttachment.bounds = CGRectMake(0, 0, width, height);
    
    NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    NSMutableAttributedString *string;
    if (super.attributedText) {
        string = [[NSMutableAttributedString alloc] initWithAttributedString:super.attributedText];
        [string insertAttributedString:imageString atIndex:super.selectedRange.location];
    }
    else {
        string = [[NSMutableAttributedString alloc] initWithString:super.text];
        [string insertAttributedString:imageString atIndex:super.selectedRange.location];
    }
    
    super.attributedText = string;
}

- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
