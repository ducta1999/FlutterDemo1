import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:simple_moment/simple_moment.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'CRUD with Mock API'),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const AddItem(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  Map userInfo = {
    "username": "",
    "dob": Moment.now().toString(),
    "password": "",
    "vehicle": "",
  };
  bool isLoading = false;
  String textStatus = "";

  addNewItem(userInfo) async {
    setState(() {
      isLoading = true;
    });
    String postAPI = "https://62df4e689c47ff309e83e1d8.mockapi.io/users";
    Map map = {
      "username": userInfo["username"],
      "dob": userInfo["dob"].toString(),
      "password": userInfo["password"],
      "vehicle": userInfo["vehicle"],
    };

    await http.post(Uri.parse(postAPI), body: map);

    Future.delayed(
        const Duration(seconds: 1),
        () => {
              setState(() {
                textStatus = "Successfully created";
                isLoading = false;
              })
            });

    Future.delayed(
        const Duration(seconds: 2),
        () => setState(() {
              textStatus = "";
            }));
  }

  @override
  Widget build(BuildContext context) {
    final _editDOBController = TextEditingController(
        text: Moment.parse(userInfo["dob"]).format("dd-MM-yyyy"));

    Widget formSection = Expanded(
        flex: 1,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(32, 9, 32, 0),
          child: Container(
            padding: const EdgeInsets.only(bottom: 0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                Lottie.network(
                  'https://assets9.lottiefiles.com/packages/lf20_g7dj7gha.json',
                  width: MediaQuery.of(context).size.width * 0.5,
                  // height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                ),
                TextFormField(
                  onChanged: (value) => userInfo["username"] = value,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Username',
                  ),
                ),
                TextFormField(
                  onChanged: (value) => userInfo["password"] = value,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                TextFormField(
                  onChanged: (value) => userInfo["vehicle"] = value,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Vehicle',
                  ),
                ),
                TextFormField(
                  controller: _editDOBController,
                  onTap: () async {
                    // Below line stops keyboard from appearing
                    FocusScope.of(context).requestFocus(FocusNode());

                    // Show Date Picker Here
                    var datePicked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.parse(userInfo["dob"]),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now());

                    if (datePicked != null) {
                      userInfo["dob"] = datePicked.toString();
                      _editDOBController.text =
                          Moment.parse(datePicked.toString())
                              .format("dd-MM-yyyy");
                    }
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Date of Birth",
                    hintText: "Ex. Insert your dob",
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 9),
                    child: Text(textStatus,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Roboto',
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w600,
                        ))),
                Container(
                    margin: const EdgeInsets.only(top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width * 0.24,
                            // height: 100.0,
                            child: RaisedButton(
                              color: Colors.grey,
                              textColor: Colors.white,
                              child: const Text('GO BACK'),
                              onPressed: () => {Navigator.pop(context)},
                            )),
                        ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width * 0.24,
                            // height: 100.0,
                            child: RaisedButton(
                                color: Colors.blue,
                                textColor: Colors.white,
                                child: isLoading
                                    ? Lottie.network(
                                        repeat: false,
                                        'https://assets8.lottiefiles.com/datafiles/8UjWgBkqvEF5jNoFcXV4sdJ6PXpS6DwF7cK4tzpi/Check Mark Success/Check Mark Success Data.json',
                                        width: 36,
                                        // height: MediaQuery.of(context).size.height,
                                        fit: BoxFit.cover,
                                      )
                                    : const Text("CREATE"),
                                onPressed: () => {addNewItem(userInfo)}))
                      ],
                    )),
              ]),
            ),
          ),
        ));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: [
              Lottie.network(
                'https://assets2.lottiefiles.com/packages/lf20_graufke1.json',
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              formSection,
            ],
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _addItem() {
    Navigator.of(context).push(_createRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(margin: const EdgeInsets.all(10), child: GetUsersList()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: _addItem,
        tooltip: 'Create',
        child: Lottie.network(
          'https://assets3.lottiefiles.com/packages/lf20_baB1GS.json',
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          fit: BoxFit.contain,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class UserModel {
  late String id;
  late String username;
  late String password;
  late String vehicle;
  late String dob;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
    required this.vehicle,
    required this.dob,
  });

  factory UserModel.fromJson(Map map) {
    return UserModel(
      id: map["id"],
      username: map["username"],
      password: map["password"],
      vehicle: map["vehicle"],
      dob: map["dob"],
    );
  }
}

class GetUsersList extends StatefulWidget {
  @override
  State<GetUsersList> createState() => _GetUsersListState();
}

class _GetUsersListState extends State<GetUsersList> {
  Future<http.Response> getData() async {
    http.Response response = await http
        .get(Uri.parse("https://62df4e689c47ff309e83e1d8.mockapi.io/users/"));
    return response;
  }

  List dataList = [];

  updateUser(userInfo) async {
    String postAPI =
        "https://62df4e689c47ff309e83e1d8.mockapi.io/users/${userInfo.id}";

    Map map = {
      "username": userInfo.username,
      "dob": userInfo.dob,
      "password": userInfo.password,
      "vehicle": userInfo.vehicle,
    };

    await http.put(Uri.parse(postAPI), body: map);
    setState(() {});
  }

  deleteUser(id) async {
    String postAPI = "https://62df4e689c47ff309e83e1d8.mockapi.io/users/${id}";

    await http.delete(
      Uri.parse(postAPI),
    );

    setState(() {});
  }

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // getData();
    super.initState();
    _controller.addListener(() {
      final String text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget loadingLottie() {
    return Center(
        child: Lottie.network(
      'https://assets3.lottiefiles.com/packages/lf20_s4tubmwg.json',
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: RefreshIndicator(
          onRefresh: () {
            return Future(() {
              setState(() {});
            });
          },
          child: FutureBuilder<http.Response>(
              future: getData(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState.toString() ==
                    "ConnectionState.waiting") {
                  loadingLottie();
                } else {
                  if (snapshot.hasData && snapshot.data != null) {
                    dataList = jsonDecode(snapshot.data!.body.toString());

                    List<UserModel> data =
                        dataList.map((e) => UserModel.fromJson(e)).toList();
                    return SingleChildScrollView(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(children: <Widget>[
                          Container(
                              color: Colors.white,
                              child: Column(children: [
                                DataTable(
                                  showCheckboxColumn: false,
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        'ID',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Username',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Vehicle',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ],
                                  rows: List.generate(data.length, (index) {
                                    var userInfo = data[index];
                                    final _editDOBController =
                                        TextEditingController(
                                            text: Moment.parse(userInfo.dob)
                                                .format("dd-MM-yyyy"));

                                    return DataRow(
                                      onSelectChanged: (selected) {
                                        if (selected != null && selected) {
                                          showModalBottomSheet<void>(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.68,
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                      radius: 30.0,
                                                      backgroundImage: NetworkImage(
                                                          "http://loremflickr.com/640/480?image=9?t=${DateTime.now().second}"),
                                                      backgroundColor:
                                                          Colors.black26,
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Column(children: [
                                                        TextFormField(
                                                          initialValue:
                                                              data[index]
                                                                  .username,
                                                          onChanged: (value) =>
                                                              userInfo.username =
                                                                  value,
                                                          decoration:
                                                              const InputDecoration(
                                                            border:
                                                                UnderlineInputBorder(),
                                                            labelText:
                                                                'Username',
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          initialValue:
                                                              data[index]
                                                                  .password,
                                                          onChanged: (value) =>
                                                              userInfo.password =
                                                                  value,
                                                          decoration:
                                                              const InputDecoration(
                                                            border:
                                                                UnderlineInputBorder(),
                                                            labelText:
                                                                'Password',
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          initialValue:
                                                              data[index]
                                                                  .vehicle,
                                                          onChanged: (value) =>
                                                              userInfo.vehicle =
                                                                  value,
                                                          decoration:
                                                              const InputDecoration(
                                                            border:
                                                                UnderlineInputBorder(),
                                                            labelText:
                                                                'Vehicle',
                                                          ),
                                                        ),
                                                        TextFormField(
                                                          controller:
                                                              _editDOBController,
                                                          onTap: () async {
                                                            // Below line stops keyboard from appearing
                                                            FocusScope.of(
                                                                    context)
                                                                .requestFocus(
                                                                    FocusNode());

                                                            // Show Date Picker Here
                                                            var datePicked = await showDatePicker(
                                                                context:
                                                                    context,
                                                                initialDate: DateTime
                                                                    .parse(data[
                                                                            index]
                                                                        .dob),
                                                                firstDate:
                                                                    DateTime(
                                                                        1900),
                                                                lastDate:
                                                                    DateTime
                                                                        .now());
                                                            if (datePicked !=
                                                                null) {
                                                              userInfo.dob =
                                                                  datePicked
                                                                      .toString();
                                                              _editDOBController
                                                                  .text = Moment.parse(
                                                                      datePicked
                                                                          .toString())
                                                                  .format(
                                                                      "dd-MM-yyyy");
                                                            }
                                                          },
                                                          decoration:
                                                              const InputDecoration(
                                                            border:
                                                                UnderlineInputBorder(),
                                                            labelText:
                                                                "Date of Birth",
                                                            hintText:
                                                                "Ex. Insert your dob",
                                                          ),
                                                        ),
                                                      ]),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 12),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                ButtonTheme(
                                                                    minWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.4,
                                                                    // height: 100.0,
                                                                    child:
                                                                        RaisedButton(
                                                                      color: Colors
                                                                          .redAccent,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      child: const Text(
                                                                          'DELETE'),
                                                                      onPressed:
                                                                          () =>
                                                                              {
                                                                        deleteUser(
                                                                            data[index].id),
                                                                        Navigator.pop(
                                                                            context)
                                                                      },
                                                                    )),
                                                                ButtonTheme(
                                                                    minWidth: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.4,
                                                                    // height: 100.0,
                                                                    child: RaisedButton(
                                                                        color: Colors
                                                                            .blueAccent,
                                                                        textColor:
                                                                            Colors
                                                                                .white,
                                                                        child: const Text(
                                                                            "EDIT"),
                                                                        onPressed:
                                                                            () =>
                                                                                {
                                                                                  updateUser(userInfo),
                                                                                  Navigator.pop(context)
                                                                                }))
                                                              ],
                                                            )))
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }
                                      },
                                      cells: <DataCell>[
                                        DataCell(Container(
                                          child: Text(
                                            '${data[index].id.toString()}',
                                            style: const TextStyle(
                                              fontSize: 13.0,
                                              fontFamily: 'Roboto',
                                              color: Color(0xFF212121),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )),
                                        DataCell(Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          child: Text(
                                            '${data[index].username.toString()}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        )),
                                        DataCell(Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          child: Text(
                                            '${data[index].vehicle.toString()}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        )),
                                      ],
                                    );
                                  }),
                                ),
                              ])),
                          // TextFormField(
                          //   controller: _controller,
                          //   onTap: () => FocusScope.of(context).unfocus(),
                          //   onChanged: (value) => {
                          //     dataList = dataList
                          //         .where((i) => i["username"].contains(value))
                          //         .toList(),
                          //     print(dataList),
                          //     // setState(() {
                          //     //   dataList = [];
                          //     // })
                          //   },
                          //   decoration: const InputDecoration(
                          //     border: UnderlineInputBorder(),
                          //     labelText: 'Search',
                          //   ),
                          // )
                        ]));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                }

                return Center(
                    child: Column(
                  children: [
                    Lottie.network(
                      'https://assets3.lottiefiles.com/packages/lf20_s4tubmwg.json',
                      width: MediaQuery.of(context).size.width,
                      // height: MediaQuery.of(context).size.height,
                      fit: BoxFit.contain,
                    ),
                    Lottie.network(
                      'https://assets6.lottiefiles.com/packages/lf20_dpgazwku.json',
                      width: MediaQuery.of(context).size.width * 0.68,
                      // height: MediaQuery.of(context).size.height,
                      fit: BoxFit.contain,
                    ),
                  ],
                ));
              }))),
    );
  }
}
