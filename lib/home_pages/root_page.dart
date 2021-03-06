import 'package:flutter/material.dart';
import 'package:flutter_trip/home_page_widget/user_agreement_model.dart';
import 'package:flutter_trip/home_pages/home_page.dart';
import 'package:flutter_trip/home_pages/my_page.dart';
import 'package:flutter_trip/home_pages/network_request_test.dart';
import 'package:flutter_trip/home_pages/trip_page.dart';
import 'package:flutter_trip/home_pages/video_page.dart';
import 'package:flutter_trip/util/permission_util.dart';
import 'package:flutter_trip/util/sp_util.dart';

/*
 * @ClassName root_page
 * 作者: szj
 * 时间: 2020/12/22 14:50
 * CSDN:https://blog.csdn.net/weixin_44819566
 * 公众号:码上变有钱
 */

/// 主页面
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with WidgetsBindingObserver, UserAgreementModel {
  int _currentIndex = 0; //记录当前按钮位置
  PageController _pageController; //PageView控制器

  PermissionUtil _permissionUtil;

  @override
  void initState() {
    super.initState();

    //用来观察应用切换状态
    WidgetsBinding.instance.addObserver(this);

    //权限申请 和 用户协议
    initData();
  }

  void initData() async {
    _permissionUtil = new PermissionUtil(context);

    //检查权限
    _permissionUtil.checkPermission();

    Future.delayed(Duration.zero, () {
      SpUtil.getDate<bool>("isUserAgreement").then((value) {
        if (value == null || !value) {
          showUserAgreementModelDialog(context);
        }
      });
    });
  }

  @override
  void dispose() {
    //注销观察者模式
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);

    //当引用程序返回,并且当前是去的应用市场,则重新调用权限检测判断
    if (state == AppLifecycleState.resumed && _permissionUtil.isGoAppSetteng) {
      _permissionUtil.checkPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PageView(
          children: [
            HomePage(),
            VideoPage(),
            TripPage(),
            MyPage(),
            NetworkRequestTest(),
          ],
          //当打开页面显示第0个位置
          controller: _pageController = new PageController(initialPage: 0),
          onPageChanged: (index) {
            setState(() {
              //滑动Page使按钮跟随变化
              _currentIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          //点击按钮使用PageView控制器控制当前页面
          _pageController.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        //将文本展示出来
        type: BottomNavigationBarType.fixed,
        items: [
          /**
           * 首页
           */
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "首页",
            //选中样式
            activeIcon: Icon(
              Icons.home,
            ),
          ),
          /**
           * 视频
           */
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call),
            label: "视频",
            activeIcon: Icon(
              Icons.video_call,
            ),
          ),
          /**
           * 旅拍
           */
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: "旅拍",
            activeIcon: Icon(
              Icons.camera_alt,
            ),
          ),
          /**
           * 我的
           */
          BottomNavigationBarItem(
            icon: Icon(Icons.android),
            label: "我的",
            activeIcon: Icon(
              Icons.android,
            ),
          ),
          /**
           * test测试
           */
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields_sharp),
            label: "测试",
            activeIcon: Icon(
              Icons.text_fields_sharp,
            ),
          ),
        ],
      ),
    );
  }
}
