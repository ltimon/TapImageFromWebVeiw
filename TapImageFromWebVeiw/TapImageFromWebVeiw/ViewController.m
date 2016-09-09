//
//  ViewController.m
//  TapImageFromWebVeiw
//
//  Created by 李曈 on 16/9/9.
//  Copyright © 2016年 lt. All rights reserved.
//

#import "ViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self starLoadHtml];
    [self performSelector:@selector(js) withObject:nil afterDelay:5.0];
}
-(void)js{
  
}
/**
 *  开始加载网页信息
 */
-(void)starLoadHtml{
    NSURL * urlStr = [NSURL URLWithString:@"http://www.mywabao.com/front/app/disinfection_process?src=iphone_client"];
    NSURLRequest * request = [NSURLRequest requestWithURL:urlStr];
    [_webView loadRequest:request];
}
#pragma mark -UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //把请求转化为str
    NSString * requestStr = [[request URL] absoluteString];
    if ([requestStr hasPrefix:@"picclick:"]) {
        NSString * picSrc = [requestStr substringFromIndex:@"picclick:".length];
        NSLog(@"%@",picSrc);
        [self showSelectPic:picSrc];
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //当加载完成的时候 注入JS
    //document.location相当于让webview发送一个请求，为了让webview捕获事件
    static NSString * const jsCode = @"function  getPics(){\
    var pics = document.getElementsByTagName('img');\
    for(var i = 0; i < pics.length; i++){\
    var pic = pics[i];\
    pic.onclick = function () {\
    document.location = 'picClick:' + this.src;\
    }\
    }\
    }";
    //先把方法注入js
    [_webView stringByEvaluatingJavaScriptFromString:jsCode];
    //再主动调用 getPics()方法
    [_webView stringByEvaluatingJavaScriptFromString:@"getPics()"];

}
/**
 *  显示所选中的图片的大图
 *
 *  @param picUrl 图片的urlStr
 */
-(void)showSelectPic:(NSString *)picUrl{
    NSURL * url = [NSURL URLWithString:picUrl];
    UIImageView * imageView = [UIImageView new];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 40, 200);
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage * image = [UIImage imageWithData:data];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
            });
        }

    });
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    
}

@end
