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
    gradient.colors = @[ (__bridge id)[UIColor colorWithRed:0.0 green:0.2 blue:0.7 alpha:1.0].CGColor,
                         (__bridge id)[UIColor colorWithRed:0.3 green:0.7 blue:1.0 alpha:1.0].CGColor,
                         (__bridge id)[UIColor colorWithWhite:0.5 alpha:1.0].CGColor ];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 1);
    [self.view.layer insertSublayer:gradient atIndex:0];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, 40)];
    title.text = @"AmoledDnevnik";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:28];
    title.textColor = [UIColor whiteColor];
    [self.view addSubview:title];

    UISwitch *enableSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-25, 120, 0, 0)];
    enableSwitch.on = AmoledDnevnikIsEnabled();
    [enableSwitch addTarget:self action:@selector(toggleChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:enableSwitch];

    UILabel *switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, self.view.bounds.size.width/2-30, 30)];
    switchLabel.text = @"Включить твик";
    switchLabel.textAlignment = NSTextAlignmentRight;
    switchLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:switchLabel];

    NSArray *colors = @[ [UIColor blackColor],
                         [UIColor colorWithWhite:0.1 alpha:1.0],
                         [UIColor colorWithRed:0 green:0 blue:0.3 alpha:1.0],
                         [UIColor colorWithRed:0.3 green:0.7 blue:1.0 alpha:1.0] ];
    NSArray *titles = @[ @"Чёрный", @"Тёмно-серый", @"Синий", @"Голубой" ];
    CGFloat y = 200;
    for (int i = 0; i < colors.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(40, y, self.view.bounds.size.width-80, 40);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.backgroundColor = [colors[i] colorWithAlphaComponent:0.7];
        btn.layer.cornerRadius = 8;
        btn.tag = i;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(colorBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        y += 50;
    }

    // Кнопка закрытия
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(self.view.bounds.size.width/2-60, y+20, 120, 40);
    [closeBtn setTitle:@"Закрыть" forState:UIControlStateNormal];
    closeBtn.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.7];
    closeBtn.layer.cornerRadius = 8;
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
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