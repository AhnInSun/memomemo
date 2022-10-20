import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:memomemo/database/memo.dart';
import 'package:memomemo/database/db.dart';

class ViewPage extends StatelessWidget {
  const ViewPage({Key? key, required this.id}) : super(key: key);

  final String id;

  //findMemo(id);[0]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          IconButton(onPressed: () {}, icon: Icon(Icons.edit))
        ],
      ),
      body: Padding(padding: EdgeInsets.all(20), child: loadBuilder()),
    );
  }

  Future<List<Memo>> loadMemo(String id) async {
    DBHelper sd = DBHelper();
    return await sd.findMemo(id);
  }

  loadBuilder() {
    return FutureBuilder<List<Memo>>(
      future: loadMemo(id),
      builder: (BuildContext context, AsyncSnapshot<List<Memo>> snap) {
        if (snap.data!.isEmpty) {
          return Container(child: Text('데이터를 불러올 수 없습니다.'));
        } else {
          Memo memo = snap.data![0];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                memo.title,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              Text(
                "생성시간: " + memo.createTime.split('.')[0],
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                textAlign: TextAlign.end,
              ),
              Text(
                "수정시간: " + memo.editTime.split('.')[0],
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                textAlign: TextAlign.end,
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(child: Text(memo.text)),
            ],
          );
        }
      },
    );
  }
}
