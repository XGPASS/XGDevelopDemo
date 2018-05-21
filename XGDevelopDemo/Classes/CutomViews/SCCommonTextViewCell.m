//
//  SCCommonTextViewCell.m
//  SuperCommunity
//
//  Created by zhanglijiong on 2017/11/23.
//  Copyright © 2017年 uama. All rights reserved.
//

#import "SCCommonTextViewCell.h"

@interface SCCommonTextViewCell  () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@end;

@implementation SCCommonTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    _MAX_LIMIT_NUMS = 1000;
    _minHeight = 100.f;
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
    self.textView.font = [UIFont systemFontOfSize:15.0];
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    // Initialization code
}

- (void)setMinHeight:(CGFloat)minHeight {
    _minHeight = minHeight;
    self.textViewHeightConstraint.constant = _minHeight;
}

- (void)setMAX_LIMIT_NUMS:(NSInteger)MAX_LIMIT_NUMS {
    _MAX_LIMIT_NUMS = MAX_LIMIT_NUMS;
//    [self.textView setValue:@(_MAX_LIMIT_NUMS) forKey:PROPERTY_NAME];
}

- (void)setTextStr:(NSString *)textStr {
    _textStr = textStr;
    if (_textStr.length > self.MAX_LIMIT_NUMS) {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [textStr substringToIndex:self.MAX_LIMIT_NUMS];
        [self.textView setText:s];
    } else {
        [self.textView setText:_textStr];
    }
    [self refreshTextViewSize:self.textView];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    //对于退格删除键开放限制
    if (text.length == 0) {
        return YES;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < _MAX_LIMIT_NUMS) {
            return YES;
        } else {
            return NO;
        }
    }
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = _MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0) {
        //加入动态计算高度
        CGSize size = [self getStringRectInTextView:comcatstr InTextView:textView];
        CGRect frame = textView.frame;
        frame.size.height = size.height;
        
        textView.frame = frame;
        return YES;
    } else {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0) {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            } else {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          NSInteger steplen = substring.length;
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx = idx + steplen;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //由于后面反回的是NO不触发didchange
            [self refreshTextViewSize:textView];
        }
        return NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum > _MAX_LIMIT_NUMS) {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:_MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    [self refreshTextViewSize:textView];
}

#pragma mark - textView helper
- (void)refreshTextViewSize:(UITextView *)textView {
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    CGRect frame = textView.frame;
    frame.size.height = size.height;
    textView.frame = frame;
    if (size.height > _minHeight) {
        self.textViewHeightConstraint.constant = size.height;
    } else {
        self.textViewHeightConstraint.constant = _minHeight;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
// 计算高度
- (CGSize)getStringRectInTextView:(NSString *)string InTextView:(UITextView *)textView {
    //实际textView显示时我们设定的宽
    CGFloat contentWidth = CGRectGetWidth(textView.frame);
    //但事实上内容需要除去显示的边框值
    CGFloat broadWith    = (textView.contentInset.left + textView.contentInset.right
                            + textView.textContainerInset.left
                            + textView.textContainerInset.right
                            + textView.textContainer.lineFragmentPadding/*左边距*/
                            + textView.textContainer.lineFragmentPadding/*右边距*/);
    
    CGFloat broadHeight  = (textView.contentInset.top
                            + textView.contentInset.bottom
                            + textView.textContainerInset.top
                            + textView.textContainerInset.bottom);
    
    //由于求的是普通字符串产生的Rect来适应textView的宽
    contentWidth -= broadWith;
    
    CGSize InSize = CGSizeMake(contentWidth, MAXFLOAT);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = textView.textContainer.lineBreakMode;
    NSDictionary *dic = @{NSFontAttributeName:textView.font, NSParagraphStyleAttributeName:[paragraphStyle copy]};
    
    CGSize calculatedSize =  [string boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    CGSize adjustedSize = CGSizeMake(ceilf(calculatedSize.width),calculatedSize.height + broadHeight);
    return adjustedSize;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
