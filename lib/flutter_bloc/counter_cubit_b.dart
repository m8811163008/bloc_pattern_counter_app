import 'package:bloc/bloc.dart';

class CounterCubitB extends Cubit<String> {
  CounterCubitB() : super('Hello world!');
  void changeState(String newState) => emit(newState);
}
