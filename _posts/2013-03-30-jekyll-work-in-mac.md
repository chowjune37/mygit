---
layout: post
title: 在Mac下搭建GitHub Pages环境
---

记录自己在mac环境下搭建jekyll所遇到的问题。

但凡来到这个页面的人，都应该知道github page 跟 jekyll的吧，如果不知道，请猛击[这里](http://www.ruanyifeng.com/blog/2012/08/blogging_with_jekyll.html)！

了解完以后，就开始吧：）
一般来说，直接按上网上的教程，先把内容提交到github，然后就可以在username.github.com/project_name当中浏览了，这一步应该没什么难度：

* 申请一个github账号；
* 在本地搭建好github环境；
* 在本地配置好github pages仓库；
* push本地的github pages仓库；
* 大概十分钟后，在浏览器打开github_username.github.com/project_name即可；

但如果需要在本地先预览github pages的话，就需要再额外处理一些东西，比如ruby、jekyll之类的。在网上搜一圈，大把的教程，然后我也按着教程来做。
在本地搭建jekyll环境的第一步：在终端下输入：


	$ gem install jekyll


然后大把的教程都会跟你说这样就可以了。但是，我很怀疑写那些教程的人，有没有正式搭建过样的环境！我TM就不信只有我一个人遇到这些问题的：

* gem、ruby版本的问题
* 安装rvm的时候需要翻墙，翻墙完成后，安装rvm还是出错了
* 在执行jekyll --server的时候，也出错了

好吧，我承认是自己人品的问题。但问题来了，还是要解决的，解决完成后，还是要记录的：

#### gem版本的问题
一般来说，mac下已经安装有gem的。如果没有的话，可以在网上搜索一下怎么安装。举个例子：


	// 查看gem的版本
	$ gem -v
	// 如果不是最新的（截止2013-03-31，最新版本是2.0.3），请更新最新版本
	$ gem update --system


#### ruby版本问题
应该说是ruby的问题最麻烦，因为在升级ruby的时候，我参照网上的方法，用rvm来管理。举个例子：


	// 安装rvm
	$ curl -L get.rvm.io | bash -s stable
	// 执行根目录下的baserc文件
	$ source ~/.bashrc
	// 执行根目录下的base_profile文件
	$ source ~/.bash_profile
	// 查看有哪些版本的ruby可以更新
	$ rvm list known
	// 安装某一个版本的ruby，比如我现在即将要装的2.0.0
	$ rvm install ruby-2.0.0


事情进行到这一步，按理来说，应该会按照教程那样，完美到结局的，但是！！！！！！我在安装ruby的时候，竟然被墙了！！！是的，通过rvm安装ruby的时候，竟然被墙了！

好吧，竟然被墙，那就只能翻墙来解决了，通过google找到了ruby的[淘宝镜像服务器](http://ruby.taobao.org)，怎么使用呢：


	$ gem sources --remove https://rubygems.org/
	$ gem sources -a http://ruby.taobao.org/
	$ gem sources -l


按照上面的修改，确保最后输出http://ruby.taobao.com的时候，表示您的电脑在安装ruby的时候，会去taobao那里下载源码来安装。

然后，继续执行刚才的ruby安装命令：


	$ rvm install ruby-2.0.0


当按敲完上面的命令按回车后，我感觉我的心终于松了一口气。但TM的，就在个时候竟然出错了，大概是这样的提示：


	Missing required packages: pkgconfig, libxslt, libksba.
	Cowardly refusing to continue, please read 'rvm autolibs'.
	There were package installation errors, make sure to read the log.


WTF！大家都没有出错，偏偏我在更新的时候出错了，好吧。看了提示，提到了rvm autolibs，那就继续google之，终于在v2ex社区当中找到相应的解决方法：


	$ rvm install ruby-2.0.0 --autolibs=enabled


OK，ruby升级成功！接下来，应该就是安装jekyll的时候：


	$ sudo gem install jekyll


YES!没有任何错误，顺利安装成功（BTW，在安装jekyll的时候，可能会附带安装一些额外的东西）！那继续跟着网上的教程走下一下：


	$ cd github pages的项目路径
	$ jekyll --server


这个时候，一般都不会有出错的，一般来说，都会出现类似这样的成功信息：


	Building site: . -> ./_site
	Successfully generated site: . -> ./_site


但，我不得不怀疑我的人品，竟然当我输入jekyll --server的时候，竟然报错：jekyll unknown！！

我在home目录使用jekyll -v的时候却是没有任何问题，使用jekyll --server也是没问题的。

好吧，我大概猜到是因为在github pages项目下，没有相应的命令，说白了，就没有相应的环境变量。没办法，只好在根目录下，执行以下命令：


	$ vim .baserc
	//编辑.baserc文件，添加：
	alias jekyll=$HOME/.rvm/gems/ruby-2.0.0-p0/bin/jekyll


保存退出后，再回到github pages项目下，输入jekyll --server，终于提示成功创建_site文件夹了！！

经历了这么曲折，终于在本地创建好jekyll环境了。

但事情没有结束，因为每次在写博客的时候，如果需要预览，都需要停止jekyll，然后再次jekyll --server，这样才能把新修改的东西重新编译到_site这个文件夹里面，这个步骤让我感觉非常恶心。

所以，我现在在想办法，能不能在我每次修改完内容的时候，自动编译呢？

好吧，关于jekyll的东西，先折腾到这里，有时间再去解决那个自动编译的问题！