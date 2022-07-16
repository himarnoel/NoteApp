import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../utils/db.dart';
import '../utils/model.dart';
import 'inner.dart';

class NoteUi extends StatefulWidget {
  static String id = "hi";
  const NoteUi({Key? key}) : super(key: key);

  @override
  State<NoteUi> createState() => _NoteUiState();
}

class _NoteUiState extends State<NoteUi> {
  var color1 = Colors.blue.shade500;
  var color2 = Colors.green.shade500;
  var color3 = Colors.orange.shade500;
  var color4 = Colors.purple.shade500;
  List<Map<String, Object?>>? uiData;

  TextEditingController noteController = TextEditingController();
  var format = DateFormat.yMEd();

  getData() async {
    var theData = await MyDb.db.getData();
    setState(() {
      uiData = theData;
    });
    // print(theData);
  }

  deleteData(int id) async {
    await MyDb.db.deleteData(id);
    await getData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  List nep = [];
  var ind;
  var theConten;
  bool select = false;
  bool click = false;
  @override
  Widget build(BuildContext context) {
    getData();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        if (select) {
          select = false;
          nep.clear();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.amber.shade700,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness:
                Brightness.light, //<-- For Android SEE HERE (light icons)
            statusBarBrightness:
                Brightness.dark, //<--- For ios SEE Here (light icons)
          ),
          title: Text(
            select == true ? "${nep.length}/ ${uiData?.length}" : "Notebook",
            style: const TextStyle(color: Colors.white),
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            select
                ? Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                        onPressed: () {
                          click = !click;
                          if (click) {
                            nep.clear();
                            uiData?.forEach((e) {
                              nep.add(e["id"]);
                            });
                          } else {
                            nep.clear();
                            select = false;
                          }
                        },
                        icon: Icon(
                          uiData!.length == nep.length
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: uiData!.length == nep.length
                              ? Colors.white
                              : Colors.black,
                        )),
                  )
                : const SizedBox.shrink()
          ],
        ),
        body: Column(children: [
          uiData == null
              ? const Text('No Item')
              : Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: 15),
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      height: 1,
                    ),
                    itemCount: uiData!.length,
                    itemBuilder: (context, index) {
                      var theContent = Note.fromMap(uiData![index]);
                      theConten = theContent;
                      var theDate = format.format(theContent.date);
                      var cate = theContent.category;
                      var cont = '';
                      cont = theContent.content;

                      return Stack(
                        children: [
                          Container(
                              height: height / 10.3,
                              width: width / 70,
                              color: cate == 'Home'
                                  ? color1
                                  : cate == 'Business'
                                      ? color2
                                      : cate == 'Play'
                                          ? color3
                                          : color4,
                              child: const Padding(
                                padding: EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 0.5,
                                ),
                              )),
                          ListTile(
                              trailing: IconButton(
                                  onPressed: () {
                                    if (!nep.any((e) => theContent.id == e)) {
                                      nep.add(theContent.id);
                                    } else {
                                      setState(() {
                                        nep.remove(theContent.id);
                                      });
                                      if (nep.isEmpty) {
                                        select = false;
                                      }

                                      for (var e in nep) {
                                        debugPrint(e.toString());
                                      }
                                    }
                                  },
                                  icon: select
                                      ? Icon(
                                          nep.any((e) => theContent.id == e)
                                              ? Icons.check_circle
                                              : Icons.circle_outlined,
                                          color:
                                              nep.any((e) => theContent.id == e)
                                                  ? Colors.amber.shade700
                                                  : Colors.black,
                                        )
                                      : const SizedBox.shrink()),
                              selectedTileColor:
                                  nep.any((e) => theContent.id == e)
                                      ? Colors.blue.withOpacity(0.09)
                                      : Colors.white,
                              selectedColor: Colors.black,
                              selected: nep.any((e) => e == theContent.id),
                              onTap: () {
                                for (var e in nep) {
                                  debugPrint(e.toString());
                                }

                                if (select == false) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Inner(
                                                content: cont,
                                                index: theContent.id,
                                                cate: theContent.category,
                                              )));
                                } else if (!nep
                                    .any((e) => theContent.id == e)) {
                                  nep.add(theContent.id);
                                } else {
                                  setState(() {
                                    nep.remove(theContent.id);
                                  });
                                  if (nep.isEmpty) {
                                    select = false;
                                  }

                                  for (var e in nep) {
                                    debugPrint(e.toString());
                                  }
                                }
                              },
                              onLongPress: () {
                                nep.add(theContent.id);
                                select = true;
                              },
                              title: Text(
                                theContent.content.toString(),
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    theContent.category,
                                    style: TextStyle(
                                        color: cate == 'Home'
                                            ? color1
                                            : cate == 'Business'
                                                ? color2
                                                : cate == 'Play'
                                                    ? color3
                                                    : color4),
                                  ),
                                  SizedBox(
                                    width: width / 35,
                                  ),
                                  Text(theDate)
                                ],
                              ),
                              tileColor: Colors.white),
                        ],
                      );
                    },
                  ),
                )
        ]),
        bottomNavigationBar: select
            ? Container(
                height: height / 15,
                width: width,
                color: Colors.white.withOpacity(0.8),
                child: IconButton(
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text(nep.length == uiData!.length
                                    ? 'Are you sure you want to delete all the notes?'
                                    : "Are you sure you want to delete ${nep.length} ${nep.length > 1 ? "notes" : "note"}"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 6,
                                        primary: Colors.amber.shade700),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      nep.clear();
                                      setState(() {
                                        select = false;
                                      });
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 6,
                                        primary: Colors.amber.shade700),
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Fluttertoast.showToast(
                                          msg: "${nep.length} note  deleted",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                              Colors.amber.shade700,
                                          textColor: Colors.white,
                                          fontSize: 15.0);
                                      for (var e in nep) {
                                        deleteData(e);
                                      }
                                      nep.clear();
                                      select = false;
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ));
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.amber.shade700,
                    )))
            : const SizedBox.shrink(),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber.shade700,
            elevation: 1,
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Inner()));
              nep.clear();
              select = false;
            },
            child: const Icon(Icons.add, color: Colors.white)),
      ),
    );
  }
}
