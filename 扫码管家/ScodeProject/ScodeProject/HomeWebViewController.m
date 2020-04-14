//
//  HomeWebViewController.m
//  ScodeProject
//
//  Created by 孙先华 on 2019/4/15.
//  Copyright © 2019年 سچچچچچچ. All rights reserved.
//

#import "HomeWebViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>
#import <MBProgressHUD.h>
#import <SVProgressHUD.h>

#import "KO_QRCodeScanController.h"

#import "UIButton+Tool.h"

@interface HomeWebViewController ()<WKNavigationDelegate,WKUIDelegate,KO_QRCodeScanControllerDelegate>


@property (nonatomic,assign) NSInteger currentIndex;
@property (strong ,nonatomic) WKWebView *webView;

@property (strong,nonatomic) UIButton *rightButton;

@property (strong, nonatomic) NSString *scanString;
@end

@implementation HomeWebViewController



- (WKWebView *)webView {
    
    if (_webView == nil) {
        
        _webView = [WKWebView new];
        [self.view addSubview:_webView];
        _webView.frame = self.view.frame;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    
    
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"切换岗位：";
    self.currentIndex = 0;
    
    _rightButton = [UIButton new];
    
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightButton setTitle:@"订单已打包" forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [_rightButton layoutButtonWithEdgeInsetsStyle:RightImageType imageTitleSpace:20.0];
    
    
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _rightButton.frame = CGRectMake(30.0, 0, 150.0, 30.0);
    [_rightButton addTarget:self action:@selector(selectedAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
    
    UIButton *scodeButton = [UIButton new];
    [scodeButton setTitle:@"扫描二维码" forState:UIControlStateNormal];
    [self.view addSubview:scodeButton];
    
    scodeButton.backgroundColor = UIColor.whiteColor;
    [scodeButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [scodeButton addTarget:self action:@selector(scodeAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.webView.backgroundColor = UIColor.whiteColor;
    

    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.top.mas_offset(0);
        make.bottom.mas_offset(-50.0);
    }];
    
    
    [scodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.webView.mas_bottom).mas_offset(0);
    }];
    
    //[self changeRequest];
    // Do any additional setup after loading the view.
}

- (void)scodeAction{

    //进入扫码界面
    KO_QRCodeScanController *vc = [[KO_QRCodeScanController alloc] init];
    vc.delegate = self;
    vc.QRScanDisplayStyle = KO_QRScanDisplayStyleOne;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)selectedAction{
    
    //弹出选择框
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger index = 0; index < self.homeModel.wordname.count; index++) {
        
        HomeItemModel *itemModel = self.homeModel.wordname[index];
        UIAlertAction *theAction = [UIAlertAction actionWithTitle:itemModel.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.currentIndex = index;
            
           // self.rightButton.frame = CGRectMake(0, 0, itemModel.name.length*20.0, 30.0);
            [self.rightButton setTitle:itemModel.name forState:UIControlStateNormal];
            
            [self changeRequest];
        }];
        
        [theAction setValue:[UIColor blackColor] forKey:@"titleTextColor"];
        [alertVc addAction:theAction];
    }
    
    //展示
    [self presentViewController:alertVc animated:YES completion:nil];
}




- (void)setHomeModel:(HomeModel *)homeModel{
    _homeModel = homeModel;
    

    [self changeRequest];
}

- (void)changeRequest{
    
    //http://www.zhikesys.com/ExecuteSqlSaotiaomaapp.aspx?duijiema=89873842&user=admin&tiaomabiaoshi=DB&wordname=订单已打包&ordernumber=扫码的内容
   // NSString *urlString = @"http://www.zhikesys.com/ExecuteSqlSaotiaomaapp.aspx?duijiema=89873842&user=admin&tiaomabiaoshi=DB&wordname=订单已打包";
    
    HomeItemModel *itemModel = _homeModel.wordname[_currentIndex];
    
    NSString *urlString =  [NSString stringWithFormat:@"http://www.zhikesys.com/ExecuteSqlSaotiaomaapp.aspx?duijiema=%@&user=%@&tiaomabiaoshi=%@&wordname=%@",_homeModel.code,_homeModel.username,itemModel.id,itemModel.name];
    
    if (self.scanString.length > 0) {
        
        urlString =  [NSString stringWithFormat:@"http://www.zhikesys.com/ExecuteSqlSaotiaomaapp.aspx?duijiema=%@&user=%@&tiaomabiaoshi=%@&wordname=%@&ordernumber=%@",_homeModel.code,_homeModel.username,itemModel.id,itemModel.name,self.scanString];
        
    }
    NSString *newUrlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:newUrlString]];
    [self.webView loadRequest:request];
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    [SVProgressHUD showWithStatus:@"加载中..."];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [SVProgressHUD dismiss];
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"加载失败"];
}


- (void)KO_QRCodeScanController:(KO_QRCodeScanController *)QRCodeScanController
           didFinishedReadingQR:(NSString *)string
{
    
    if (string.length == 0) {
        
        [SVProgressHUD showErrorWithStatus:@"扫码有误"];
        return;
    }
    
    self.scanString = string;
    [self changeRequest];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
