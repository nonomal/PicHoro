import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:horopic/widgets/common_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:fluro/fluro.dart';

import 'package:horopic/router/application.dart';
import 'package:horopic/router/routers.dart';
import 'package:horopic/picture_host_manage/common/loading_state.dart' as loading_state;
import 'package:horopic/picture_host_manage/manage_api/qiniu_manage_api.dart';
import 'package:horopic/utils/common_functions.dart';

class QiniuBucketList extends StatefulWidget {
  const QiniuBucketList({super.key});

  @override
  QiniuBucketListState createState() => QiniuBucketListState();
}

class QiniuBucketListState extends loading_state.BaseLoadingPageState<QiniuBucketList> {
  List bucketMap = [];

  RefreshController refreshController = RefreshController(initialRefresh: false);
  TextEditingController domainController = TextEditingController();
  TextEditingController pathController = TextEditingController();

  TextEditingController areaController = TextEditingController();
  TextEditingController optionController = TextEditingController();
  bool isUseRemotePSConfig = false;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  dispose() {
    refreshController.dispose();
    domainController.dispose();
    pathController.dispose();
    areaController.dispose();
    optionController.dispose();
    super.dispose();
  }

  //下拉刷新
  _onRefresh() async {
    initBucketList();
  }

  _configMapWithCatch() async {
    try {
      var configMap = await QiniuManageAPI.getConfigMap();
      return configMap;
    } catch (e) {
      return null;
    }
  }

  //初始化bucketList
  initBucketList() async {
    bucketMap.clear();
    try {
      var configMap = await _configMapWithCatch();
      if (configMap != null) {
        if (configMap['options'] != 'None') {
          optionController.text = configMap['options'];
        }
        if (configMap['path'] != 'None') {
          pathController.text = configMap['path'];
        }
      }

      var bucketListResponse = await QiniuManageAPI.getBucketNameList();

      //判断是否获取成功
      if (bucketListResponse[0] != 'success') {
        if (mounted) {
          setState(() {
            state = loading_state.LoadState.error;
          });
          showToast('获取失败');
        }
        refreshController.refreshCompleted();
        return;
      }
      //没有bucket
      if (bucketListResponse[1] == null) {
        if (mounted) {
          setState(() {
            state = loading_state.LoadState.empty;
          });
        }
        refreshController.refreshCompleted();
        return;
      }
      //有bucket
      var allBucketList = bucketListResponse[1];

      if (allBucketList is! List) {
        allBucketList = [allBucketList];
      }
      for (var i = 0; i < allBucketList.length; i++) {
        bucketMap.add({
          'name': allBucketList[i],
          'tag': '存储桶',
        });
      }
      if (mounted) {
        setState(() {
          if (bucketMap.isEmpty) {
            state = loading_state.LoadState.empty;
          } else {
            state = loading_state.LoadState.success;
          }
          refreshController.refreshCompleted();
        });
      }
    } catch (e) {
      flogErr(e, {}, 'QiniuBucketListState', 'initBucketList');
      if (mounted) {
        setState(() {
          state = loading_state.LoadState.error;
        });
      }
      showToast('获取失败');
      refreshController.refreshCompleted();
    }
  }

  @override
  AppBar get appBar => AppBar(
        elevation: 0,
        centerTitle: true,
        title: titleText('七牛云存储桶列表'),
        flexibleSpace: getFlexibleSpace(context),
        actions: [
          IconButton(
            onPressed: () async {
              await Application.router
                  .navigateTo(context, Routes.qiniuNewBucketConfig, transition: TransitionType.cupertino);
              _onRefresh();
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            iconSize: 35,
          )
        ],
      );

  @override
  void onErrorRetry() {
    setState(() {
      state = loading_state.LoadState.loading;
    });
    initBucketList();
  }

  Widget setDefaultPSHost(Map element) {
    return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
      return CupertinoAlertDialog(
        title: const Text('请确认域名等信息', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
        content: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              textAlign: TextAlign.center,
              prefix: const Text('域名：', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 121, 118, 118))),
              controller: domainController,
              placeholder: '网站域名',
            ),
            const SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              textAlign: TextAlign.center,
              prefix: const Text('区域：', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 121, 118, 118))),
              controller: areaController,
              placeholder: '存储区域',
            ),
            const SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              prefix: const Text('路径：', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 121, 118, 118))),
              textAlign: TextAlign.center,
              controller: pathController,
              placeholder: '图床路径，非必填',
            ),
            const SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              prefix: const Text('后缀：', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 121, 118, 118))),
              textAlign: TextAlign.center,
              controller: optionController,
              placeholder: '网址后缀，非必填',
            ),
            const SizedBox(
              height: 10,
            ),
            CheckboxListTile(
                dense: true,
                title: const Text(
                  '使用已添加的域名和区域信息',
                  style: TextStyle(fontSize: 14),
                ),
                value: isUseRemotePSConfig,
                onChanged: (value) async {
                  if (value == true) {
                    var queryQiniu = await QiniuManageAPI.readQiniuManageConfig();
                    if (queryQiniu != 'Error') {
                      var jsonResult = jsonDecode(queryQiniu);
                      domainController.text = jsonResult['domain'];
                      areaController.text = jsonResult['area'];
                      setState(() {
                        isUseRemotePSConfig = value!;
                      });
                    } else {
                      showToast('请先在弹出栏添加域名和区域信息');
                    }
                  } else {
                    domainController.clear();
                    areaController.clear();
                    setState(() {
                      isUseRemotePSConfig = value!;
                    });
                  }
                }),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text('确定'),
            onPressed: () async {
              try {
                var option = optionController.text;
                var path = pathController.text;
                var domain = domainController.text;
                var area = areaController.text;
                Map textMap = {};
                if (option == '' || option.replaceAll(' ', '').isEmpty) {
                  textMap['option'] = '';
                } else {
                  textMap['option'] = option;
                }
                if (path == '' || path.replaceAll(' ', '').isEmpty) {
                  textMap['path'] = '';
                } else {
                  textMap['path'] = path;
                }
                if (domain == '' || domain.replaceAll(' ', '').isEmpty) {
                  showToast('请设定域名');
                  return;
                }
                if (area == '' || area.replaceAll(' ', '').isEmpty) {
                  showToast('请设定区域');
                  return;
                }
                textMap['domain'] = domain;
                textMap['area'] = area;
                var insertQiniuManage =
                    await QiniuManageAPI.saveQiniuManageConfig(element['name'], textMap['domain'], textMap['area']);
                if (!insertQiniuManage) {
                  showToast('数据保存错误');
                  return;
                }
                var result = await QiniuManageAPI.setDefaultBucketFromListPage(element, textMap, null);
                if (result[0] == 'success') {
                  showToast('设置成功');
                  if (mounted) {
                    Navigator.pop(context);
                  }
                } else {
                  showToast('设置失败');
                }
              } catch (e) {
                flogErr(
                    e,
                    {
                      'domain': domainController.text,
                      'area': areaController.text,
                      'path': pathController.text,
                      'option': optionController.text,
                    },
                    'QiniuManagePage',
                    'setDefaultPSHost');
              }
            },
          ),
        ],
      );
    });
  }

  @override
  Widget buildSuccess() {
    return SmartRefresher(
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
          noDataText: '没有更多了',
          failedText: '没有更多了',
          canLoadingText: '释放加载',
        ),
        controller: refreshController,
        onRefresh: _onRefresh,
        child: GroupedListView(
          shrinkWrap: true,
          elements: bucketMap,
          groupBy: (element) => element['tag'],
          itemComparator: (item1, item2) => item1['name'].compareTo(item2['name']),
          groupComparator: (value1, value2) => value2.compareTo(value1),
          separator: const Divider(
            height: 0.1,
            color: Color.fromARGB(255, 230, 230, 230),
          ),
          groupSeparatorBuilder: (String value) => Container(
            height: 30,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 184, 182, 182),
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 230, 230, 230),
                  width: 0.1,
                ),
              ),
            ),
            child: const ListTile(
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
              title: Text(
                '存储桶',
                style: TextStyle(
                  height: 0.3,
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          itemBuilder: (context, element) {
            return ListTile(
                minLeadingWidth: 0,
                contentPadding: const EdgeInsets.only(left: 20, right: 20),
                leading: const Icon(
                  IconData(0xe6ab, fontFamily: 'iconfont'),
                  color: Colors.blue,
                  size: 35,
                ),
                title: Text(element['name']),
                onTap: () async {
                  Map<String, dynamic> textMap = {};
                  textMap['name'] = element['name'];
                  var queryQiniuManage = await QiniuManageAPI.readQiniuManageConfig();
                  if (queryQiniuManage == 'Error') {
                    showToast('请先设置域名和区域');
                    return;
                  } else {
                    var jsonResult = jsonDecode(queryQiniuManage);
                    if (jsonResult['domain'] == 'None' || jsonResult['area'] == 'None') {
                      showToast('请先设置域名和区域');
                      return;
                    }
                    textMap['domain'] = jsonResult['domain'];
                    textMap['area'] = jsonResult['area'];
                  }
                  if (mounted) {
                    Application.router.navigateTo(context,
                        '${Routes.qiniuFileExplorer}?element=${Uri.encodeComponent(jsonEncode(textMap))}&bucketPrefix=${Uri.encodeComponent('')}',
                        transition: TransitionType.cupertino);
                  }
                },
                trailing: IconButton(
                  icon: const Icon(Icons.more_horiz_outlined),
                  onPressed: () async {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return buildBottomSheetWidget(context, element);
                        });
                  },
                ));
          },
          order: GroupedListOrder.DESC,
        ));
  }

  Widget buildBottomSheetWidget(BuildContext context, Map element) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              IconData(0xe6ab, fontFamily: 'iconfont'),
              color: Colors.blue,
            ),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            minLeadingWidth: 0,
            title: Text(
              element['name'],
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const Divider(
            height: 0.1,
            color: Color.fromARGB(255, 230, 230, 230),
          ),
          ListTile(
            leading: const Icon(
              Icons.check_box_outlined,
              color: Color.fromARGB(255, 97, 141, 236),
            ),
            minLeadingWidth: 0,
            title: const Text('设为默认图床', style: TextStyle(fontSize: 15)),
            onTap: () async {
              Navigator.pop(context);
              await showCupertinoDialog(
                  builder: (context) {
                    return setDefaultPSHost(element);
                  },
                  context: context);
            },
          ),
          const Divider(
            height: 0.1,
            color: Color.fromARGB(255, 230, 230, 230),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings_outlined,
              color: Color.fromARGB(255, 97, 141, 236),
            ),
            minLeadingWidth: 0,
            title: const Text('设置存储桶参数', style: TextStyle(fontSize: 15)),
            onTap: () {
              Navigator.pop(context);
              Application.router.navigateTo(
                  context, '${Routes.qiniuBucketDomainAreaConfig}?element=${Uri.encodeComponent(jsonEncode(element))}',
                  transition: TransitionType.cupertino);
            },
          ),
          const Divider(
            height: 0.1,
            color: Color.fromARGB(255, 230, 230, 230),
          ),
          ListTile(
            leading: const Icon(Icons.public, color: Color.fromARGB(255, 97, 141, 236)),
            minLeadingWidth: 0,
            title: const Text('设为公开', style: TextStyle(fontSize: 15)),
            onTap: () async {
              var result = await QiniuManageAPI.setACL(element, '0');
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
              Icons.lock_outline,
              color: Color.fromARGB(255, 97, 141, 236),
            ),
            minLeadingWidth: 0,
            title: const Text('设为私有', style: TextStyle(fontSize: 15)),
            onTap: () async {
              var result = await QiniuManageAPI.setACL(element, '1');
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
              Icons.dangerous_outlined,
              color: Color.fromARGB(255, 240, 85, 131),
            ),
            minLeadingWidth: 0,
            title: const Text('删除存储桶', style: TextStyle(fontSize: 15)),
            onTap: () async {
              Navigator.pop(context);
              return showCupertinoAlertDialogWithConfirmFunc(
                title: '删除存储桶',
                content: '是否删除存储桶？\n删除前请清空该存储桶!',
                context: context,
                onConfirm: () async {
                  var result = await QiniuManageAPI.deleteBucket(element);
                  if (result[0] == 'success') {
                    showToast('删除成功');
                    _onRefresh();
                  } else {
                    showToast('删除失败');
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
