// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:tuhoc_cty/chapter16/journal_edit_bloc.dart';

class JournalEditBlocProvider extends InheritedWidget {
  final JournalEditBloc journalEditBloc;

  JournalEditBlocProvider({
    Key? key,
    required this.journalEditBloc,
    required Widget child,
  }) : super(key: key, child: child);

  static JournalEditBlocProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<JournalEditBlocProvider>();
  }

  @override
  bool updateShouldNotify(JournalEditBlocProvider oldWidget) {
    return journalEditBloc != oldWidget.journalEditBloc;
  }
}
