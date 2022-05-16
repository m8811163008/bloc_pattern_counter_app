import 'package:bloc/bloc.dart';

/// A `CounterCubit` which manages an `int` as its state.
class CounterCubit extends Cubit<double> {
  /// initial state of the `CounterCubit` is 0
  CounterCubit() : super(0);

  ///When increment is called, the current state
  ///of the cubit is accessed via `state` and a
  ///new `state` is emitted via `emit`
  void increment() => emit(state + 1.0);

  @override
  void onChange(Change<double> change) {
    super.onChange(change);
    print('here is the change: $change');
    print(change.currentState);
    print(change.nextState);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: implement onError
    print(error);
    print(stackTrace);
    super.onError(error, stackTrace);
  }
}

/// BlockObserver can be used to observe all cubit
class MyBlockObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}

void main() {
  BlocOverrides.runZoned(() {
    // use cubit
    final cubit = CounterCubit();
    cubit.increment();
    print(cubit.state);
    cubit.close();
  }, blocObserver: MyBlockObserver());
}
