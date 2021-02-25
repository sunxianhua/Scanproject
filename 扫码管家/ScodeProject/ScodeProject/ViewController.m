//
//  ViewController.m
//  ScodeProject
//
//  Created by 孙先华 on 2019/4/14.
//  Copyright © 2019年 سچچچچچچ. All rights reserved.
//

#import "ViewController.h"
#import "HttpTool.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "HomeItemModel.h"
#import "HomeWebViewController.h"

#import <MBProgressHUD.h>

#import "KDBPersistenceTool.h"
#import <SVProgressHUD.h>


NSString* const QikeychainService = @"com.qishare.ios.keychain";
@interface ViewController ()<NSXMLParserDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwdTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong,nonatomic) HomeModel *homeModel;

@property (weak, nonatomic) IBOutlet UIButton *UDIDButton;
@property (copy,nonatomic) NSString *htmlString;

@end

@implementation ViewController
- (IBAction)uuidAction:(id)sender {
    
    NSString *version= [UIDevice currentDevice].systemVersion;
    
    if(version.doubleValue >=9.0) {
        
        // 针对 9.0 以上的iOS系统进行处理
        NSURL *URL = [NSURL URLWithString:@"https://www.pgyer.com/udid"];
        [[UIApplication sharedApplication]openURL:URL options:@{} completionHandler:^(BOOL success) {
            
        }];

    }else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.pgyer.com/udid"]];
 
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.htmlString = @"";
    _loginButton.layer.cornerRadius = 5.0;
    _loginButton.layer.masksToBounds = YES;
    [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    _nameTF.text = [KDBPersistenceTool obtainStringWithKey:@"name"];
    _passwdTF.text = [KDBPersistenceTool obtainStringWithKey:@"pawd"];
    _codeTF.text   = [KDBPersistenceTool obtainStringWithKey:@"code"];
    _passwdTF.secureTextEntry = YES;
    
    _UDIDButton.layer.cornerRadius = 10.0;
    _UDIDButton.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (BOOL)checkInput{
    
    if (_nameTF.text.length == 0) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入用户名"];
        return false;
    }
    
    if (_passwdTF.text.length == 0) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
        return false;
    }
    
    if (_codeTF.text.length == 0) {
        
        [SVProgressHUD showInfoWithStatus:@"请输入对接码"];
        return false;
    }
    
    return YES;
}



// http://www.zhikesys.com/applogin.asmx/login?user=admin&duijiema=89873842&pwd=admin

- (void)loginAction{
    
    [self.view endEditing:YES];
    
    if (![self checkInput]) {
        return;
    }
    
    
    
    //存储
    [KDBPersistenceTool savePrefWithKey:@"name" stringValue:_nameTF.text];
    [KDBPersistenceTool savePrefWithKey:@"pawd" stringValue:_passwdTF.text];
    [KDBPersistenceTool savePrefWithKey:@"code" stringValue:_codeTF.text];
    
    
//    CFUUIDRef puuid = CFUUIDCreate(nil);
//    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
//    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
//    NSMutableString *tmpResult = result.mutableCopy;
//    // 去除“-”
//    NSRange range = [tmpResult rangeOfString:@"-"];
//    while (range.location != NSNotFound) {
//        [tmpResult deleteCharactersInRange:range];
//        range = [tmpResult rangeOfString:@"-"];
//    }
//    NSLog(@"UUID:%@----%@",tmpResult,result);
//
//
//    NSString *theUUID = @"";
//    NSError *keychainError = [QiKeychainItem queryKeychainWithService:QikeychainService account:@"uuid"];
//    if (keychainError.code == errSecSuccess) {
//        theUUID = [keychainError.userInfo valueForKey:NSLocalizedDescriptionKey];
//        NSLog(@"---%@",theUUID);
//    }else{
//
//        theUUID = tmpResult;
//        [QiKeychainItem saveKeychainWithService:QikeychainService account:@"uuid" password:tmpResult];
//    }
    
    
//    NSError *keychainError2 = [QiKeychainItem queryKeychainWithService:QikeychainService account:@"111"];
//    if (keychainError2.code == errSecSuccess) {
//        NSString *ddd = [keychainError2.userInfo valueForKey:NSLocalizedDescriptionKey];
//        NSLog(@"---%@",ddd);
//    }

    
    
    NSString *url = [NSString stringWithFormat:@"http://www.zhikesys.com/applogin.asmx/login?user=%@&duijiema=%@&pwd=%@",_nameTF.text,_codeTF.text,_passwdTF.text];
    
    NSString *newUrlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[HttpTool sharedJsonClient] requestJsonDataWithPath:newUrlString andBlock:^(id  _Nonnull data, NSError * _Nonnull error) {
        
        NSXMLParser *parser = (NSXMLParser *)data;
        parser.delegate = self;
        [parser parse];
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"登录失败"];
        }
        
    }];
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{
    NSString *dd = self.htmlString;
    NSString *contentString = [self.htmlString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"^" withString:@"\""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.htmlString = @"";
    
    self.homeModel = [HomeModel mj_objectWithKeyValues:contentString];
    int code = self.homeModel.code.intValue;
    NSLog(@"dddd----%@",self.homeModel.code);
    NSString *remindString = @"";
    switch (code) {
        case 2:
            remindString = @"对接码错误";
            break;
        case 3:
            remindString = @"用户名和密码错误";
            break;
        case 4:
            remindString = @"苹果UDID设置不正确";
            break;
        case 1:
            remindString = @"";
            break;
        default:
            remindString = @"登录失效";
            break;
    }
    
    
    if (remindString.length > 0) {
        [SVProgressHUD showErrorWithStatus:remindString];
        return;
    }
    
    
    //进入主页
    HomeWebViewController *webViewVC = [HomeWebViewController new];
    self.homeModel.code = self.codeTF.text;
    webViewVC.homeModel = self.homeModel;
    UIApplication.sharedApplication.keyWindow.rootViewController = [[UINavigationController alloc]initWithRootViewController:webViewVC];
    
    
    NSLog(@"ddd");
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    _htmlString = [_htmlString stringByAppendingString:string];
  

}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

@end

