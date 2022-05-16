import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'counter_cubit.dart';

void main() {
  runApp(const CounterApp());
}

///We successfully separated our presentation layer from
///our business logic layer.
class CounterApp extends StatelessWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => CounterCubit(),
        child: const CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEven = context.select((CounterCubit c) => c.state.isEven);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
      ),
      //BlockBuilder<Bloc1, BlocAState>
      //if the bloc parameter is omitted, lookup using
      // BlockProvider and the current BuildContext
      //only specify bloc if you wish to provide
      // a bloc that be scoped to a single widget
      //and isn't accessible via a parent `BlockProvider` and the
      //current `BuildContext`
      body: Column(
        children: [
          BlocBuilder<CounterCubit, int>(
            builder: (context, count) => Center(
              child: Text('simple blocBuilder $count'),
            ),
          ),
          BlocBuilder<CounterCubit, int>(
            buildWhen: (previousState, currentState) {
              return currentState.isOdd;
            },
            builder: (context, count) => Center(
              child: Text('simple blocBuilder with buildWhen $count is odd '),
            ),
          ),
          BlocSelector<CounterCubit, int, bool>(selector: (state) {
            return state.isOdd;
          }, builder: (context, booleanState) {
            return Text(
                'blocSelector base on current state which returns ${booleanState ? "odd" : "even"} state');
          }),
          Text(
              'use BlockProvider.of<T>(context) from BlocProvider which is ${BlocProvider.of<CounterCubit>(context, listen: true).state}'),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    child: const NewPage(),
                    value: context.read<CounterCubit>(),
                  ),
                ),
              );
            },
            child: const Text('Click to navigate to new page'),
          ),
          BlocSelector<CounterCubit, int, bool>(
            selector: (_) => isEven,
            builder: (context, booleanState) =>
                Text('the isEven is $booleanState'),
          ),
        ],
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('new page for state'),
      ),
      body: Center(
        child: Text(
            'use context.watch<CounterCubit>() to show this state: ${context.watch<CounterCubit>().state}'),
      ),
    );
  }
}
