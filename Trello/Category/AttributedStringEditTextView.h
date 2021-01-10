//
//  AttributedStringEditTextView.h
//  ProductName
//
//  Created by wxl on 15/12/14.
//  Copyright © 2015年 Aim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttributedStringEditTextView : UITextView <UITextViewDelegate>
- (void)didFinishPickingImage:(UIImage *)image;
- (NSString *)publishImageText;
- (NSString *)previewImageText;
- (NSAttributedString *)convertAttributedStringFromHTML:(NSString *)html;
@end
