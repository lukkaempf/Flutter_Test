import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:testapp/utilis/services/rest_api_service.dart';
import 'package:testapp/main.dart';
import 'package:testapp/constants/api_path.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Society extends StatefulWidget {
  const Society({Key? key}) : super(key: key);

  @override
  _SocietyState createState() => _SocietyState();
}

class _SocietyState extends State<Society> {
  List societyList = [];

  Future<void> getData() async {
    List getData = await getSociety();
    print(getData);
    setState(() {
      societyList = getData;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: societyList.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 100,
            child: Row(
              children: [
                CardPopUp(
                  name: societyList[index]['name'],
                  description: societyList[index]['description'],
                  imagePath: societyList[index]['image_path'],
                )
              ],
            ),
          );
        });
  }
}

class CardPopUp extends StatefulWidget {
  final name;
  final description;
  final imagePath;
  const CardPopUp({Key? key, this.name, this.description, this.imagePath})
      : super(key: key);

  @override
  _CardPopUpState createState() => _CardPopUpState();
}

class _CardPopUpState extends State<CardPopUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 160,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: shadowcolor,
          blurRadius: 30,
          offset: const Offset(0, 20),
        ),
      ]),
      child: Card(
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: shadowcolor,
                  blurRadius: 30,
                  offset: const Offset(0, 20),
                )
              ],
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    'https://pbs.twimg.com/profile_images/945853318273761280/0U40alJG_400x400.jpg',
                  ))),
          child: Padding(
            padding: const EdgeInsets.only(top: 130),
            child: Center(
                child: Column(
              children: [
                Text(widget.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  widget.description,
                  style: TextStyle(fontSize: 13),
                ),
              ],
            )),
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.only(left: 10, right: 10),
      ),
    );
  }
}

ImageProvider<Object> getPicture1(picturePath) {
  print(picturePath);
  return CachedNetworkImageProvider(
    'https://www.bing.com/th?id=OIP.V7BMOQvjpZUSLCTqRPZ1fQHaLH&w=107&h=170&c=8&rs=1&qlt=90&o=6&dpr=1.1&pid=3.1&rm=2',
  );

  /* Uri url = Uri.parse('${constantUrl}picture/$pictureName');

  final token = await storage.read(key: 'token');

  var result = await http.get(url, headers: {
    'x-access-token': token.toString(),
  });

  File file = File(await getPictureFilePath(pictureName));
  file.writeAsBytes(result.bodyBytes);

  return ''; */
}
