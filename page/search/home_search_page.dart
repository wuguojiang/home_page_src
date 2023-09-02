import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timuikit/src/pages/new_home/controller/home_search_controller.dart';
import 'package:timuikit/src/pages/new_home/page/search/home_search_filtrate_page.dart';
import 'package:timuikit/src/pages/new_home/page/search/home_search_list_page.dart';
import 'package:timuikit/src/pages/new_home/widget/custom_scroll_physics.dart';
import 'package:timuikit/src/pages/new_home/widget/home_search_segment_widget.dart';

class HomeSearchPage extends StatefulWidget {
  final Function backCall;
  const HomeSearchPage({Key? key,required this.backCall}) : super(key: key);

  @override
  State<HomeSearchPage> createState() => _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearchPage> with AutomaticKeepAliveClientMixin{
  HomeConteroller _conteroller = HomeConteroller.to;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent, //把scaffold的背景色改成透明
              centerTitle: true,
              title: Text(
                "搜索",
              )),
          body: Container(
            color: Colors.white,
            child: NestedScrollView(
                key: const Key('home_list'),
                physics: const ClampingScrollPhysics(),
                headerSliverBuilder: (context, innerBoxIsScrolled) =>
                    _sliverBuilder(context),
                body: PageView.builder(
                    itemCount: 2,
                    onPageChanged: (int index){
                      _conteroller.changeCurrentPage(index);
                    },
                    controller: _conteroller.pageController,
                    itemBuilder: (_, index){
                      if(index == 0){
                        return HomeSearchFiltratePage(backCall: widget.backCall,);
                      }else{
                        return HomeSearchListPage();
                      }
                    }
                )
            ),
          )),
    );
  }


  ///置顶
  List<Widget> _sliverBuilder(BuildContext context) {
    return <Widget>[
      SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(color: Colors.white),
          child: GetBuilder<HomeConteroller>(
              id:HomeConteroller.searchPageID,
              builder: (logic) {
                return HomeSearchSegmentWidget(index: logic.currentPage,selectIndex: (int index){
                  logic.changeCurrentPage(index);
                  logic.pageController.jumpToPage(index);
                },);
              }
          ),
        )
      ),

      //选项卡
      // SliverPersistentHeader(
      //   pinned: true,
      //   floating: true,
      //   delegate: SliverAppBarDelegate(
      //     DecoratedBox(
      //       decoration: BoxDecoration(color: Colors.white),
      //       child: GetBuilder<HomeConteroller>(
      //         id:HomeConteroller.searchPageID,
      //         builder: (logic) {
      //           return HomeSearchSegmentWidget(index: logic.currentPage,selectIndex: (int index){
      //             logic.changeCurrentPage(index);
      //             logic.pageController.jumpToPage(index);
      //           },);
      //         }
      //       ),
      //     ),
      //     80.0,
      //   ),
      // ),
    ];
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this.widget, this.height);

  final Widget widget;
  final double height;

  // minHeight 和 maxHeight 的值设置为相同时，header就不会收缩了
  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return widget;
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
