---
layout: post
title: 谈谈手机抓取http请求的数据包
---

在window平台下做前端开发，大家都知道利用Fiddler来抓包的，其实利用Fiddler也可以抓取手机的HTTP数据包的，具体的来看看下面的方法：


### 设置Fiddler

1. 在PC机当中，打开Fiddler；
2. 在Fiddler的菜单栏当中，依次选择Tools --- Fiddler Options --- Connections；
3. 在条件2成立的情况下，选择《Fiddler listens on port》页面，并设置相应的端口号，比如8888；
4. 在条件3成立的情况下，然后勾选下面的：Allow remote computers to connect；

OK，以上步骤是设置Fiddler的，接下来，设置手机相应的Host即可以成功实现抓包了：)

同时，如果是利用Mac开发同学的话，可以尝试使用Charles这个软件进行手抓包：

### 设置Charles

1. 在Mac当中，打开Charles.app；
2. 在Charles的菜单栏当中，依次选择Proxy --- Proxy Settings
3. 在条件2成立的情况下，在《Proxies》面板下的HTTP Proxy模块设置相应的端口号，比如8888；
4. 在条件3成立的情况下，勾选HTTP Proxy里面的“Enable transparent HTTP proxying”；

OK，以上步骤是设置Charles的，接下来，设置手机相应的Host即可以成功实现抓包了：)