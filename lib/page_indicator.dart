import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PageIndicator extends StatefulWidget {
  /// 初始页面
  final int initPage;

  /// 页面数量
  final int pageNum;

  /// 切换页面回调
  final void Function(int) onPageChanged;

  const PageIndicator(
      {Key key, this.initPage = 1, this.pageNum = 50, this.onPageChanged})
      : super(key: key);

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  /// 最大显示条目
  static const MAX_INDICATOR_NUM = 7;

  /// 当前页面
  var currentPage = 1;

  @override
  void initState() {
    currentPage = widget.initPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewList = [];

    // 当页面数量大于最大条目时，按当前页面情况展示
    if (widget.pageNum > MAX_INDICATOR_NUM) {
      // 当前页面小于 5，情况 1
      if (currentPage < 5) {
        viewList.addAll(List.generate(MAX_INDICATOR_NUM, (index) {
          if (index == 5) {
            return buildMore(6, widget.pageNum - 1);
          }

          if (index == MAX_INDICATOR_NUM - 1) {
            return buildPageText(widget.pageNum);
          }

          return buildPageText(index + 1);
        }));
      }

      // 当前页面大于 4，且当前页面小于 页面数量 - 4，情况 2
      if (currentPage >= 5 && currentPage <= widget.pageNum - 4) {
        viewList.addAll([
          buildPageText(1),
          buildMore(2, currentPage - 2),
          buildPageText(currentPage - 1),
          buildPageText(currentPage),
          buildPageText(currentPage + 1),
          buildMore(currentPage + 2, widget.pageNum - 1),
          buildPageText(widget.pageNum),
        ]);
      }

      // 当前页面大于等于页面数量 - 3 , 情况 3
      if (currentPage >= widget.pageNum - 3) {
        viewList.addAll([
          buildPageText(1),
          buildMore(2, widget.pageNum - 5),
          buildPageText(widget.pageNum - 4),
          buildPageText(widget.pageNum - 3),
          buildPageText(widget.pageNum - 2),
          buildPageText(widget.pageNum - 1),
          buildPageText(widget.pageNum),
        ]);
      }
    } else {
      // 当页面数量少于最大条目时，直接展示
      viewList.addAll(List.generate(MAX_INDICATOR_NUM, (index) {
        return buildPageText(index + 1);
      }));
    }

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 总页面提示
          Text('共 ${widget.pageNum} 页'),
          // 前一页
          IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: currentPage > 1
                  ? () {
                      changePage(currentPage - 1);
                    }
                  : null),
          // 页面按钮
          ...viewList,
          // 下一页
          IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: currentPage < widget.pageNum
                  ? () {
                      changePage(currentPage + 1);
                    }
                  : null),
        ],
      ),
    );
  }

  /// 切换页面
  void changePage(final int pageIndex) {
    print('--------------------- page changed: $pageIndex --------------');
    setState(() {
      currentPage = pageIndex;
    });
    if (widget.onPageChanged != null) {
      widget.onPageChanged(pageIndex);
    }
  }

  Widget buildPageText(final int pageIndex) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: pageIndex == currentPage
              ? Theme.of(context).accentColor
              : Colors.transparent,
        ),
        Text('$pageIndex',
            style: TextStyle(
                color: pageIndex == currentPage
                    ? Colors.white
                    : Theme.of(context).textTheme.subtitle1.color)),
        Positioned.fill(
          child: Material(
            child: InkWell(
              borderRadius: BorderRadius.circular(128),
              onTap: () {
                changePage(pageIndex);
              },
            ),
            color: Colors.transparent,
          ),
        )
      ],
    );
  }

  /// 构建更多条目 "..."
  Widget buildMore(int from, int to) {
    final List<PopupMenuItem<int>> items = [];

    for (int i = from; i < to + 1; i++) {
      items.add(PopupMenuItem<int>(child: Text('$i'), enabled: true, value: i));
    }

    return PopupMenuButton<int>(
      itemBuilder: (context) => items,
      child: const Text('...'),
      onSelected: (value) {
        changePage(value);
      },
    );
  }
}
