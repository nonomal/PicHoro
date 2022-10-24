
<div align="center">
  <img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_05_633d79e401694.png" alt="">
  <h1>PicHoro</h1>
</div>

&emsp;&emsp;一款基于flutter的移动端图片上传和图床管理工具，最新版本**V1.8.0**，与PicGo配置互通，可直接扫码导入，主要功能包括上传，查看，删除图片和直接管理图床仓库，已支持如下图床：  

- [x] 兰空图床V2 (**V1.00版本添加**)
- [x] SM.MS(**V1.41版本添加**) 图床网站[https://smms.app](https://smms.app)或[https://sm.ms](https://sm.ms)
- [x] Github(**V1.55版本添加**) 使用Github仓库作为图床
- [x] Imgur(**V1.60版本添加**) Imgur国内用户需要配合翻墙使用，个人手机测试配合clash可以正常使用
- [x] 七牛云存储(**V1.65版本添加**) 七牛云存储
- [x] 腾讯云COS V5(**V1.70版本添加**) 腾讯云COS V5
- [x] 阿里云OSS(**V1.75版本添加**) 阿里云OSS
- [x] 又拍云存储(**V1.75版本添加**) 又拍云存储

&emsp;&emsp;个人开发用于学习flutter和替代很久没更新了的[flutter-Picgo](https://github.com/PicGo/flutter-picgo)。

@author: Horosama  
@website: [https://www.horosama.com](https://www.horosama.com)  
@email: ma_shiqing@163.com  

## 特色功能

- 连续上传模式，相机拍照后自动上传然后返回拍照页面，可连续拍照上传
- 可导入剪贴板中的网络图片链接，同时使用换行符分割多个链接可批量导入
- 上传图片后自动复制链接到剪贴板，多图上传时全部复制
- 支持自定义复制到剪贴板的链接格式，占位符与Picgo一致
- 上传时可对文件重命名，目前有时间戳，随机字符串和自定义重命名三种方式，自定义重命名可使用多种占位符，如uuid，时间戳，md5等
- 相册分图床显示，支持多选管理，复制多张图片链接或删除
- 相册删除时可选择是否同时删除服务器上的图片，以及选择是否删除本地图片
- **支持直接管理图床仓库，目前已实现对腾讯云COS的管理，相当于内置了一个精简版的腾讯COSbrowser**
- **支持扫描二维码将PicGo(v2.3.0-beta.2以上版本)配置文件直接导入PicHoro**
- 支持将PicHoro的配置导出至剪贴板，导出格式与PicGo配置文件相同，可直接导入PicGo

## 应用截图

<table rules="none">
  <tr>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_07_633f92429faf6.jpg" width="200" height="400" alt=""/></td>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_09_63428bdd8a02c.jpg" width="200" height="400" alt=""/></td>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_15_634a6308a7fe7.jpg" width="200" height="400" alt=""/></td>
  </tr>
   <tr>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_15_634a630aa7563.jpg" width="200" height="400" alt=""/></td>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_15_634a63099d33d.jpg" width="200" height="400" alt=""/></td>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_15_634a630b8b481.jpg" width="200" height="400" alt=""/></td>
  </tr>
   <tr>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_24_6356546fd78c6.jpg" width="200" height="400" alt=""/></td>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_24_6356546ee6731.jpg" width="200" height="400" alt=""/></td>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_24_6356548f45f14.jpg" width="200" height="400" alt=""/></td>
  </tr>
  <tr>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_24_6356546e1bc43.jpg" width="200" height="400" alt=""/></td>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_24_6356548e77bfb.jpg" width="200" height="400" alt=""/></td>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_24_6356546d138ff.jpg" width="200" height="400" alt=""/></td>
  </tr>
</table>

## 最近更新

  详细更新日志请查看[更新日志](https://github.com/Kuingsmile/PicHoro/blob/main/Version_update_log.md "更新日志")

- 2022-10-24: **V1.80**:

  - 增加了新的功能**图床仓库管理**，目前实现了对**腾讯云COS**的支持（*相当于内置了一个精简版的腾讯COSBrowser*)，后续会陆续增加对其他图床的支持，主要功能有：
      1. 查看存储桶列表，支持创建和删除，修改访问权限，设置存储桶为腾讯云COS的默认存储桶。
      2. 查看存储桶中的目录和文件列表，目录和文件都支持右滑删除，文件额外支持右滑分享连接。可新建文件夹，可设置目录为图床仓库的默认目录，文件可复制多种格式的链接，重命名，照片可以预览。
      3. 存储桶管理页面和本地下载目录浏览页面均可按修改时间，文件名，文件大小，文件类型等排序。
      4. 支持多选上传文件和照片，上传剪贴板内的网络链接。
      5. 可批量下载和管理已下载文件，支持暂停和继续下载，支持删除已下载文件。
      6. 支持管理本地下载目录，可重命名和删除已下载文件，支持预览照片和调用其它应用打开文件。
  - 修改了本地相册数据库的存储路径
  - 从剪贴板链接获取网络图片时，加入了对空文本的处理
  - 修改了部分字体，部分弹出框修改为ios样式
  - UI细节优化
  - 修复了图床api在请求失败时的错误处理
- 2022-10-17: **V1.76**:

  - 重写了路由管理，优化了路由跳转的体验，修改了跳转动画。
  - 主页/相册/设置页面现在不会左上角出现返回按钮，更加美观。
  - 优化了主页在深色主题下的显示效果
- 2022-10-15: **V1.75**:

  - 增加了对阿里云OSS的支持
  - 增加了对又拍云存储的支持
  - 增加了导出图床配置到剪贴板的功能，导出格式为json
  - 增加了从剪贴板中的图片链接直接获取图片的功能，并且可以通过换行符分隔多个图片链接来一次性获取多张图片
  - 增加了上传的时候自定义文件名的功能，使用`{Y}`、`{y}`、`{m}`、`{d}`、`{uuid}`、`{md5}`等占位符，可选年月日，uuid，md5，随机字符串等任意组合来自定义文件名。
  - 增加了手动清除缓存的功能
- 2022-10-14: **V1.70**:
  - 增加了对腾讯云COS的支持
  - 修改自定义链接格式的占位符为`$fileName`和`$url`，来和PicGo保持一致，同时修改了默认的自定义链接格式。
  - 修复了七牛云不设置存储路径的时候保存路径错误的问题。
  - 修复了github，imgur和七牛云导入二维码配置的时候可选参数默认值错误和七牛云数据库保存的数据错误的问题。
- 2022-10-13: **V1.65**:
  - 增加了对七牛云的支持（吐槽一下，七牛云这官方文档真的是emmmm）
  - 调整了配置和图片上传/删除的时候的响应和连接超时时间设置数值。
  - 相册图片的外框默认透明色，选中的时候会有一个红色的边框提示。
- 2022-10-12: **V1.60**:
  - 增加了对Imgur图床的支持，但是由于Imgur的限制，使用的时候需要配置手机代理，在个人手机上配合clash测试可用。
  - 加入了设置配置和图片上传/删除的时候的响应和连接超时时间设置，防止网络不好的情况下卡死。
  - 区分了相册显示的时候的图片地址和复制的时候的图片地址，改善相册加载图片的速度，例如兰空图床在相册小图中显示的是缩略图，预览大图的时候才会加载原图。
  - 修复了设置页面跳转到主页的时候，有时会先跳转到相册页面的问题
  - 修复了注册用户的时候，同步创建本地相册数据库的代码没有执行的bug
  - 修复了连续上传功能中，复制的链接的格式错误的bug
  - 更改了登录页面UI，方便区分出是否已经登录
- 2022-10-02: **V1.00**:
  - 项目初始化，完成基本的上传功能，目前仅支持兰空图床，需要手动授予存储和相机权限

## 下载

**安卓版**：

[https://www.horosama.com/self_apk/PicHoro_V1.8.0.apk](https://www.horosama.com/self_apk/PicHoro_V1.8.0.apk)

## 开发计划

- 增加图床管理功能，完成全部图床管理功能的实现后升至2.0版本，目前已支持管理:
  - [x] 腾讯云COS
- 增加对各种图床平台的,已完成对PicGo默认支持的7个图床和兰空图床的支持。-**已实现**
- 增加网络URL上传图片的功能-**已实现**
- 增加软件更新后保留本地配置的功能-**部分实现，APP内升级可以保留配置**
- 增加图床仓库管理的功能，增加从相册里删除图片的时候只删除数据库记录的功能-**已实现**
- 增加自定义复制的链接格式的功能-**已实现**
- 增加相册功能，可以查看已上传的图片并进行管理-**已实现**
- 增加上传时的设置功能，如是否修改文件名等-**已实现**
- 增加上传后复制链接到剪贴板的功能，同时可以再设置里选择链接的格式-**已实现**
- 增加主动获取权限的功能，避免用户手动授予权限-**已实现**
- 增加相册图片多选上传功能-**已实现**
- 增加拍照后自动上传功能-**已实现**
- 增加上传或者等待时的loading动画-**已实现**
- 增加主题切换功能-**已实现**

## License

MIT
