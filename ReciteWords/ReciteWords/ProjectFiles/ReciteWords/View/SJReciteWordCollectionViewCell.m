//
//  SJRecitrWordCollectionViewCell.m
//  ReciteWords
//
//  Created by summer的Dad on 2017/8/13.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import "SJReciteWordCollectionViewCell.h"
@interface SJReciteWordCollectionViewCell ()
@property (nonatomic,strong)UIView*        baseView;
@property (nonatomic,strong)UIView*        topView;
@property (nonatomic,strong)UIView*        centerView;
@property (nonatomic,strong)UIView*        buttomView;

@property (nonatomic,strong)UILabel*       wordLabel;

//英
@property (nonatomic,strong)UILabel*       britishTitleLabel;
@property (nonatomic,strong)UILabel*       britishLabel;
//美
@property (nonatomic,strong)UILabel*       usaTitleLabel;
@property (nonatomic,strong)UILabel*       usaLabel;

@property (nonatomic,strong)UITextView *     textView ;
@property (nonatomic,strong)UILabel*         meaningLabel;

@property (nonatomic,strong)UIButton*       playBtn;



@end

@implementation SJReciteWordCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
//        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.contentView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.baseView];
//    [self.baseView addSubview:self.topView];
//    [self.baseView addSubview:self.centerView];
//    [self.baseView addSubview:self.buttomView];
//    //内容
//    [self.topView addSubview:self.wordLabel];
//    [self.topView addSubview:self.britishTitleLabel];
//    [self.topView addSubview:self.britishLabel];
//    [self.topView addSubview:self.usaTitleLabel];
//    [self.topView addSubview:self.usaLabel];
//    [self.centerView addSubview:self.meaningLabel];
//    [self.centerView addSubview:self.textView];
//    //---buttom
//    [self.buttomView addSubview:self.playBtn];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView);
        make.right.equalTo(self.centerView);
        make.top.equalTo(self.centerView);
        make.bottom.equalTo(self.centerView);
    }];
//    CGFloat topHight = self.baseView.frame.size.height / 4;
//    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(self.baseView);
//        make.height.mas_equalTo(topHight);
//    }];
//    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.topView.mas_bottom);
//        make.left.right.equalTo(self.baseView);
//        make.height.mas_equalTo(topHight*2);
//    }];
//    [self.buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.centerView.mas_bottom);
//        make.left.bottom.right.equalTo(self.baseView);
//    }];
    //..
//    [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.topView);
//        make.left.mas_equalTo(AutoWith(32));
//    }];
//    [self.britishTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.topView.mas_centerX);
//        make.bottom.equalTo(self.wordLabel.mas_top);
//    }];
//    [self.britishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.britishTitleLabel.mas_right).offset(AutoWith(8));
//        make.centerY.equalTo(self.britishTitleLabel);
//    }];
//    [self.usaTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.britishTitleLabel);
//        make.top.equalTo(self.wordLabel.mas_bottom);
//    }];
//    [self.usaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.usaTitleLabel.mas_right).offset(8);
//        make.centerY.equalTo(self.usaTitleLabel);
//    }];
//    self.meaningLabel.text= @"1.asdfasdfsdf/n2.asdfasdffasdf/n3.asdfasdfas";
//    self.meaningLabel.numberOfLines = 0;
//    [self.meaningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.centerView.mas_left).offset(32);
//        make.top.equalTo(self.centerView.mas_top).offset(10);
//    }];
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.meaningLabel.mas_bottom);
//        make.left.equalTo(self.centerView).offset(AutoWith(20));
//        make.right.bottom.equalTo(self.centerView).offset(20);
//    }];
//    
//    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.buttomView);
//        make.left.equalTo(self.buttomView).offset(AutoWith(20));
//        make.width.height.mas_equalTo(50);
//    }];
    
}
- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = [UIColor redColor];
    }
    return _baseView;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
-(UIView *)contentView {
    if (!_centerView) {
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = [UIColor redColor];
    }
    return _centerView;
}
- (UIView *)buttomView {
    
    if (!_buttomView) {
        _buttomView = [[UIView alloc] init];
        _buttomView.backgroundColor = [UIColor redColor];
    }
    return _buttomView;
}
- (UILabel *)wordLabel{
    if (!_wordLabel) {
        _wordLabel = [UILabel labelWithFontSize:36 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
    }
    return _wordLabel;
}
- (UILabel *)britishTitleLabel {
    if (!_britishTitleLabel) {
        _britishTitleLabel = [UILabel labelWithFontSize:12 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
        _britishTitleLabel.text = @"英音";
    }
    return _britishTitleLabel;
}
- (UILabel *)britishLabel {
    if (!_britishLabel) {
        _britishLabel =[UILabel labelWithFontSize:12 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
        _britishLabel.text= @"/////////";
    }
    return _britishLabel;
}
-(UILabel *)usaTitleLabel{
    if (!_usaTitleLabel) {
        _usaTitleLabel = [UILabel labelWithFontSize:12 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
        _usaTitleLabel.text=@"美音";
    }
    return _usaTitleLabel;
}
- (UILabel *)usaLabel {
    if (!_usaLabel) {
        _usaLabel = [UILabel labelWithFontSize:12 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
        _usaLabel.text = @"2232323";
    }
    return _usaLabel;
}
- (UITextView *)textView {
    
    if (!_textView) {
        _textView= [[UITextView alloc] init];
    }
    return _textView;
}
- (UILabel *)meaningLabel {
    if (!_meaningLabel) {
        _meaningLabel = [UILabel labelWithFontSize:12 textColor:[UIColor blackColor] alignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor]];
        _meaningLabel.text=@"label";
    }
    
    return _meaningLabel;
}
- (UIButton *)playBtn {
    if(!_playBtn) {
        _playBtn = [UIButton buttonWithImageName:@"sj_word_audio" tag:1 target:self sel:@selector(clickPlayBtn:)];
        
    }
    return _playBtn;
}
- (void)clickPlayBtn:(UIButton*)btn {
    
    NSLog(@"播放");
    
}
@end
