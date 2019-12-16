import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/bloc/bloc.dart';

class TriviaControls extends StatefulWidget {
  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {

  final controller = TextEditingController();
  String inputString;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Input a number"
              ),
              onChanged: (value) {
                inputString = value;
              },
              onSubmitted: (_) => dispatchConcreteNumber, // use of the keyboard GO button action
            ),

            SizedBox(height: 20),

            Row(
              children: <Widget>[

                Expanded(
                  child: RaisedButton(
                    child: Text("Search"),
                    onPressed: dispatchConcreteNumber, // dispatch a event to the bloc
                    color: Theme.of(context).accentColor,
                    textTheme: ButtonTextTheme.primary,
                  )
                ),

                SizedBox(width: 10),

                Expanded(
                    child: RaisedButton(
                      child: Text("Get Random Trivia"),
                      onPressed: dispatchRandomNumber,
                    )
                ),

              ],
            )
          ],
        )
    );
  }


  void dispatchConcreteNumber() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumberEvent(inputString));
  }

  void dispatchRandomNumber() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForRandomNumberEvent());
  }

}
