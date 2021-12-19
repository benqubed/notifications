import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notifications/noti.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    home: Notifications(),
  ));
}

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List _notifications = [];
  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('json/data.json');
    final data = await json.decode(response);
    setState(() {
      _notifications = data;
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh)), IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            return _notiCard(_notifications[index]);
          }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Customers',
          ),
        ],
      ),
    );
  }

  Widget _notiCard(notification) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 95,
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
        decoration: notification["seen"]
            ? BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300), top: BorderSide.none, right: BorderSide.none, left: BorderSide.none),
              )
            : BoxDecoration(
                color: Colors.blue.shade50,
                border: Border(bottom: BorderSide(color: Colors.grey.shade300), top: BorderSide.none, right: BorderSide.none, left: BorderSide.none),
              ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 340,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(notification["name"], style: GoogleFonts.openSans(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: [
                      TextSpan(
                        text: '${notification["status"]} ',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                      ),
                      TextSpan(
                        text: notification["message"],
                        style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
                      ),
                    ], style: GoogleFonts.openSans(color: Colors.black, fontSize: 16)
                        //TextStyle(fontSize: 18, fontFamily: 'Raleway', fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(notification["time"], style: GoogleFonts.openSans(color: Colors.grey[700], fontSize: 16)), //TextStyle(fontSize: 16, fontFamily: 'Raleway')),
                  const SizedBox(
                      child: Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
