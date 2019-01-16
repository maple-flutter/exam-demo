import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import './rxdart/bloc_provider.dart';
import './rxdart/exam_bloc.dart';

class HomePage extends StatelessWidget {
  Future getImages(ExamBLoc bLoc) async {
    var images = await MultiImagePicker.pickImages(
      maxImages: 10,
      enableCamera: false,
      options: CupertinoOptions(takePhotoIcon: "chat")
    );
    print(images[0].identifier);
    print(images[0].name);
    // ByteData data = await images[0].requestOriginal();
    // List<int> imageData = data.buffer.asUint8List();
    // Image.memory(imageData);
  }
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: StreamBuilder<List<ExamData>>(
          stream: bloc.stream,
          initialData: bloc.value,
          builder: (BuildContext context, AsyncSnapshot<List<ExamData>> snapshot) {
            return Text(
              '请上传数据，目前为空',
              style: Theme.of(context).textTheme.display1,
            );
            // if (!snapshot.hasData || snapshot.data.isEmpty) {
            //   return Text(
            //     '请上传数据，目前为空',
            //     style: Theme.of(context).textTheme.display1,
            //   );
            // }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () {
          getImages(bloc);
        },
      ),
    );
  }
}