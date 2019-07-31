import 'package:flutter/material.dart';
import 'dart:math';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)  => MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.lightBlue[800],//主题色为蓝色
    ),
    home: MyHomePage(title: 'Custom UI'),
  );

}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [
            ParallelWidget(),
            ScrollNotificationWidget(),
            ScrollControllerWidget(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home),text: "视差",),
            Tab(icon: Icon(Icons.rss_feed),text: "Notification",),
            Tab(icon: Icon(Icons.perm_identity),text: "Controller",)
          ],
          unselectedLabelColor: Colors.blueGrey,
          labelColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.red,
        ),
      ),
    );
  }
}


class ParallelWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(//SliverAppBar 作为头图控件
              title: Text('CustomScrollView Demo'),// 标题
              floating: true,// 设置悬浮样式
              flexibleSpace: Image.network("https://media-cdn.tripadvisor.com/media/photo-s/13/98/8f/c2/great-wall-hiking-tours.jpg",fit:BoxFit.cover),// 设置悬浮头图背景
              expandedHeight: 280,// 头图控件高度
            ),
            SliverList(//SliverList 作为列表控件
              delegate: SliverChildBuilderDelegate(
                    (context, index) => ListTile(title: Text('Item #$index')),// 列表项创建方法
                childCount: 100,// 列表元素个数
              ),
            ),
          ]);
  }

}



class ScrollNotificationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Scroll Notification Demo',
        home: Scaffold(
            appBar: AppBar(title: Text('ScrollController Demo')),
            body: NotificationListener<ScrollNotification>(// 添加 NotificationListener 作为父容器
              onNotification: (scrollNotification) {// 注册通知回调
                if (scrollNotification is ScrollStartNotification) {// 滚动开始
                  print('Scroll Start');
                } else if (scrollNotification is ScrollUpdateNotification) {// 滚动位置更新
                  print('Scroll Update');
                } else if (scrollNotification is ScrollEndNotification) {// 滚动结束
                  print('Scroll End');
                }
              },
              child: ListView.builder(
                itemCount: 30,// 列表元素个数
                itemBuilder: (context, index) => ListTile(title: Text("Index : $index")),// 列表项创建方法
              ),
            )
        )
    );
  }
}

class ScrollControllerWidget extends StatefulWidget {
 @override
  State<StatefulWidget> createState()=> _ScrollControllerState();
}

class _ScrollControllerState extends State<ScrollControllerWidget> {
  ScrollController _controller;//ListView 控制器
  bool isToTop = false;// 标示目前是否需要启用 "Top" 按钮
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(() {// 为控制器注册滚动监听方法
      if(_controller.offset > 1000) {// 如果 ListView 已经向下滚动了 1000，则启用 Top 按钮
        setState(() {isToTop = true;});
      } else if(_controller.offset < 300) {// 如果 ListView 向下滚动距离不足 300，则禁用 Top 按钮
        setState(() {isToTop = false;});
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scroll Controller Widget")),
      body: Column(
        children: <Widget>[
          Container(
            height: 40.0,
            child: RaisedButton(onPressed: (isToTop ? () {
              if (isToTop) {
                _controller.animateTo(.0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease
                ); // 做一个滚动到顶部的动画
              }
            } : null), child: Text("Top"),),
          ),
          Expanded(
            child: ListView.builder(
              controller: _controller, // 初始化传入控制器
              itemCount: 100, // 列表元素总数
              itemBuilder: (context, index) =>
                  ListTile(title: Text("Index : $index")), // 列表项构造方法
            ),
          ),
        ],
      ),
    );
  }
    @override
    void dispose() {
    _controller.dispose(); // 销毁控制器
    super.dispose();
    }
  }
