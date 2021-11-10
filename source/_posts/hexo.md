---
title: hexo+GitHub 搭建博客 1/119
date: 2021-11-09 18:36:45
---

## hexo+GitHub 搭建博客

基础环境：nodejs

_本文用使用示例是github，同样的操作也可用于gitee，但我在实际操作的过程中发现gitee需要实名手持身份证拍照审核，觉得麻烦随之放弃_


### 1, 新建仓库
github上新建代码仓库，用来存储博客

![githubNewKu.png](/images/githubNewKu.png "githubNew")

注意，项目名字使用 你的github名字加 <font color=red>.github.io</font> 后缀，比如我的GitHub名称是[liu-xiaoran](https://github.com/liu-xiaoran),n那么我的项目名字就是 liu-xiaoran.github.io 点击创建完成操作，注意不要勾选add Readme file 和其他选项，这个可以后续自行添加，空白的仓库库有助于git的第一次推送合并。


### 2, 配置博客访问
跳转到刚刚新建仓库首页，也厚点击上方菜单栏的<font color=pink>Settings</font>,再点击左边栏位的<font color=pink>Pages</font>, 填写对应的pages设置。

![setPage.png](/images/setPage.png "setPage")

Source 那里默认是 root, 点击选择Theme Chooser，选择一个主体，点击保存。
此时你通过填写的仓库名，如 liu-xiaoran.github.io 就可以访问到该博客地址。


### 3, 配置域名访问
配置域名访问和配置https的方式，打开你的域名解析控制台，如我的阿里云域名配置页面。
![DNS.png](/images/DNS.png "DNS")

配置CNAME，指向你的博客访问地址，如liu-xiaoran.github.io。

配置结束后，返回github的pages配置页面，填写上域名，自动生成CNAME文件，勾选启用https。保存后稍后即可使用域名访问博客。想使用GitHub自动博客功能的，到此处就可以结束了。

### 3, 安装使用hexo
打开终端输入

```npm i hexo-cli -g```

安装hexo, 拉取我们的github上的博客库，到本地。清空内部GitHub博客配置的文件。在文件夹内使用终端，输入

```hexo init```

初始化文件夹，接着使用 ``` npm i ``` 安装依赖。

这样hexo博客就配置好了，输入 ```hexo g``` 生成静态网页，然后输入 ```hexo s``` 打开本地服务器。可以写一个hello本地尝试一下。

### 4，配置GitHub默认路径
本地写完博文，推送到github时，发现通过域名访问的并不去hexo博客地址，怎么办？
仔细看我的步骤2里的红框内的，GitHub上的默认博客根目录是固定，只有几个值可以选择，这里选择一个自己喜欢的值，不是root,比如我选的 <font color=pink>docs</font> , 打开自己的hexo配置，_config.yml 将里面的public_dir值改成和GitHub选择的值一致，比如我的都是 <font color=pink>docs</font> 。


![setpub.png](/images/setpub.png "setpub")

重新生成静态文件，删除不需要的旧的生成目录，重新提交github。再次通过域名访问，就能看到效果了。


### 5，主题配置和hexo深入配置

主题配置，想复用别人的主题很简单，以我使用的主题hexo-theme-matery为例，https://github.com/blinkfox/hexo-theme-matery 打开hexo-theme-matery项目地址，里面有详细的配置方式，其他开源主题可以自己搜索获得。由于hexo-theme-matery中文文档比较详细，这里就不再赘余了。

hexo的深入配置也可以参考 https://hexo.io/zh-cn/ 文档，根据自己的需求自定义配置。


到此，hexo+GitHub 搭建博客 算是完成了。










