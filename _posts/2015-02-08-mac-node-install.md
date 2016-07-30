---
layout: post
title: 记录在Mac下安装Node
---


### 安装

在[官网](http://nodejs.org/)那里下载最新的安装包，然后执行安装命令。
因为最新版的nodejs已经包含了npm，在安装到最后，会列出Node跟npm的安装路径的：

	// Node was install at
	/usr/local/bin/node
	// npm was install at
	/usr/local/bin/npm
	// node_modules was install at
	/usr/local/lib/node_modules

同时，需要确定的是```/usr/local/bin```这个路径需要在```$PATH```这个环境变量当中！

	// 在终端当中输入：
	echo $PATH
	// 然后会显示对应的路径，如果包含了/usr/local/bin则没问题，否则需要自己手动添加：
	sudo vi ~/.bashrc
	// 按i进入编辑模式，然后将下面的代码写入到.bashrc文件当中去
	export PATH=$PATH:$HOME

最后，还有一个更奇葩的问题需要在前期注意，就是在Mac下，默认使用的配置文件是```.bash_profile```，而我们Node的配置是在.bashrc里面的。所以，我们需要在```.bash_profile```里面添加如下代码：

	if [ -f ~/.bashrc ]; then
		source ~/.bashrc
	fi

这样的话，就可以在```.bashrc```里面随便配置其它软件的环境变量了！





### npm配置(以下配置，大部分来自[这里](http://www.cnblogs.com/huang0925/archive/2013/05/17/3083207.html))

#### npm获取配置有6种方式，优先级由高到底

1. 命令行参数：```--proxy http://server:port```即将proxy的值设为```http://server:port```；
2. 环境变量：以npm_config_为前缀的环境变量将会被认为是npm的配置属性。如设置proxy可以加入这样的环境变量```npm_config_proxy=http://server:port```；
3. 用户配置文件：可以通过```npm config get userconfig```查看文件路径。如果是mac系统的话默认路径就是```$HOME/.npmrc```；
4. 全局配置文件：可以通过```npm config get globalconfig```查看文件路径。mac系统的默认路径是```/usr/local/etc/npmrc```；
5. 内置配置文件：安装npm的目录下的npmrc文件；
6. 默认配置：npm本身有默认配置参数，如果以上5条都没设置，则npm会使用默认配置参数。

如果要查看npm的所有配置属性（包括默认配置），可以使用```npm config ls -l```
如果要查看npm的各种配置的含义，可以使用```npm help config```

#### 为npm设置代理

	npm config set proxy http://server:port
	npm config set https-proxy http://server:port

如果代理需要认证的话可以这样来设置

	npm config set proxy http://username:password@server:port
	npm config set https-proxy http://username:pawword@server:port

如果代理不支持https的话需要修改npm存放package的网站地址

	npm config set registry http://registry.npmjs.org/


如果是个人使用的话，基本上设置最后一条registry就可以了，我们也可以这样来修改：

	sudo vi ~/.npmrc
	registry=http://registry.npmjs.org


#### 推荐npm代理地址
大家如果觉得npm本身存放package的地址有点慢的时候，可以使用[淘宝的npm镜像地址](http://npm.taobao.org/)




### npm使用

	//安装nodejs的依赖包
	npm install <package name>
	// 安装指定版本
	npm install <package name>@3.0.6
	// 将包安装到全局环境中
	npm install -g <package name>
	// 全局删除
	npm uninstall -g  <package name>
	// 搜索
	npm search <package name>

	// 列出全局包.
	npm ls -g
	// 列出全局所有包的详细信息.
	npm ls -gl
	// 列出项目当中所有包.
	cd /path/to/the/project
	npm ls
	// 列出项目当中所有包的详细信息.
	cd /path/to/the/project
	npm ls -l
	// 更新全局包.
	npm update -g
	// 更新项目当中所有包.
	cd /path/to/the/project
	npm update



### 卸载
呵呵，Mac下安装的Node跟window下不一样！在window下可以在安装程序当中直接删除，但在Mac下却不行！
目前我也没有找到更快更好的方法，只能通过命令行的形式批量删除文件夹：

	还没有找到，不好意思



