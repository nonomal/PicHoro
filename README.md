<div align="center">
  <img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_05_633d79e401694.png" alt="">
  <h1>PicHoro</h1>
</div>

&emsp;&emsp;一款基于flutter的手机端云存储平台/图床管理和文件上传/下载工具，最新版本**V1.8.6**，与PicGo配置互通，可直接扫码导入，主要功能包括云存储平台和图床平台的管理，文件上传和下载管理，以及各种格式的链接分享。

&emsp;&emsp;图片上传/相册功能已支持如下图床：

- [X] 兰空图床V2 (**V1.00版本添加**)
- [X] SM.MS(**V1.41版本添加**) 图床网站[https://smms.app](https://smms.app)或[https://sm.ms](https://sm.ms)
- [X] Github(**V1.55版本添加**) 使用Github仓库作为图床
- [X] Imgur(**V1.60版本添加**) Imgur国内用户需要配合翻墙使用，个人手机测试配合clash可以正常使用
- [X] 七牛云存储(**V1.65版本添加**) 七牛云存储
- [X] 腾讯云COS V5(**V1.70版本添加**) 腾讯云COS V5
- [X] 阿里云OSS(**V1.75版本添加**) 阿里云OSS
- [X] 又拍云存储(**V1.75版本添加**) 又拍云存储
  
&emsp;&emsp;云存储/图床管理功能已支持如下平台：

- [X] 腾讯云COS(**V1.80版本添加**)
- [X] SM.MS (**V1.81版本添加**)
- [X] 阿里云OSS (**V1.84版本添加**)
- [X] 又拍云存储 (**V1.85版本添加**)
- [X] 七牛云存储 (**V1.86版本添加**)
- 
&emsp;&emsp;个人开发用于学习flutter和替代很久没更新了的[flutter-Picgo](https://github.com/PicGo/flutter-picgo)。

@author: Kuingsmile
@website: [https://www.horosama.com](https://www.horosama.com)
@email: ma_shiqing@163.com

## 特色功能

- **支持直接管理云存储平台和图床，目前已实现对腾讯云COS/阿里云OSS和SM.MS的管理**
- **支持扫描二维码将PicGo(v2.3.0-beta.2以上版本)配置文件直接导入PicHoro**
- 连续上传模式，相机拍照后自动上传然后返回拍照页面，可连续拍照上传
- 可导入剪贴板中的网络图片链接，同时使用换行符分割多个链接可批量导入
- 上传图片后自动复制链接到剪贴板，多图上传时全部复制
- 支持自定义复制到剪贴板的链接格式，占位符与Picgo一致
- 上传时可对文件重命名，目前有时间戳，随机字符串和自定义重命名三种方式，自定义重命名可使用多种占位符，如uuid，时间戳，md5等
- 相册分图床显示，支持多选管理，复制多张图片链接或删除
- 支持将PicHoro的配置导出至剪贴板，导出格式与PicGo配置文件相同，可直接导入PicGo
- 可查看和导出软件日志，快捷查找问题和报告bug

## 应用截图

<table rules="none">
  <tr>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_28_635bdaa1381c4.jpg" width="200" height="400" alt=""/></td>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_28_635bdbc4b1817.jpg" width="200" height="400" alt=""/></td>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/11/2022_11_01_6360d77d9ffde.jpg" width="200" height="400" alt=""/></td>
  </tr>
   <tr>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_15_634a630aa7563.jpg" width="200" height="400" alt=""/></td>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_15_634a63099d33d.jpg" width="200" height="400" alt=""/></td>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/10/2022_10_15_634a630b8b481.jpg" width="200" height="400" alt=""/></td>
  </tr>
   <tr>
    <td><img src="http://imgx.horosama.com/admin_uploads/2022/11/2022_11_01_6360d77d9cfd4.jpg" width="200" height="400" alt=""/></td>
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

- 2022-11-08: **V1.86**:
  - 新增：图床仓库管理功能增加了对**七牛云**的支持
  - 新增：图床管理功能文件浏览新增了查看文件详情页，可查看文件的详细信息。
  - 新增：现在图床设置页面会自动填充已保存的配置信息，方便快速查看和更改配置。
  - 新增：阿里云新建文件夹时，加入了对文件夹名的预检查和处理，自动去除开头和结尾的'/'，避免创建失败。
  - 优化：修改了部分UI的表现使其更加美观。
  - 修复：修复了七牛云亚太首尔地区上传api路径错误的问题。
  - 修复：修复了七牛云删除云端文件时，如果路径设置为根目录，会导致删除失败的问题。
  - 修复：修复了阿里云OSS上传文件时，如果路径设置为根目录，会导致上传失败的问题。
  - 修复: 修复了管理功能浏览文件时，网络错误会导致界面卡在loading的问题。
  - 修复：修复了部分界面UI错误，修复了日志界面的一些显示问题。
- 2022-11-04: **V1.85**:
  - 新增：图床仓库管理功能增加了对**又拍云**的支持，需要单独登录一次又拍云的账号密码，实现了服务账号管理、存储桶管理到文件管理的完整支持。
  - 新增：重构了下载页面，现在同时显示上传和下载任务，并且现在重新进入上传/下载页面不会丢失任务了，并且现在可以单独删除任务了。
  - 优化：上传界面内用户未登录时，现在会提示用户登录后才能使用相关功能。
  - 优化：相册内删除图片时，如果云端删除失败，现在会提示用户并中止删除流程。
  - 优化：现在设置又拍云图床时，网站后缀不再是必选参数。
  - 优化：现在部分页面返回后会主动触发上级页面刷新，以保证数据的及时更新。
  - 优化: 目录内文件全部删除后现在正确显示空目录提示背景，而不是空白。
  - 优化：优化了注销登录的处理，现在会将所有用户设置重置为默认值。
  - 优化：修改了部分图标和文字，以及部分页面的布局。
  - 修复：修复了相册页面，来回切换图床会导致部分图床无法正常删除云端图片的问题。
  - 修复：修复了当图片路径中包含中文时，又拍云图床无法正常删除云端图片的问题。
  - 修复：修复了又拍云图床上传图片后，图片链接多了一个'/'的问题。
  - 修复：修复了未登录或者配置图床的时候，对应图床管理页面会卡住的问题。
  - 修复：修复了从剪贴板上传文件功能在部分情况下无法正常使用的问题。
  - 修复：修复了部分日志函数名记录错误的问题。
- 2022-11-01: **V1.84**:
  - 新增：图床仓库管理功能增加了对**阿里云**的支持。
  - 新增：修改了上传文件时重命名的逻辑，现在不会同步重命名本地文件了。**感谢@Yurzi的建议**。
  - 新增：自定义文件重命名现在增加了异常处理，并且由于重命名逻辑的修改，现在可以使用'/'来同步新建文件夹了。**感谢@Yurzi的建议**。
  - 新增：增加了异常错误的日志记录和查看功能，并支持导出为txt文件和同步复制到剪贴板。**感谢@Yurzi的建议**。
  - 新增：优化了用户注册时用户名和密码的输入规则，现在不强求必须是8位纯数字了，仅要求不包括空白字符，同时优化了不合法输入的提示信息。**感谢@chancat87的建议**。
  - 新增：增加了当用户密码不是8位纯数字时的加密和解密规则，已注册用户不受影响。
  - 新增：上传界面从网络链接获取图片时，加入了loading窗口提示，防止用户误以为程序卡死。
  - 优化：修改了部分窗口的提示语使其更加清晰。
  - 修复：修复了在图床管理界面，从剪贴板获取文件的时候，链接中带有?查询字符串时，无法正确获取文件名的问题。
  - 修复：修复了图床管理文件浏览界面，按文件大小排序时，排序结果不正确的问题。
- 2022-10-27: **V1.83**: *本次更新后重点将放在剩余6个图床的管理功能的添加上*
  - 新增：上传页面重新设计，将主要功能放在了浮动按钮上，主页面用来显示上传列表，避免上传照片比较多时，一直卡在没有进度提示的loading窗口，单张拍照和连续上传两个功能仍沿用旧的上传方式。
  - 新增：用户登录页面重新设计，现在分为注册/登录和已登录两个页面，同时已登录页面显示用户信息和全部图床配置信息，并可以拉取云端配置和注销登录。
  - 新增：相册页面现在在切换页面的时候，会保留当前的页面状态，包括页数，选中状态等，同时上传了新图片或者清空了相册数据库后会自动触发相册刷新。
  - 新增：系统状态栏颜色调整为透明色，同时优化了部分页面APPBar的显示效果。
  - 优化：腾讯云COS二级页面的文件底部弹出栏，显示文件名时不会再显示目录前缀了。
  - 优化：部分文本显示现在可以被复制。
  - 修复：图床存储路径为一串空白字符时会导致上传错误的问题。
  - 修复：Github图床相册预览无法显示照片的问题和复制的url无法直接显示的问题。
- 2022-10-27: **V1.82**:
  - 新增：上传页面默的认图床切换列表现在会使用不同的颜色来区分当前的默认图床。
  - 优化：弹出框统一为Cupertino样式。
  - 优化: 网络图片预览加入了加载中和加载失败的状态管理。
  - 优化：重命名了大部分代码文件和部分变量名，使其符合dart命名规范。
  - 优化：解决了绝大部分代码格式不规范问题，共计约450处。
  - 优化：优化了代码结构，提取出了一些公共方法，精简了代码量，共减少约2000行代码。
  - 修复：清空相册数据库页面，弹出框点击确认后，弹出框不会消失的问题。
- 2022-10-02: **V1.00**:
  - 项目初始化，完成基本的上传功能，目前仅支持兰空图床，需要手动授予存储和相机权限

## 下载

**安卓版**：

[https://www.horosama.com/self_apk/PicHoro_V1.8.6.apk](https://www.horosama.com/self_apk/PicHoro_V1.8.6.apk)

## 开发计划

- 增加图床管理功能，完成全部图床管理功能的实现后升至2.0版本，目前已支持管理:
  - [X] 腾讯云COS
  - [X] SM.MS
  - [X] 阿里云OSS
  - [X] 又拍云存储
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

[MIT](https://opensource.org/licenses/MIT)

Copyright (c) 2022 Kuingsmile
