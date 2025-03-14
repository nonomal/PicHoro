import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as flutter_services;

import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as my_path;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'package:horopic/router/application.dart';
import 'package:horopic/router/routers.dart';
import 'package:horopic/picture_host_manage/manage_api/alist_manage_api.dart';

import 'package:horopic/picture_host_manage/common/loading_state.dart' as loading_state;
import 'package:horopic/utils/global.dart';
import 'package:horopic/utils/common_functions.dart';
import 'package:horopic/widgets/net_loading_dialog.dart';
import 'package:horopic/utils/image_compressor.dart';

bool isCoverFile = false;

class AlistFileExplorer extends StatefulWidget {
  final Map element;
  final String bucketPrefix;
  final String refresh;
  const AlistFileExplorer({super.key, required this.element, required this.bucketPrefix, required this.refresh});

  @override
  AlistFileExplorerState createState() => AlistFileExplorerState();
}

class AlistFileExplorerState extends loading_state.BaseLoadingPageState<AlistFileExplorer> {
  List fileAllInfoList = [];
  List dirAllInfoList = [];
  List allInfoList = [];

  List selectedFilesBool = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);
  TextEditingController vc = TextEditingController();
  TextEditingController newFolder = TextEditingController();
  TextEditingController fileLink = TextEditingController();
  bool sorted = true;

  @override
  void initState() {
    super.initState();
    fileAllInfoList.clear();
    _getBucketList();
  }

  _getBucketList() async {
    var res2 = await AlistManageAPI.listFolder(
      widget.bucketPrefix,
      widget.refresh,
    );

    if (res2[0] != 'success') {
      if (mounted) {
        setState(() {
          state = loading_state.LoadState.error;
        });
      }
      return;
    }

    var files = [];
    var dir = [];
    files.clear();
    dir.clear();
    for (var i = 0; i < res2[1].length; i++) {
      if (res2[1][i]['is_dir'] == false) {
        files.add(res2[1][i]);
      } else {
        dir.add(res2[1][i]);
      }
    }

    if (files.isNotEmpty) {
      fileAllInfoList.clear();
      for (var element in files) {
        fileAllInfoList.add(element);
      }
      for (var i = 0; i < fileAllInfoList.length; i++) {
        fileAllInfoList[i]['modified'] = DateTime.parse(
          fileAllInfoList[i]['modified'],
        );
      }
      fileAllInfoList.sort((a, b) {
        return b['modified'].compareTo(a['modified']);
      });
    } else {
      fileAllInfoList.clear();
    }

    if (dir.isNotEmpty) {
      dirAllInfoList.clear();
      for (var element in dir) {
        dirAllInfoList.add(element);
      }
    } else {
      dirAllInfoList.clear();
    }

    allInfoList.clear();
    allInfoList.addAll(dirAllInfoList);
    allInfoList.addAll(fileAllInfoList);
    if (allInfoList.isEmpty) {
      if (mounted) {
        setState(() {
          state = loading_state.LoadState.empty;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          selectedFilesBool.clear();
          for (var i = 0; i < allInfoList.length; i++) {
            selectedFilesBool.add(false);
          }
          state = loading_state.LoadState.success;
        });
      }
    }
  }

  _onrefresh() async {
    _getBucketList();
    refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Text(
            widget.bucketPrefix == '/'
                ? '根目录'
                : widget.bucketPrefix.substring(0, widget.bucketPrefix.length - 1).split('/').last,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            )),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withAlpha(204)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.sort,
              color: Colors.white,
              size: 25,
            ),
            position: PopupMenuPosition.under,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: const Center(
                      child: Text(
                    '修改时间排序',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  )),
                  onTap: () {
                    if (sorted == true) {
                      if (dirAllInfoList.isEmpty) {
                        allInfoList.sort((a, b) {
                          return b['modified'].compareTo(a['modified']);
                        });
                      } else {
                        List temp = allInfoList.sublist(dirAllInfoList.length, allInfoList.length);
                        temp.sort((a, b) {
                          return b['modified'].compareTo(a['modified']);
                        });
                        allInfoList.clear();
                        allInfoList.addAll(dirAllInfoList);
                        allInfoList.addAll(temp);
                      }
                      setState(() {
                        sorted = false;
                      });
                    } else {
                      if (dirAllInfoList.isEmpty) {
                        allInfoList.sort((a, b) {
                          return a['modified'].compareTo(b['modified']);
                        });
                      } else {
                        List temp = allInfoList.sublist(dirAllInfoList.length, allInfoList.length);
                        temp.sort((a, b) {
                          return a['modified'].compareTo(b['modified']);
                        });
                        allInfoList.clear();
                        allInfoList.addAll(dirAllInfoList);
                        allInfoList.addAll(temp);
                      }
                      setState(() {
                        sorted = true;
                      });
                    }
                  },
                ),
                PopupMenuItem(
                  child: const Center(
                      child: Text(
                    '文件名称排序',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  )),
                  onTap: () {
                    if (sorted == true) {
                      if (dirAllInfoList.isEmpty) {
                        allInfoList.sort((a, b) {
                          return a['name'].compareTo(b['name']);
                        });
                      } else {
                        List temp = allInfoList.sublist(dirAllInfoList.length, allInfoList.length);
                        temp.sort((a, b) {
                          return a['name'].compareTo(b['name']);
                        });
                        allInfoList.clear();
                        allInfoList.addAll(dirAllInfoList);
                        allInfoList.addAll(temp);
                      }
                      setState(() {
                        sorted = false;
                      });
                    } else {
                      if (dirAllInfoList.isEmpty) {
                        allInfoList.sort((a, b) {
                          return b['name'].compareTo(a['name']);
                        });
                      } else {
                        List temp = allInfoList.sublist(dirAllInfoList.length, allInfoList.length);
                        temp.sort((a, b) {
                          return b['name'].compareTo(a['name']);
                        });
                        allInfoList.clear();
                        allInfoList.addAll(dirAllInfoList);
                        allInfoList.addAll(temp);
                      }
                      setState(() {
                        sorted = true;
                      });
                    }
                  },
                ),
                PopupMenuItem(
                  child: const Center(
                      child: Text(
                    '文件大小排序',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  )),
                  onTap: () {
                    if (sorted == true) {
                      if (dirAllInfoList.isEmpty) {
                        allInfoList.sort((a, b) {
                          return a['size'].compareTo(b['size']);
                        });
                      } else {
                        List temp = allInfoList.sublist(dirAllInfoList.length, allInfoList.length);
                        temp.sort((a, b) {
                          return a['size'].compareTo(b['size']);
                        });
                        allInfoList.clear();
                        allInfoList.addAll(dirAllInfoList);
                        allInfoList.addAll(temp);
                      }
                      setState(() {
                        sorted = false;
                      });
                    } else {
                      if (dirAllInfoList.isEmpty) {
                        allInfoList.sort((a, b) {
                          return b['size'].compareTo(a['size']);
                        });
                      } else {
                        List temp = allInfoList.sublist(dirAllInfoList.length, allInfoList.length);
                        temp.sort((a, b) {
                          return b['size'].compareTo(a['size']);
                        });
                        allInfoList.clear();
                        allInfoList.addAll(dirAllInfoList);
                        allInfoList.addAll(temp);
                      }
                      setState(() {
                        sorted = true;
                      });
                    }
                  },
                ),
                PopupMenuItem(
                  child: const Center(
                      child: Text(
                    '文件类型排序',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  )),
                  onTap: () {
                    if (sorted == true) {
                      if (dirAllInfoList.isEmpty) {
                        allInfoList.sort((a, b) {
                          String type = a['name'].split('.').last;
                          String type2 = b['name'].split('.').last;
                          if (type.isEmpty) {
                            return 1;
                          } else if (type2.isEmpty) {
                            return -1;
                          } else {
                            return type.compareTo(type2);
                          }
                        });
                      } else {
                        List temp = allInfoList.sublist(dirAllInfoList.length, allInfoList.length);
                        temp.sort((a, b) {
                          String type = a['name'].split('.').last;
                          String type2 = b['name'].split('.').last;
                          if (type.isEmpty) {
                            return 1;
                          } else if (type2.isEmpty) {
                            return -1;
                          } else {
                            return type.compareTo(type2);
                          }
                        });
                        allInfoList.clear();
                        allInfoList.addAll(dirAllInfoList);
                        allInfoList.addAll(temp);
                      }
                      setState(() {
                        sorted = false;
                      });
                    } else {
                      if (dirAllInfoList.isEmpty) {
                        allInfoList.sort((a, b) {
                          String type = a['name'].split('.').last;
                          String type2 = b['name'].split('.').last;
                          if (type.isEmpty) {
                            return -1;
                          } else if (type2.isEmpty) {
                            return 1;
                          } else {
                            return type2.compareTo(type);
                          }
                        });
                      } else {
                        List temp = allInfoList.sublist(dirAllInfoList.length, allInfoList.length);
                        temp.sort((a, b) {
                          String type = a['name'].split('.').last;
                          String type2 = b['name'].split('.').last;
                          if (type.isEmpty) {
                            return -1;
                          } else if (type2.isEmpty) {
                            return 1;
                          } else {
                            return type2.compareTo(type);
                          }
                        });
                        allInfoList.clear();
                        allInfoList.addAll(dirAllInfoList);
                        allInfoList.addAll(temp);
                      }
                      setState(() {
                        sorted = true;
                      });
                    }
                  },
                ),
              ];
            },
          ),
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return SafeArea(
                          child: Wrap(
                        children: [
                          ListTile(
                            minLeadingWidth: 0,
                            leading: const Icon(Icons.file_present_outlined, color: Colors.blue),
                            title: const Text('上传文件(可多选)'),
                            onTap: () async {
                              Navigator.pop(context);
                              FilePickerResult? pickresult = await FilePicker.platform.pickFiles(
                                allowMultiple: true,
                              );
                              if (pickresult == null) {
                                showToast('未选择文件');
                              } else {
                                List<File> files = pickresult.paths.map((path) => File(path!)).toList();
                                Map configMap = await AlistManageAPI.getConfigMap();
                                configMap['uploadPath'] = widget.bucketPrefix == "/" ? "None" : widget.bucketPrefix;
                                for (int i = 0; i < files.length; i++) {
                                  File compressedFile;
                                  if (Global.imgExt
                                      .contains(my_path.extension(files[i].path).toLowerCase().substring(1))) {
                                    if (Global.isCompress == true) {
                                      ImageCompressor imageCompress = ImageCompressor();
                                      compressedFile = await imageCompress.compressAndGetFile(
                                          files[i].path, my_path.basename(files[i].path), Global.defaultCompressFormat,
                                          minHeight: Global.minHeight,
                                          minWidth: Global.minWidth,
                                          quality: Global.quality);
                                      files[i] = compressedFile;
                                    } else {
                                      compressedFile = files[i];
                                    }
                                  }
                                  List uploadList = [files[i].path, my_path.basename(files[i].path), configMap];
                                  String uploadListStr = jsonEncode(uploadList);
                                  Global.alistUploadList.add(uploadListStr);
                                }
                                Global.setAlistUploadList(Global.alistUploadList);
                                String downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
                                    ExternalPath.DIRECTORY_DOWNLOAD);
                                if (mounted) {
                                  Application.router
                                      .navigateTo(context,
                                          '/baseUpDownloadManagePage?bucketName=${Uri.encodeComponent('Alist_${widget.element['mount_path'].split('/').last}')}&downloadPath=${Uri.encodeComponent(downloadPath)}&tabIndex=0&currentListIndex=0',
                                          transition: TransitionType.inFromRight)
                                      .then((value) {
                                    _getBucketList();
                                  });
                                }
                              }
                            },
                          ),
                          ListTile(
                            minLeadingWidth: 0,
                            leading: const Icon(Icons.image_outlined, color: Colors.blue),
                            title: const Text('上传照片(可多选)'),
                            onTap: () async {
                              Navigator.pop(context);
                              AssetPickerConfig config = const AssetPickerConfig(
                                maxAssets: 100,
                                selectedAssets: [],
                              );
                              final List<AssetEntity>? pickedImage =
                                  await AssetPicker.pickAssets(context, pickerConfig: config);

                              if (pickedImage == null) {
                                showToast('未选择照片');
                              } else {
                                List<File> files = [];
                                for (var i = 0; i < pickedImage.length; i++) {
                                  File? fileImage = await pickedImage[i].originFile;
                                  if (fileImage != null) {
                                    files.add(fileImage);
                                  }
                                }
                                Map configMap = await AlistManageAPI.getConfigMap();
                                configMap['uploadPath'] = widget.bucketPrefix == "/" ? "None" : widget.bucketPrefix;
                                for (int i = 0; i < files.length; i++) {
                                  File compressedFile;
                                  if (Global.isCompress == true) {
                                    ImageCompressor imageCompress = ImageCompressor();
                                    compressedFile = await imageCompress.compressAndGetFile(
                                        files[i].path, my_path.basename(files[i].path), Global.defaultCompressFormat,
                                        minHeight: Global.minHeight,
                                        minWidth: Global.minWidth,
                                        quality: Global.quality);
                                    files[i] = compressedFile;
                                  } else {
                                    compressedFile = files[i];
                                  }
                                  List uploadList = [files[i].path, my_path.basename(files[i].path), configMap];
                                  String uploadListStr = jsonEncode(uploadList);
                                  Global.alistUploadList.add(uploadListStr);
                                }
                                Global.setAlistUploadList(Global.alistUploadList);
                                String downloadPath = await ExternalPath.getExternalStoragePublicDirectory(
                                    ExternalPath.DIRECTORY_DOWNLOAD);
                                if (mounted) {
                                  Application.router
                                      .navigateTo(context,
                                          '/baseUpDownloadManagePage?bucketName=${Uri.encodeComponent('Alist_${widget.element['mount_path'].split('/').last}')}&downloadPath=${Uri.encodeComponent(downloadPath)}&tabIndex=0&currentListIndex=0',
                                          transition: TransitionType.inFromRight)
                                      .then((value) {
                                    _getBucketList();
                                  });
                                }
                              }
                            },
                          ),
                          ListTile(
                            minLeadingWidth: 0,
                            leading: const Icon(Icons.link, color: Colors.blue),
                            title: const Text('上传剪贴板内链接(换行分隔多个)'),
                            onTap: () async {
                              Navigator.pop(context);
                              var url = await flutter_services.Clipboard.getData('text/plain');
                              if (url == null || url.text == null || url.text!.isEmpty) {
                                if (mounted) {
                                  showToastWithContext(context, "剪贴板为空");
                                }
                                return;
                              }
                              try {
                                String urlStr = url.text!;
                                List fileLinkList = urlStr.split("\n");
                                if (context.mounted) {
                                  await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return NetLoadingDialog(
                                          outsideDismiss: false,
                                          loading: true,
                                          loadingText: "上传中...",
                                          requestCallBack: AlistManageAPI.uploadNetworkFileEntry(
                                              fileLinkList, widget.bucketPrefix == "/" ? "None" : widget.bucketPrefix),
                                        );
                                      });
                                }
                                _getBucketList();
                              } catch (e) {
                                flogErr(
                                    e,
                                    {
                                      'url': url.text,
                                    },
                                    'AlistManagePage',
                                    'uploadNetworkFileEntry');
                                if (mounted) {
                                  showToastWithContext(context, "错误");
                                }
                                return;
                              }
                            },
                          ),
                          ListTile(
                            minLeadingWidth: 0,
                            leading: const Icon(
                              Icons.folder_open_outlined,
                              color: Colors.blue,
                            ),
                            title: const Text('新建文件夹'),
                            onTap: () async {
                              Navigator.pop(context);
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return NewFolderDialog(
                                      contentWidget: NewFolderDialogContent(
                                        title: "  请输入新文件夹名",
                                        okBtnTap: () async {
                                          String newName = newFolder.text;
                                          if (newName.isEmpty) {
                                            showToastWithContext(context, "文件夹名不能为空");
                                            return;
                                          }
                                          if (newName.startsWith('/')) {
                                            newName = newName.substring(1);
                                          }
                                          if (newName.endsWith('/')) {
                                            newName = newName.substring(0, newName.length - 1);
                                          }
                                          var copyResult = await AlistManageAPI.mkDir(widget.bucketPrefix + newName);
                                          if (copyResult[0] == 'success') {
                                            showToast('创建成功');
                                            _getBucketList();
                                          } else {
                                            showToast('创建失败');
                                          }
                                        },
                                        vc: newFolder,
                                        cancelBtnTap: () {},
                                      ),
                                    );
                                  });
                            },
                          ),
                        ],
                      ));
                    });
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              )),
          IconButton(
              onPressed: () async {
                String downloadPath =
                    await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOAD);
                int index = 1;
                if (Global.alistDownloadList.isEmpty) {
                  index = 0;
                }
                if (mounted) {
                  Application.router
                      .navigateTo(context,
                          '/baseUpDownloadManagePage?bucketName=${Uri.encodeComponent('Alist_${widget.element['mount_path'].split('/').last}')}&downloadPath=${Uri.encodeComponent(downloadPath)}&tabIndex=$index&currentListIndex=0',
                          transition: TransitionType.inFromRight)
                      .then((value) {
                    _getBucketList();
                  });
                }
              },
              icon: const Icon(
                Icons.import_export,
                color: Colors.white,
                size: 25,
              )),
          IconButton(
            icon: selectedFilesBool.contains(true)
                ? const Icon(Icons.delete, color: Color.fromARGB(255, 236, 127, 120), size: 30.0)
                : const Icon(Icons.delete_outline, color: Colors.white, size: 30.0),
            onPressed: () async {
              if (!selectedFilesBool.contains(true) || selectedFilesBool.isEmpty) {
                showToastWithContext(context, '没有选择文件');
                return;
              }
              return showCupertinoAlertDialogWithConfirmFunc(
                title: '删除全部文件',
                content: '是否删除全部选择的文件？\n请谨慎选择!',
                context: context,
                onConfirm: () async {
                  try {
                    List<int> toDelete = [];
                    for (int i = 0; i < allInfoList.length; i++) {
                      if (selectedFilesBool[i]) {
                        toDelete.add(i);
                      }
                    }
                    Navigator.pop(context);
                    await deleteAll(toDelete);
                    showToast('删除完成');
                    return;
                  } catch (e) {
                    flogErr(e, {}, 'AlistManagePage', 'deleteAll');
                    showToast('删除失败');
                  }
                },
              );
            },
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: buildStateWidget,
      floatingActionButtonLocation: state == loading_state.LoadState.error ||
              state == loading_state.LoadState.empty ||
              state == loading_state.LoadState.loading
          ? null
          : FloatingActionButtonLocation.centerFloat,
      floatingActionButton: state == loading_state.LoadState.error ||
              state == loading_state.LoadState.empty ||
              state == loading_state.LoadState.loading
          ? null
          : floatingActionButton,
    );
  }

  Widget get floatingActionButton => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 40,
              width: 40,
              child: FloatingActionButton(
                heroTag: 'download',
                backgroundColor:
                    selectedFilesBool.contains(true) ? const Color.fromARGB(255, 180, 236, 182) : Colors.transparent,
                onPressed: () async {
                  if (!selectedFilesBool.contains(true) || selectedFilesBool.isEmpty) {
                    showToastWithContext(context, '没有选择文件');
                    return;
                  }
                  List downloadList = [];
                  for (int i = 0; i < allInfoList.length; i++) {
                    if (selectedFilesBool[i] && i >= dirAllInfoList.length) {
                      downloadList.add(allInfoList[i]);
                    }
                  }
                  if (downloadList.isEmpty) {
                    showToast('没有选择文件');
                    return;
                  }
                  showToast('开始解析下载地址');
                  Map configMap = await AlistManageAPI.getConfigMap();
                  List<String> urlList = [];
                  String shareUrl = "";
                  for (int i = 0; i < downloadList.length; i++) {
                    var res = await AlistManageAPI.getFileInfo(
                      widget.bucketPrefix + downloadList[i]['name'],
                    );
                    if (res[0] == 'success') {
                      if (res[1]['raw_url'] != "" && res[1]['raw_url'] != null) {
                        shareUrl = res[1]['raw_url'];
                      } else {
                        shareUrl = '${configMap['host']}/d${widget.bucketPrefix}${downloadList[i]['name']}';
                        if (res[1]['sign'] != null && res[1]['sign'].isNotEmpty) {
                          shareUrl += '?sign=${res[1]['sign']}';
                        }
                      }
                    } else {
                      shareUrl = '${configMap['host']}/d${widget.bucketPrefix}${downloadList[i]['name']}';
                      if (downloadList[i]['sign'] != null && downloadList[i]['sign'].isNotEmpty) {
                        shareUrl += '?sign=${downloadList[i]['sign']}';
                      }
                    }
                    Map downloadMap = Map.from(widget.element);
                    List downloadKeys = downloadList[i].keys.toList();
                    for (int j = 0; j < downloadKeys.length; j++) {
                      downloadMap[downloadKeys[j]] = downloadList[i][j];
                    }
                    urlList.add(jsonEncode([
                      shareUrl,
                      downloadList[i]['name'],
                      downloadMap,
                    ]));
                  }
                  Global.alistDownloadList.addAll(urlList);
                  Global.setAlistDownloadList(Global.alistDownloadList);
                  String downloadPath =
                      await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOAD);
                  Application.router.navigateTo(context,
                      '/baseUpDownloadManagePage?bucketName=${Uri.encodeComponent('Alist_${widget.element['mount_path'].split('/').last}')}&downloadPath=${Uri.encodeComponent(downloadPath)}&tabIndex=1&currentListIndex=0',
                      transition: TransitionType.inFromRight);
                },
                child: const Icon(
                  Icons.download,
                  color: Colors.white,
                  size: 25,
                ),
              )),
          const SizedBox(width: 20),
          SizedBox(
              height: 40,
              width: 40,
              child: FloatingActionButton(
                heroTag: 'copy',
                backgroundColor:
                    selectedFilesBool.contains(true) ? const Color.fromARGB(255, 232, 177, 241) : Colors.transparent,
                elevation: 5,
                onPressed: () async {
                  if (!selectedFilesBool.contains(true)) {
                    showToastWithContext(context, '请先选择文件');
                    return;
                  } else {
                    Map configMap = await AlistManageAPI.getConfigMap();
                    List multiUrls = [];
                    for (int i = 0; i < allInfoList.length; i++) {
                      if (selectedFilesBool[i]) {
                        String finalFormatedurl = ' ';
                        String rawurl = '';
                        String fileName = '';
                        if (i < dirAllInfoList.length) {
                          rawurl = '${configMap['host']}${widget.bucketPrefix}${dirAllInfoList[i]['name']}';
                          fileName = allInfoList[i]['name'];
                        } else {
                          rawurl = '${configMap['host']}/d${widget.bucketPrefix}${allInfoList[i]['name']}';
                          if (allInfoList[i]['sign'] != null && allInfoList[i]['sign'].isNotEmpty) {
                            rawurl = '$rawurl?sign=${allInfoList[i]['sign']}';
                          }
                          fileName = allInfoList[i]['name'];
                        }
                        finalFormatedurl = getFormatedUrl(rawurl, fileName);
                        multiUrls.add(finalFormatedurl);
                      }
                    }
                    await flutter_services.Clipboard.setData(flutter_services.ClipboardData(
                        text: multiUrls
                            .toString()
                            .substring(1, multiUrls.toString().length - 1)
                            .replaceAll(', ', '\n')
                            .replaceAll(',', '\n')));
                    if (mounted) {
                      showToastWithContext(context, '已复制全部链接');
                    }
                  }
                },
                child: const Icon(
                  Icons.copy,
                  color: Colors.white,
                  size: 20,
                ),
              )),
          const SizedBox(width: 20),
          SizedBox(
              height: 40,
              width: 40,
              child: FloatingActionButton(
                heroTag: 'select',
                backgroundColor: const Color.fromARGB(255, 248, 196, 237),
                elevation: 50,
                onPressed: () async {
                  if (allInfoList.isEmpty) {
                    showToastWithContext(context, '目录为空');
                    return;
                  } else if (selectedFilesBool.contains(true)) {
                    setState(() {
                      for (int i = 0; i < selectedFilesBool.length; i++) {
                        selectedFilesBool[i] = false;
                      }
                    });
                  } else {
                    setState(() {
                      for (int i = 0; i < selectedFilesBool.length; i++) {
                        selectedFilesBool[i] = true;
                      }
                    });
                  }
                },
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 25,
                ),
              )),
        ],
      );

  deleteAll(List toDelete) async {
    try {
      for (int i = 0; i < toDelete.length; i++) {
        if ((toDelete[i] - i) < dirAllInfoList.length) {
          await AlistManageAPI.remove(widget.bucketPrefix, [allInfoList[toDelete[i] - i]['name']]);
          setState(() {
            allInfoList.removeAt(toDelete[i] - i);
            dirAllInfoList.removeAt(toDelete[i] - i);
            selectedFilesBool.removeAt(toDelete[i] - i);
          });
        } else {
          await AlistManageAPI.remove(widget.bucketPrefix, [allInfoList[toDelete[i] - i]['name']]);
          setState(() {
            allInfoList.removeAt(toDelete[i] - i);
            fileAllInfoList.removeAt(toDelete[i] - i - dirAllInfoList.length);
            selectedFilesBool.removeAt(toDelete[i] - i);
          });
        }
      }
      if (allInfoList.isEmpty) {
        setState(() {
          state = loading_state.LoadState.empty;
        });
      }
    } catch (e) {
      flogErr(
          e,
          {
            'toDelete': toDelete,
          },
          'AlistManagePage',
          'deleteAll');
      rethrow;
    }
  }

  @override
  Widget buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty.png',
            width: 100,
            height: 100,
          ),
          const Text('没有文件哦，点击右上角添加吧', style: TextStyle(fontSize: 20, color: Color.fromARGB(136, 121, 118, 118)))
        ],
      ),
    );
  }

  @override
  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('加载失败,请检查网络', style: TextStyle(fontSize: 20, color: Color.fromARGB(136, 121, 118, 118))),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue),
            ),
            onPressed: () {
              setState(() {
                state = loading_state.LoadState.loading;
              });
              _getBucketList();
            },
            child: const Text('重新加载'),
          )
        ],
      ),
    );
  }

  @override
  Widget buildLoading() {
    return const Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation(Colors.blue),
        ),
      ),
    );
  }

  @override
  Widget buildSuccess() {
    if (allInfoList.isEmpty) {
      return buildEmpty();
    } else {
      return SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        enablePullUp: false,
        header: const ClassicHeader(
          refreshStyle: RefreshStyle.Follow,
          idleText: '下拉刷新',
          refreshingText: '正在刷新',
          completeText: '刷新完成',
          failedText: '刷新失败',
          releaseText: '释放刷新',
        ),
        footer: const ClassicFooter(
          loadStyle: LoadStyle.ShowWhenLoading,
          idleText: '上拉加载',
          loadingText: '正在加载',
          noDataText: '没有更多啦',
          failedText: '没有更多啦',
          canLoadingText: '释放加载',
        ),
        onRefresh: _onrefresh,
        child: ListView.builder(
          itemCount: allInfoList.length,
          itemBuilder: (context, index) {
            if (index < dirAllInfoList.length) {
              return Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Slidable(
                      direction: Axis.horizontal,
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (BuildContext context) async {
                              showCupertinoDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('通知'),
                                      content: Text('确定要删除${allInfoList[index]['name']}吗？'),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          child: const Text('取消', style: TextStyle(color: Colors.blue)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CupertinoDialogAction(
                                          child: const Text('确定', style: TextStyle(color: Colors.blue)),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            var result = await AlistManageAPI.remove(
                                                widget.bucketPrefix, [allInfoList[index]['name']]);
                                            if (result[0] == 'success') {
                                              showToast('删除成功');
                                              setState(() {
                                                allInfoList.removeAt(index);
                                                dirAllInfoList.removeAt(index);
                                                selectedFilesBool.removeAt(index);
                                              });
                                            } else {
                                              showToast('删除失败');
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            backgroundColor: const Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            spacing: 0,
                            icon: Icons.delete,
                            label: '删除',
                          ),
                        ],
                      ),
                      child: Stack(
                        fit: StackFit.loose,
                        children: [
                          Container(
                            color: selectedFilesBool[index] ? const Color(0x311192F3) : Colors.transparent,
                            child: ListTile(
                              minLeadingWidth: 0,
                              minVerticalPadding: 0,
                              leading: Image.asset(
                                'assets/icons/folder.png',
                                width: 30,
                                height: 32,
                              ),
                              title: Text(
                                  allInfoList[index]['name'].length > 15
                                      ? allInfoList[index]['name'].substring(0, 7) +
                                          '...${allInfoList[index]['name'].substring(allInfoList[index]['name'].length - 7)}'
                                      : allInfoList[index]['name'],
                                  style: const TextStyle(fontSize: 16)),
                              trailing: IconButton(
                                icon: const Icon(Icons.more_horiz),
                                onPressed: () {
                                  String iconPath = 'assets/icons/folder.png';
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return buildFolderBottomSheetWidget(context, index, iconPath);
                                      });
                                },
                              ),
                              onTap: () {
                                String prefix = allInfoList[index]['name'];
                                prefix = '${widget.bucketPrefix}$prefix/';
                                Application.router.navigateTo(context,
                                    '${Routes.alistFileExplorer}?element=${Uri.encodeComponent(jsonEncode(widget.element))}&bucketPrefix=${Uri.encodeComponent(prefix)}&refresh=${Uri.encodeComponent(widget.refresh)}',
                                    transition: TransitionType.cupertino);
                              },
                            ),
                          ),
                          Positioned(
                            left: -0.5,
                            top: 20,
                            child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(55)),
                                  color: Color.fromARGB(255, 235, 242, 248)),
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: MSHCheckbox(
                                colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                                    checkedColor: Colors.blue, uncheckedColor: Colors.blue, disabledColor: Colors.blue),
                                size: 17,
                                value: selectedFilesBool[index],
                                style: MSHCheckboxStyle.fillScaleCheck,
                                onChanged: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedFilesBool[index] = true;
                                    } else {
                                      selectedFilesBool[index] = false;
                                    }
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                    )
                  ],
                ),
              );
            } else {
              String fileExtension = allInfoList[index]['name'].split('.').last;
              fileExtension = fileExtension.toLowerCase();
              String iconPath = 'assets/icons/';
              if (fileExtension == '') {
                iconPath += '_blank.png';
              } else if (Global.iconList.contains(fileExtension)) {
                iconPath += '$fileExtension.png';
              } else {
                iconPath += 'unknown.png';
              }
              return Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Slidable(
                        direction: Axis.horizontal,
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (BuildContext context) async {
                                String shareUrl = '';
                                Map configMap = await AlistManageAPI.getConfigMap();
                                shareUrl = '${configMap['host']}/d${widget.bucketPrefix}${allInfoList[index]['name']}';
                                if (allInfoList[index]['sign'] != null && allInfoList[index]['sign'].isNotEmpty) {
                                  shareUrl += '?sign=${allInfoList[index]['sign']}';
                                }
                                Share.share(shareUrl);
                              },
                              autoClose: true,
                              padding: EdgeInsets.zero,
                              backgroundColor: const Color.fromARGB(255, 109, 196, 116),
                              foregroundColor: Colors.white,
                              icon: Icons.share,
                              label: '分享',
                            ),
                            SlidableAction(
                              onPressed: (BuildContext context) async {
                                showCupertinoDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CupertinoAlertDialog(
                                        title: const Text('通知'),
                                        content: Text('确定要删除${allInfoList[index]['name']}吗？'),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            child: const Text('取消', style: TextStyle(color: Colors.blue)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          CupertinoDialogAction(
                                            child: const Text('确定', style: TextStyle(color: Colors.blue)),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              var result = await AlistManageAPI.remove(
                                                  widget.bucketPrefix, [allInfoList[index]['name']]);
                                              if (result[0] == 'success') {
                                                showToast('删除成功');
                                                setState(() {
                                                  allInfoList.removeAt(index);
                                                  selectedFilesBool.removeAt(index);
                                                });
                                              } else {
                                                showToast('删除失败');
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: '删除',
                            ),
                          ],
                        ),
                        child: Stack(fit: StackFit.loose, children: [
                          Container(
                            color: selectedFilesBool[index] ? const Color(0x311192F3) : Colors.transparent,
                            child: ListTile(
                              minLeadingWidth: 0,
                              minVerticalPadding: 0,
                              leading: Image.asset(
                                iconPath,
                                width: 30,
                                height: 30,
                              ),
                              title: Text(
                                  allInfoList[index]['name'].length > 20
                                      ? allInfoList[index]['name'].substring(0, 10) +
                                          '...${allInfoList[index]['name'].substring(allInfoList[index]['name'].length - 10)}'
                                      : allInfoList[index]['name'],
                                  style: const TextStyle(fontSize: 14)),
                              subtitle: Text(
                                  '${allInfoList[index]['modified'].toString().replaceAll('T', ' ').replaceAll('Z', '').substring(0, 19)}  ${getFileSize(int.parse(allInfoList[index]['size'].toString().split('.')[0]))}',
                                  style: const TextStyle(fontSize: 12)),
                              trailing: IconButton(
                                icon: const Icon(Icons.more_horiz),
                                onPressed: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return buildBottomSheetWidget(context, index, iconPath);
                                      });
                                },
                              ),
                              onTap: () async {
                                String urlList = '';
                                //判断是否为支持的格式
                                if (!supportedExtensions(allInfoList[index]['name'].split('.').last)) {
                                  showToast('只支持图片文本和视频');
                                  return;
                                }
                                //预览图片
                                if (Global.imgExt.contains(allInfoList[index]['name'].split('.').last.toLowerCase())) {
                                  showToast('正在加载');
                                  String shareUrl = '';
                                  Map configMap = await AlistManageAPI.getConfigMap();
                                  int newImageIndex = index - dirAllInfoList.length;
                                  for (int i = dirAllInfoList.length; i < allInfoList.length; i++) {
                                    if (Global.imgExt.contains(allInfoList[i]['name'].split('.').last.toLowerCase())) {
                                      shareUrl =
                                          '${configMap['host']}/d${widget.bucketPrefix}${allInfoList[i]['name']}';
                                      if (allInfoList[i]['sign'] != null && allInfoList[i]['sign'].isNotEmpty) {
                                        shareUrl += '?sign=${allInfoList[i]['sign']}';
                                      }
                                      urlList += '$shareUrl,';
                                    } else if (i < index) {
                                      newImageIndex--;
                                    }
                                  }
                                  urlList = urlList.substring(0, urlList.length - 1);
                                  if (context.mounted) {
                                    Application.router.navigateTo(this.context,
                                        '${Routes.albumImagePreview}?index=$newImageIndex&images=${Uri.encodeComponent(urlList)}',
                                        transition: TransitionType.none);
                                  }
                                } else if (allInfoList[index]['name'].split('.').last.toLowerCase() == 'pdf') {
                                  //预览PDF
                                  String shareUrl = '';
                                  Map configMap = await AlistManageAPI.getConfigMap();

                                  shareUrl =
                                      '${configMap['host']}/d${widget.bucketPrefix}${allInfoList[index]['name']}';
                                  if (allInfoList[index]['sign'] != null && allInfoList[index]['sign'].isNotEmpty) {
                                    shareUrl += '?sign=${allInfoList[index]['sign']}';
                                  }
                                  Map<String, dynamic> headers = {};
                                  if (context.mounted) {
                                    Application.router.navigateTo(this.context,
                                        '${Routes.pdfViewer}?url=${Uri.encodeComponent(shareUrl)}&fileName=${Uri.encodeComponent(allInfoList[index]['name'])}&headers=${Uri.encodeComponent(jsonEncode(headers))}',
                                        transition: TransitionType.none);
                                  }
                                } else if (Global.textExt
                                    .contains(allInfoList[index]['name'].split('.').last.toLowerCase())) {
                                  //预览文本
                                  String shareUrl = '';
                                  Map configMap = await AlistManageAPI.getConfigMap();
                                  var res = await AlistManageAPI.getFileInfo(
                                    widget.bucketPrefix + allInfoList[index]['name'],
                                  );
                                  if (res[0] == 'success') {
                                    if (res[1]['raw_url'] != "" && res[1]['raw_url'] != null) {
                                      shareUrl = res[1]['raw_url'];
                                    } else {
                                      shareUrl =
                                          '${configMap['host']}/d${widget.bucketPrefix}${allInfoList[index]['name']}';
                                      if (res[1]['sign'] != null && res[1]['sign'].isNotEmpty) {
                                        shareUrl += '?sign=${res[1]['sign']}';
                                      }
                                    }
                                  } else {
                                    shareUrl =
                                        '${configMap['host']}/d${widget.bucketPrefix}${allInfoList[index]['name']}';
                                    if (allInfoList[index]['sign'] != null && allInfoList[index]['sign'].isNotEmpty) {
                                      shareUrl += '?sign=${allInfoList[index]['sign']}';
                                    }
                                  }
                                  showToast('开始获取文件');
                                  String filePath = await downloadTxtFile(shareUrl, allInfoList[index]['name'], null);
                                  String fileName = allInfoList[index]['name'];
                                  if (filePath == 'error') {
                                    showToast('获取失败');
                                    return;
                                  }
                                  if (context.mounted) {
                                    Application.router.navigateTo(this.context,
                                        '${Routes.mdPreview}?filePath=${Uri.encodeComponent(filePath)}&fileName=${Uri.encodeComponent(fileName)}',
                                        transition: TransitionType.none);
                                  }
                                } else if (Global.chewieExt
                                    .contains(allInfoList[index]['name'].split('.').last.toLowerCase())) {
                                  //预览chewie视频
                                  String shareUrl = '';
                                  Map configMap = await AlistManageAPI.getConfigMap();
                                  List videoList = [];
                                  int newImageIndex = index - dirAllInfoList.length;
                                  for (int i = dirAllInfoList.length; i < allInfoList.length; i++) {
                                    if (Global.chewieExt
                                        .contains(allInfoList[i]['name'].split('.').last.toLowerCase())) {
                                      shareUrl =
                                          '${configMap['host']}/d${widget.bucketPrefix}${allInfoList[i]['name']}';
                                      if (allInfoList[i]['sign'] != null && allInfoList[i]['sign'].isNotEmpty) {
                                        shareUrl += '?sign=${allInfoList[i]['sign']}';
                                      }

                                      videoList.add({"url": shareUrl, "name": allInfoList[i]['name']});
                                    } else if (i < index) {
                                      newImageIndex--;
                                    }
                                  }
                                  Map<String, dynamic> headers = {};
                                  if (context.mounted) {
                                    Application.router.navigateTo(this.context,
                                        '${Routes.netVideoPlayer}?videoList=${Uri.encodeComponent(jsonEncode(videoList))}&index=$newImageIndex&type=${Uri.encodeComponent('normal')}&headers=${Uri.encodeComponent(jsonEncode(headers))}',
                                        transition: TransitionType.none);
                                  }
                                } else if (Global.vlcExt
                                    .contains(allInfoList[index]['name'].split('.').last.toLowerCase())) {
                                  //vlc预览视频
                                  String shareUrl = '';
                                  String subUrl = '';
                                  Map configMap = await AlistManageAPI.getConfigMap();
                                  List videoList = [];
                                  int newImageIndex = index - dirAllInfoList.length;
                                  Map subtitleFileMap = {};
                                  for (int i = dirAllInfoList.length; i < allInfoList.length; i++) {
                                    if (Global.subtitleFileExt
                                        .contains(allInfoList[i]['name'].split('.').last.toLowerCase())) {
                                      subUrl = '${configMap['host']}/d${widget.bucketPrefix}${allInfoList[i]['name']}';
                                      if (allInfoList[i]['sign'] != null && allInfoList[i]['sign'].isNotEmpty) {
                                        subUrl += '?sign=${allInfoList[i]['sign']}';
                                      }
                                      subtitleFileMap[allInfoList[i]['name'].split('.').first] = subUrl;
                                    }
                                    if (Global.vlcExt
                                        .contains(allInfoList[index]['name'].split('.').last.toLowerCase())) {
                                      shareUrl =
                                          '${configMap['host']}/d${widget.bucketPrefix}${allInfoList[i]['name']}';
                                      if (allInfoList[i]['sign'] != null && allInfoList[i]['sign'].isNotEmpty) {
                                        shareUrl += '?sign=${allInfoList[i]['sign']}';
                                      }
                                      videoList.add({
                                        "url": shareUrl,
                                        "name": allInfoList[i]['name'],
                                        "subtitlePath": '',
                                      });
                                    } else if (i < index) {
                                      newImageIndex--;
                                    }
                                  }
                                  for (int i = 0; i < videoList.length; i++) {
                                    if (subtitleFileMap.containsKey(videoList[i]['name'].split('.').first)) {
                                      videoList[i]['subtitlePath'] =
                                          subtitleFileMap[videoList[i]['name'].split('.').first];
                                    }
                                  }
                                  Map<String, dynamic> headers = {};
                                  if (context.mounted) {
                                    Application.router.navigateTo(this.context,
                                        '${Routes.netVideoPlayer}?videoList=${Uri.encodeComponent(jsonEncode(videoList))}&index=$newImageIndex&type=${Uri.encodeComponent('mkv')}&headers=${Uri.encodeComponent(jsonEncode(headers))}',
                                        transition: TransitionType.none);
                                  }
                                }
                              },
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 22,
                            child: Container(
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(55)),
                                  color: Color.fromARGB(255, 235, 242, 248)),
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: MSHCheckbox(
                                colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                                  checkedColor: Colors.blue,
                                  uncheckedColor: Colors.blue,
                                ),
                                size: 17,
                                value: selectedFilesBool[index],
                                style: MSHCheckboxStyle.fillScaleCheck,
                                onChanged: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedFilesBool[index] = true;
                                    } else {
                                      selectedFilesBool[index] = false;
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ])),
                    const Divider(
                      height: 1,
                    )
                  ],
                ),
              );
            }
          },
        ),
      );
    }
  }

  Widget buildBottomSheetWidget(BuildContext context, int index, String iconPath) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(
              iconPath,
              width: 30,
              height: 30,
            ),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            minLeadingWidth: 0,
            title: Text(
                allInfoList[index]['name'].length > 20
                    ? allInfoList[index]['name'].substring(0, 10) +
                        '...${allInfoList[index]['name'].substring(allInfoList[index]['name'].length - 10)}'
                    : allInfoList[index]['name'],
                style: const TextStyle(fontSize: 14)),
            subtitle: Text(
                allInfoList[index]['modified'].toString().replaceAll('T', ' ').replaceAll('Z', '').substring(0, 19),
                style: const TextStyle(fontSize: 12)),
          ),
          const Divider(
            height: 0.1,
            color: Color.fromARGB(255, 230, 230, 230),
          ),
          ListTile(
              leading: const Icon(
                Icons.info_outline_rounded,
                color: Color.fromARGB(255, 97, 141, 236),
              ),
              minLeadingWidth: 0,
              title: const Text('文件详情'),
              onTap: () async {
                Navigator.pop(context);
                Map<String, dynamic> fileMap = allInfoList[index];
                fileMap['fullPath'] = widget.bucketPrefix + fileMap['name'];
                fileMap['modified'] = fileMap['modified'].toString().replaceAll('T', ' ').replaceAll('Z', '');

                Application.router.navigateTo(
                    context, '${Routes.alistFileInformation}?fileMap=${Uri.encodeComponent(jsonEncode(fileMap))}',
                    transition: TransitionType.cupertino);
              }),
          const Divider(
            height: 0.1,
            color: Color.fromARGB(255, 230, 230, 230),
          ),
          ListTile(
            leading: const Icon(
              Icons.link_rounded,
              color: Color.fromARGB(255, 97, 141, 236),
            ),
            minLeadingWidth: 0,
            title: const Text('复制链接(设置中的默认格式)'),
            onTap: () async {
              String shareUrl = '';
              Map configMap = await AlistManageAPI.getConfigMap();

              shareUrl = '${configMap['host']}/d${widget.bucketPrefix}${allInfoList[index]['name']}';
              if (allInfoList[index]['sign'] != null && allInfoList[index]['sign'].isNotEmpty) {
                shareUrl += '?sign=${allInfoList[index]['sign']}';
              }

              String filename = my_path.basename(allInfoList[index]['name']);
              String formatedLink = getFormatedUrl(shareUrl, filename);
              await flutter_services.Clipboard.setData(flutter_services.ClipboardData(text: formatedLink));
              if (mounted) {
                Navigator.pop(context);
              }
              showToast('复制完毕');
            },
          ),
          const Divider(
            height: 0.1,
            color: Color.fromARGB(255, 230, 230, 230),
          ),
          ListTile(
              leading: const Icon(
                Icons.edit_note_rounded,
                color: Color.fromARGB(255, 97, 141, 236),
              ),
              minLeadingWidth: 0,
              title: const Text('重命名'),
              onTap: () async {
                Navigator.pop(context);
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return RenameDialog(
                        contentWidget: RenameDialogContent(
                          title: "新文件名 '/'分割文件夹",
                          okBtnTap: () async {
                            var renameResult =
                                await AlistManageAPI.rename(widget.bucketPrefix + allInfoList[index]['name'], vc.text);
                            if (renameResult[0] == 'success') {
                              showToast('重命名成功');
                              _getBucketList();
                            } else {
                              showToast('重命名失败');
                            }
                          },
                          vc: vc,
                          cancelBtnTap: () {},
                          stateBoolText: '是否覆盖同名文件',
                        ),
                      );
                    });
              }),
          const Divider(
            height: 0.1,
            color: Color.fromARGB(255, 230, 230, 230),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_outline,
              color: Color.fromARGB(255, 240, 85, 131),
            ),
            minLeadingWidth: 0,
            title: const Text('删除'),
            onTap: () async {
              Navigator.pop(context);
              showCupertinoDialog(
                barrierDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: const Text('通知'),
                    content: Text('确定要删除${allInfoList[index]['name']}吗？'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: const Text('取消', style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text('确定', style: TextStyle(color: Colors.blue)),
                        onPressed: () async {
                          Navigator.pop(context);
                          var result = await AlistManageAPI.remove(widget.bucketPrefix, [allInfoList[index]['name']]);
                          if (result[0] == 'success') {
                            showToast('删除成功');
                            setState(() {
                              allInfoList.removeAt(index);
                              selectedFilesBool.removeAt(index);
                            });
                          } else {
                            showToast('删除失败');
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildFolderBottomSheetWidget(BuildContext context, int index, String iconPath) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(
              iconPath,
              width: 30,
              height: 30,
            ),
            minLeadingWidth: 0,
            title: Text(allInfoList[index]['name'], style: const TextStyle(fontSize: 15)),
          ),
          const Divider(
            height: 0.1,
            color: Color.fromARGB(255, 230, 230, 230),
          ),
          ListTile(
            leading: const Icon(
              Icons.beenhere_outlined,
              color: Color.fromARGB(255, 97, 141, 236),
            ),
            minLeadingWidth: 0,
            title: const Text('设为图床默认目录'),
            onTap: () async {
              String path = widget.bucketPrefix + allInfoList[index]['name'];
              var result = await AlistManageAPI.setDefaultBucket(path);
              if (result[0] == 'success') {
                showToast('设置成功');
                if (mounted) {
                  Navigator.pop(context);
                }
              } else {
                showToast('设置失败');
              }
            },
          ),
          const Divider(
            height: 0.1,
            color: Color.fromARGB(255, 230, 230, 230),
          ),
          ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: Color.fromARGB(255, 240, 85, 131),
              ),
              minLeadingWidth: 0,
              title: const Text('删除'),
              onTap: () async {
                Navigator.pop(context);
                showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: const Text('通知'),
                      content: Text('确定要删除${allInfoList[index]['name']}吗？'),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: const Text('取消', style: TextStyle(color: Colors.blue)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        CupertinoDialogAction(
                          child: const Text('确定', style: TextStyle(color: Colors.blue)),
                          onPressed: () async {
                            Navigator.pop(context);
                            var result = await AlistManageAPI.remove(widget.bucketPrefix, [allInfoList[index]['name']]);
                            if (result[0] == 'success') {
                              showToast('删除成功');
                              setState(() {
                                allInfoList.removeAt(index);
                                dirAllInfoList.removeAt(index);
                                selectedFilesBool.removeAt(index);
                              });
                            } else {
                              showToast('删除失败');
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
        ],
      ),
    );
  }
}

class RenameDialog extends AlertDialog {
  RenameDialog({super.key, required Widget contentWidget})
      : super(
          content: contentWidget,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            //side: BorderSide(color: Colors.blue, width: 3)
          ),
        );
}

//弹出框 修改自https://www.jianshu.com/p/4144837a789b
double btnHeight = 60;
double borderWidth = 2;

class RenameDialogContent extends StatefulWidget {
  final String title;
  final String cancelBtnTitle;
  final String okBtnTitle;
  final VoidCallback cancelBtnTap;
  final VoidCallback okBtnTap;
  final TextEditingController vc;
  final String stateBoolText;
  const RenameDialogContent(
      {super.key,
      required this.title,
      this.cancelBtnTitle = "取消",
      this.okBtnTitle = "确定",
      required this.cancelBtnTap,
      required this.okBtnTap,
      required this.vc,
      required this.stateBoolText});

  @override
  RenameDialogContentState createState() => RenameDialogContentState();
}

class RenameDialogContentState extends State<RenameDialogContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        height: 140,
        width: 10000,
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextFormField(
                cursorHeight: 20,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black87),
                controller: widget.vc,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '不能为空';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 234, 236, 238)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    )),
              ),
            ),
            Container(
              height: btnHeight,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: const Color.fromARGB(255, 234, 236, 238),
                    height: borderWidth,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          widget.vc.text = "";
                          widget.cancelBtnTap();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.cancelBtnTitle,
                          style: const TextStyle(fontSize: 22, color: Colors.blue),
                        ),
                      ),
                      Container(
                        width: borderWidth,
                        color: const Color.fromARGB(255, 234, 236, 238),
                        height: btnHeight - borderWidth - borderWidth,
                      ),
                      TextButton(
                          onPressed: () {
                            widget.okBtnTap();
                            Navigator.of(context).pop();
                            widget.vc.text = "";
                          },
                          child: Text(
                            widget.okBtnTitle,
                            style: const TextStyle(fontSize: 22, color: Color.fromARGB(255, 169, 173, 177)),
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class NewFolderDialog extends AlertDialog {
  NewFolderDialog({super.key, required Widget contentWidget})
      : super(
          content: contentWidget,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            //side: BorderSide(color: Colors.blue, width: 3)
          ),
        );
}

//弹出框 修改自https://www.jianshu.com/p/4144837a789b

class NewFolderDialogContent extends StatefulWidget {
  final String title;
  final String cancelBtnTitle;
  final String okBtnTitle;
  final VoidCallback cancelBtnTap;
  final VoidCallback okBtnTap;
  final TextEditingController vc;
  const NewFolderDialogContent({
    super.key,
    required this.title,
    this.cancelBtnTitle = "取消",
    this.okBtnTitle = "确定",
    required this.cancelBtnTap,
    required this.okBtnTap,
    required this.vc,
  });

  @override
  NewFolderDialogContentState createState() => NewFolderDialogContentState();
}

class NewFolderDialogContentState extends State<NewFolderDialogContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        height: 190,
        width: 10000,
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Container(
                alignment: Alignment.center,
                child: Text(
                  widget.title,
                  style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                )),
            //const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextFormField(
                cursorHeight: 20,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black87),
                controller: widget.vc,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '不能为空';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 14, 103, 192)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    )),
              ),
            ),
            const Spacer(),
            //A check box with a label
            Container(
              // color: Colors.red,
              height: btnHeight,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: const Color.fromARGB(255, 234, 236, 238),
                    height: borderWidth,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          widget.vc.text = "";
                          widget.cancelBtnTap();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          widget.cancelBtnTitle,
                          style: const TextStyle(fontSize: 22, color: Colors.blue),
                        ),
                      ),
                      Container(
                        width: borderWidth,
                        color: const Color.fromARGB(255, 234, 236, 238),
                        height: btnHeight - borderWidth - borderWidth,
                      ),
                      TextButton(
                          onPressed: () {
                            widget.okBtnTap();
                            Navigator.of(context).pop();
                            widget.vc.text = "";
                          },
                          child: Text(
                            widget.okBtnTitle,
                            style: const TextStyle(fontSize: 22, color: Colors.blue),
                          )),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
