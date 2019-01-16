import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'dart:io';

class ExamData {
  List<File> inputFiles;
  File file;
  ExamData(this.inputFiles, this.file);
}

class ExamBLoc {
  var _data = List<ExamData>();
  var _subject = BehaviorSubject<List<ExamData>>();

  Stream<List<ExamData>> get stream => _subject.stream;
  List<ExamData> get value => _data;

  void push(ExamData data) {
    _data.insert(0, data);
    _subject.add(_data);
  }

  void dispose() {
    _subject.close();
  }
}