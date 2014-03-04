# TKBackgroundOperation
  
处理图片后台上传队列,图片大小处理,图片发送失败问题处理.
![Mou icon](http://kidswant.u.qiniudn.com/FmehLD_sfzJBWvbzVmqoCjH5KLK4)

## 疑问

- 为何微信朋友圈图片上传如此快?
- 为何qq私信界面发图如此快?
- 为何比较出名的IM软件发图如此快?
- 为何我开发的app发图就不能这么快?
- (是因为微信团队真的那么牛逼还是我们太菜?这里我将解密大家心中所有疑问)

## 前言

**tinkl**, is some of my experiences,hope that can help *ios  developers*.

**TKBackgroundOperation** uses ARC and requires iOS 7.0+.

It probably will work with iOS 6, I have not tried,but  it is not using any iOS7 specific APIs.
 
####  Installation

> just download zip file… &gt; and you can use it .

#### Links and Email

if you have some Question to ask me, you can contact email <nicolastinkl@gmail.com> link.
 

[id]: http://mouapp.com "Markdown editor on Mac OS X"



#### 正文
我:

- 我为何会开源分享?
 (看到太多初学者迷茫,和太多app需要优化,所以希望能给他们提供了点思路,如果人人都为开源出一份力,那中国IT界将更蓬勃发展. 技术是公司资产,微信 qq不可能开源告诉你怎么做,但是总有人去破)
- 我为何研究?  (兴趣爱好)


思路:

- 图片压缩算法?
- 图片二次封装?
- 网络优化的好?
- 通信协议牛x?

解决方式:

- 第一种: 如果简单对一张图片压缩处理, 你会想到几种方法?
(系统api UIImageJPEGRepresentation or UIImagePNGRepresentation) (对图片进行等比例裁剪)(对图片RGBA重构新图) more?
- 第二种:你对ios 图片了解多少?
1.  <http://www.cnblogs.com/smileEvday/archive/2013/05/14/UIImage.html>  聊一聊UIImage几点知识
2. <http://blog.csdn.net/justinjing0612/article/details/8751381>  CGImageRef 图片压缩 裁减
3.  <http://blog.csdn.net/justinjing0612/article/details/8751269>   iOS 图片压缩UIImage方法扩展


####  结束语
1. github 有那么多工具和开源项目,了解它,解剖它,弄懂它
2. 把这些工具组合在一起,才是最厉害的武器(tools)
3. 一定要快+稳,不要钻牛角尖,这不是读书时代.
4. 引用张小龙一句话:这只是我解决问题的其中一种方式,可能并非正确,但可以供你们参考取<b>交集</b>


####  Features

------------------------------------

1. 将支持pod拉取

#### Notes

--------

* Only tested with Xcode 5 on 10.8.5
* Hasn't been tested with other plugins 



#### Changelog



1.0 - 2014/02/04
----------

Initial release


