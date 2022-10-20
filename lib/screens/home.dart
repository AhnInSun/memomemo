import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memomemo/screens/edit.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';
import 'package:memomemo/screens/view.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String deleteId = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 40, bottom: 20),
            child: Container(
              child: Text(
                '메모메모',
                style: TextStyle(fontSize: 36, color: Colors.blue),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          Expanded(child: memoBuilder(context))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => EditPage()));
        },
        tooltip: '메로를 추가하려면 클릭하세요',
        label: Text('메모 추가'),
        icon: Icon(Icons.add),
      ),
    );
  }

  Future<List<Memo>> loadMemo() async {
    DBHelper sd = DBHelper();
    return await sd.memos();
  }

  Future<void> deleteMemo(String id) async {
    DBHelper sd = DBHelper();
    await sd.deleteMemo(id);
  }

  Future<void> _showMyDialog(BuildContext pCtx) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제알림'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('정말로 삭제하시겠습니까?'),
                Text('삭제된 메모는 복구되지 않습니다.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('삭제'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  deleteMemo(deleteId);
                });
                deleteId = '';
              },
            ),
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                deleteId = '';
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget memoBuilder(BuildContext pCtx) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.data!.isEmpty) {
          return Container(
            alignment: Alignment.center,
            child: const Text(
              '지금 바로 메모를 추가해주세요!\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n',
              style: TextStyle(
                fontSize: 15,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(15),
          itemCount: snap.data!.length,
          itemBuilder: (context, index) {
            Memo memo = snap.data![index];
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => ViewPage(id: memo.id)));
              },
              onLongPress: () {
                setState(() {
                  deleteId = memo.id;
                  _showMyDialog(pCtx);
                });
              },
              child: Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(5),
                alignment: Alignment.center,
                height: 100,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    border: Border.all(
                      color: Colors.blue,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.lightBlue, blurRadius: 3)
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          memo.title,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          memo.text,
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "최근수정: " + memo.editTime.split('.')[0],
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[500]),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      future: loadMemo(),
    );
  }
}
