import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:multi_image_picker/asset.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:zoomable_image/zoomable_image.dart';
import 'asset_view.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Asset> images = List<Asset>();
  String out = '';
  String title = '试题切割演示';
  String message = '请上传图片 (一次性按顺序上传一套试卷)';
  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        return AssetView(index, images[index]);
      }),
    );
  }

  Future<void> uploadImages(List<Asset> as) async {
    Uri uri = Uri.parse('http://123.57.249.120:5000/up_photo');
    MultipartRequest request = MultipartRequest('POST', uri);
    print(as);
    for (var img in as) {
      print('========');
      ByteData byteData =  await img.requestOriginal();
      MultipartFile multipartFile = MultipartFile.fromBytes(
        'files',
        byteData.buffer.asUint8List(),
        filename: img.name,
        contentType: MediaType("image", "jpg")
      );
      print(multipartFile);
      request.files.add(multipartFile);
    }
    print(request.files);
    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join(); // decodes on response data using UTF8.decoder
    Map data = json.decode(responseData);
    print(data);
    if (data.isNotEmpty && data['success'] == 0) {
      setState(() {
        images = as;
        out = data['out'];
        message = '请上传图片 (一次性按顺序上传一套试卷)';
      });
    } else {
      setState(() {
        images = as;
        message = '解析失败，请查看试卷是否符合规范';
      });
    }
    
  }

  Future<void> loadAssets(BuildContext context) async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
      );
    } catch (e) {
      print(e.toString());
      // showDialog<void>(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text("发送了错误"),
      //       content: Center(
      //         child: Text(e.message),
      //       )
      //     );
      //   }
      // );
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    if (resultList.isNotEmpty) {
      await uploadImages(resultList);
    }

  }

  @override
  Widget build(BuildContext context) {
    Widget outView;
    if (out != null && out != "") {
      outView = ZoomableImage(
        NetworkImage(out),
        placeholder: const Center(child: const CircularProgressIndicator()),
        backgroundColor: Colors.black12
      );
    } else {
      outView = Text(message);
    }
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: Text(title),
        ),
        body: outView,
        // body: Column(
        //   children: <Widget>[
        //     outView,
        //     Expanded(
        //       child: buildGridView(),
        //     )
        //   ],
        // ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_a_photo),
          onPressed: () {
            loadAssets(context);
          }
        ),
      ),
    );
  }
}