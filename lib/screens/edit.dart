import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memomemo/database/db.dart';
import 'package:memomemo/database/memo.dart';
import 'package:crypto/crypto.dart';

class EditPage extends StatelessWidget {
  EditPage({Key? key}) : super(key: key);

  String title = '';
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.delete)
          ),
          IconButton(
              onPressed: saveDB,
              icon: Icon(Icons.save)
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged: (String title){ this.title = title; },
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              //obscureText: true,
              decoration: InputDecoration(
                //border: OutlineInputBorder(),
                hintText: '제목을 입력해주세요.',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              onChanged: (String text){ this.text = text; },
              keyboardType: TextInputType.multiline,
              maxLines: null,
              //obscureText: true,
              decoration: InputDecoration(
                //border: OutlineInputBorder(),
                hintText: '내용을 입력해주세요.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveDB() async {
    DBHelper sd = DBHelper();

    var fido = Memo(
      id: StrSha512(DateTime.now().toString()),
      title: this.title,
      text: this.text,
      createTime: DateTime.now().toString(),
      editTime: DateTime.now().toString(),
    );

    await sd.insertMemo(fido);
    print(await sd.memos());
  }

  String StrSha512(String text) {
    var bytes = utf8.encode(text); // data being hashed
    var digest = sha512.convert(bytes);
    return digest.toString();
  }
}
