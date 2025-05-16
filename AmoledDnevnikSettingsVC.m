#import "AmoledDnevnikSettingsVC.h"

#define kAmoledDnevnikEnabledKey @"AmoledDnevnikEnabled"
#define kAmoledDnevnikColorKey @"AmoledDnevnikColor"

extern BOOL AmoledDnevnikIsEnabled(void);
extern UIColor *AmoledDnevnikColor(void);
extern void AmoledDnevnikSetEnabled(BOOL enabled);
extern void AmoledDnevnikSetColor(UIColor *color);

@implementation AmoledDnevnikSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = @[ (__bridge id)[UIColor colorWithRed:0.902 green:0.698 blue:1.0 alpha:1.0].CGColor,   // #E6B2FF
                         (__bridge id)[UIColor colorWithRed:0.969 green:0.776 blue:1.0 alpha:1.0].CGColor,   // #F7C6FF
                         (__bridge id)[UIColor colorWithRed:0.820 green:0.639 blue:1.0 alpha:1.0].CGColor ]; // #D1A3FF
    gradient.startPoint = CGPointMake(0.5, 0.0);
    gradient.endPoint = CGPointMake(0.5, 1.0);
    gradient.locations = @[ @0.0, @0.5, @1.0 ];
    gradient.cornerRadius = 24;
    gradient.masksToBounds = YES;
    [self.view.layer insertSublayer:gradient atIndex:0];

    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.view.bounds;
    blurView.alpha = 0.18; // Subtle blur
    blurView.userInteractionEnabled = NO;
    [self.view insertSubview:blurView aboveSubview:self.view.subviews.firstObject];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gradient.needsDisplayOnBoundsChange = YES;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, 44)];
    title.text = @"AmoledDnevnik";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:32 weight:UIFontWeightHeavy];
    title.textColor = [UIColor whiteColor];
    title.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.25].CGColor;
    title.layer.shadowOffset = CGSizeMake(0, 2);
    title.layer.shadowRadius = 6;
    title.layer.shadowOpacity = 1;
    [self.view addSubview:title];

    UIView *switchCard = [[UIView alloc] initWithFrame:CGRectMake(28, 120, self.view.bounds.size.width-56, 70)];
    switchCard.backgroundColor = [UIColor clearColor];
    switchCard.layer.cornerRadius = 20;
    switchCard.layer.masksToBounds = NO;
    switchCard.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.18].CGColor;
    switchCard.layer.shadowOffset = CGSizeMake(0, 6);
    switchCard.layer.shadowRadius = 16;
    switchCard.layer.shadowOpacity = 1;
    UIVisualEffectView *switchBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterialLight]];
    switchBlur.frame = switchCard.bounds;
    switchBlur.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    switchBlur.alpha = 0.85;
    [switchCard addSubview:switchBlur];
    [self.view addSubview:switchCard];

    UISwitch *enableSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    enableSwitch.on = AmoledDnevnikIsEnabled();
    [enableSwitch addTarget:self action:@selector(toggleChanged:) forControlEvents:UIControlEventValueChanged];
    enableSwitch.center = CGPointMake(switchCard.bounds.size.width-55, switchCard.bounds.size.height/2);
    enableSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [switchCard addSubview:enableSwitch];

    UILabel *switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, switchCard.bounds.size.width-90, switchCard.bounds.size.height)];
    switchLabel.text = @"Включить твик";
    switchLabel.textAlignment = NSTextAlignmentLeft;
    switchLabel.textColor = [UIColor whiteColor];
    switchLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    switchLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [switchCard addSubview:switchLabel];

    UIView *colorCard = [[UIView alloc] initWithFrame:CGRectMake(28, 210, self.view.bounds.size.width-56, 260)];
    colorCard.backgroundColor = [UIColor clearColor];
    colorCard.layer.cornerRadius = 24;
    colorCard.layer.masksToBounds = NO;
    colorCard.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.18].CGColor;
    colorCard.layer.shadowOffset = CGSizeMake(0, 6);
    colorCard.layer.shadowRadius = 16;
    colorCard.layer.shadowOpacity = 1;
    UIVisualEffectView *colorBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterialLight]];
    colorBlur.frame = colorCard.bounds;
    colorBlur.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    colorBlur.alpha = 0.85;
    [colorCard addSubview:colorBlur];
    [self.view addSubview:colorCard];

    NSArray *colors = @[ [UIColor blackColor],
                         [UIColor colorWithWhite:0.1 alpha:1.0],
                         [UIColor colorWithRed:0 green:0 blue:0.3 alpha:1.0],
                         [UIColor colorWithRed:0.3 green:0.7 blue:1.0 alpha:1.0] ];
    NSArray *titles = @[ @"Чёрный", @"Тёмно-серый", @"Синий", @"Голубой" ];
    CGFloat btnY = 24;
    for (int i = 0; i < colors.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20, btnY, colorCard.bounds.size.width-40, 48);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.backgroundColor = [colors[i] colorWithAlphaComponent:0.85];
        btn.layer.cornerRadius = 14;
        btn.layer.masksToBounds = NO;
        btn.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.18].CGColor;
        btn.layer.shadowOffset = CGSizeMake(0, 4);
        btn.layer.shadowRadius = 8;
        btn.layer.shadowOpacity = 1;
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(colorBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [colorCard addSubview:btn];
        btnY += 56;
    }

    UIView *closeCard = [[UIView alloc] initWithFrame:CGRectMake(28, CGRectGetMaxY(colorCard.frame)+24, self.view.bounds.size.width-56, 70)];
    closeCard.backgroundColor = [UIColor clearColor];
    closeCard.layer.cornerRadius = 20;
    closeCard.layer.masksToBounds = NO;
    closeCard.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.18].CGColor;
    closeCard.layer.shadowOffset = CGSizeMake(0, 6);
    closeCard.layer.shadowRadius = 16;
    closeCard.layer.shadowOpacity = 1;
    UIVisualEffectView *closeBlur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterialLight]];
    closeBlur.frame = closeCard.bounds;
    closeBlur.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    closeBlur.alpha = 0.85;
    [closeCard addSubview:closeBlur];
    [self.view addSubview:closeCard];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(20, 14, closeCard.bounds.size.width-40, 42);
    [closeBtn setTitle:@"Закрыть" forState:UIControlStateNormal];
    closeBtn.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.85];
    closeBtn.layer.cornerRadius = 14;
    closeBtn.layer.masksToBounds = NO;
    closeBtn.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.18].CGColor;
    closeBtn.layer.shadowOffset = CGSizeMake(0, 4);
    closeBtn.layer.shadowRadius = 8;
    closeBtn.layer.shadowOpacity = 1;
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [closeCard addSubview:closeBtn];
}

- (void)toggleChanged:(UISwitch *)sender {
    AmoledDnevnikSetEnabled(sender.isOn);
}

- (void)colorBtnTapped:(UIButton *)sender {
    NSArray *colors = @[ [UIColor blackColor],
                         [UIColor colorWithWhite:0.1 alpha:1.0],
                         [UIColor colorWithRed:0 green:0 blue:0.3 alpha:1.0],
                         [UIColor colorWithRed:0.3 green:0.7 blue:1.0 alpha:1.0] ];
    AmoledDnevnikSetColor(colors[sender.tag]);
}

- (void)closeTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end 