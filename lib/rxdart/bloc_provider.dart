import 'package:flutter/material.dart';

import './exam_bloc.dart';

class BlocProvider extends InheritedWidget {
  final ExamBLoc bLoc = ExamBLoc();

  BlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static ExamBLoc of(BuildContext context) => 
      (context.inheritFromWidgetOfExactType(BlocProvider) as BlocProvider).bLoc;
}