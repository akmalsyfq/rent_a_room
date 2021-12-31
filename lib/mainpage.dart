import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rent_a_room/roomdetails.dart';
import 'package:rent_a_room/room.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late List _roomList = [];
  String textCenter = "Loading...";
  late double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          centerTitle: true,
          title: Text(
            'Rent A Room',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              _roomList == null
                  ? const Flexible(
                      child: Center(child: Text("No Data")),
                    )
                  : Flexible(
                      child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: ListView.builder(
                            itemCount: _roomList.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return Card(
                                  color: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: InkWell(
                                    onTap: () => {(_roomdet(index))},
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          title: Text(_roomList[index]["title"],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          subtitle: Text(
                                            _roomList[index]["area"] +
                                                ", " +
                                                _roomList[index]["state"],
                                          ),
                                          trailing:
                                              Icon(Icons.favorite_outline),
                                        ),
                                        Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  ("https://slumberjer.com/rentaroom/images/" +
                                                      _roomList[index]
                                                          ["roomid"] +
                                                      "_1.jpg"),
                                                ),
                                              ),
                                            )),
                                        Container(
                                          padding: EdgeInsets.all(16.0),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            _roomList[index]["description"] +
                                                "\n" +
                                                "Price: RM " +
                                                _roomList[index]["price"],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            }),
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadRooms() async {
    var url = Uri.parse("https://slumberjer.com/rentaroom/php/load_rooms.php");
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      _roomList = parsedJson['data']['rooms'];
      textCenter = "Contain Data";
      setState(() {});
      print(_roomList);
    } else {
      textCenter = "No data";
      return;
    }
  }

  _roomdet(int index) async {
    Rooms rooms = Rooms(
        roomid: _roomList[index]['roomid'],
        contact: _roomList[index]['contact'],
        title: _roomList[index]['title'],
        description: _roomList[index]['description'],
        price: _roomList[index]['price'],
        deposit: _roomList[index]['deposit'],
        state: _roomList[index]['state'],
        area: _roomList[index]['area'],
        dateCreated: _roomList[index]['date_created'],
        latitude: _roomList[index]['latitude'],
        longitude: _roomList[index]['longitude']);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Roomdetails(
                  room: rooms,
                )));
    _loadRooms();
  }
}
