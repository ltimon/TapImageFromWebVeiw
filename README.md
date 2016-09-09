# TapImageFromWebVeiw
在app展示web的时候，点击webView的图片，图片能弹出来展示,下图展示的是当时在浣玩具工作的时候的一个web页面，地址为[![浣玩具](http://www.mywabao.com/front/app/disinfection_process?src=iphone_client)]&nbsp;，可以先打开看看源码，本例子就是利用直接向webView注入js，来获取页面的DOM中的img元素，然后给img标签添加点击事件，再用webview来捕获点击事件，得到图片的url，用iOS原生的视图展示出来<br>
<img src="https://github.com/litong19930321/TapImageFromWebVeiw/blob/master/eg1.png" width="400">
