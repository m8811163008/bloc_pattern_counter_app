import 'dart:async';

import 'package:bloc_pattern_counter_app/counter_event.dart';

class CounterBlock {
  /// Define counter variable and set its default value
  int _counter = 0;

  /// We create state controller which will be stream controller
  /// what it is going to do? Input is sink and output is stream
  final _counterStateController = StreamController<int>();
  //input
  StreamSink<int> get _inCounter => _counterStateController.sink;

  ///whenever something come to input , controller automatically output it
  // for state, exposing only a stream which output data
  /// we make counter public because we want widgets only can listening to output
  /// of counter state controller
  Stream<int> get counter => _counterStateController.stream;

  //we need some way for UI to input event for incrementing and decrementing events
  /// because this controller should only listen to event we use only sink
  /// and use public to our ui put event into this sink
  final _counterEventController = StreamController<CounterEvent>();
  StreamSink<CounterEvent> get counterEventSink => _counterEventController.sink;

  //now we should somehow connect these event sink so event comes in counterEventSink and
  // state comes out from counter stream. we can listen to counterEventController and
  // and _counterEventController will output anything comes in sink
  CounterBlock() {
    _counterEventController.stream.listen(_mapEventToState);
  }
  void _mapEventToState(CounterEvent event) {
    if (event is IncrementEvent) {
      _counter++;
    } else {
      _counter--;
    }
    _inCounter.add(_counter);
  }

  void dispose() {
    _counterEventController.close();
    _counterStateController.close();
  }
}
