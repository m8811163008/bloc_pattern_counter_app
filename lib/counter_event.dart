abstract class CounterEvent {}
//we create events here which trigger the code in block to output desire state

///We have Increment Event to increase counter in our app
class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}
