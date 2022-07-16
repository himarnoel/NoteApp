import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/db.dart';
import '../utils/model.dart';

class Inner extends StatefulWidget {
  static String id = "Inner";
  // ignore: prefer_typing_uninitialized_variables
  final content, index, cate;
  const Inner({Key? key, this.content, this.index, this.cate})
      : super(key: key);

  @override
  State<Inner> createState() => _InnerState();
}

class _InnerState extends State<Inner> {
  String cate = 'Uncategorized';
  List<Map<String, Object?>>? uiData;
  TextEditingController noteController = TextEditingController();

  create() async {
    if (noteController.text.isNotEmpty) {
      var note = Note(
        category: cate,
        content: noteController.text,
        date: DateTime.now(),
      );
      await MyDb.db.createData(note);

      setState(() {
        noteController.clear();
      });
    }
  }

  bool change = false;
  edit() async {
    if (noteController.text.isNotEmpty) {
      var note = Note(
          category: change ? cate : widget.cate,
          content: noteController.text,
          date: DateTime.now());
      await MyDb.db.editData(note, widget.index);

      setState(() {
        noteController.clear();
      });
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    if (widget.content != null) noteController.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Container(
          height: height / 10,
          width: width,
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: "Added to Home category",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blue.shade500,
                      textColor: Colors.white,
                      fontSize: 15.0);
                  setState(() {
                    cate = "Home";
                  });
                },
                style: ElevatedButton.styleFrom(
                    elevation: 1, primary: Colors.blue.shade500),
                child: const Text(
                  "Home",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: "Added to Business category",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green.shade500,
                      textColor: Colors.white,
                      fontSize: 15.0);
                  setState(() {
                    cate = "Business";
                  });
                },
                style: ElevatedButton.styleFrom(
                    elevation: 1, primary: Colors.green.shade500),
                child: const Text(
                  "Business",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: "Added to Play category",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.orange.shade500,
                      textColor: Colors.white,
                      fontSize: 15.0);
                  setState(() {
                    cate = "Play";
                  });
                },
                style: ElevatedButton.styleFrom(
                    elevation: 1, primary: Colors.orange.shade500),
                child: const Text(
                  "Play",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.amber.shade700,
          automaticallyImplyLeading: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness:
                Brightness.light, //<-- For Android SEE HERE (light icons)
            statusBarBrightness:
                Brightness.dark, //<--- For ios SEE Here (light icons)
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                  onPressed: () {
                    if (widget.index == null) {
                      create();
                      print(1);
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        change = true;
                      });
                      edit();

                      print(2);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            Expanded(
              child: TextField(
                expands: true,
                maxLines: null,
                minLines: null,
                controller: noteController,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Enter Description'),
                style: const TextStyle(
                    fontSize: 20.0, height: 1.0, color: Colors.black),
              ),
            )
          ],
        ));
  }
}
