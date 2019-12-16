import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter_tdd_clean_architecture/injection_container.dart';


class NumberTriviaPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Number Trivia")
      ),
      body: SingleChildScrollView( child: buildBody(context),)

    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      builder: (_) => getIt<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[

              SizedBox(height: 10),

              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state is Empty) {
                      return MessageDisplay(message: "Start Searching",);
                    } else if (state is Loading) {
                      return LoadingWidget();
                    } else if (state is Loaded) {
                      return TriviaDisplay(numberTriviaEntity: state.numberTriviaEntity);
                    } else if (state is Error) {
                      return MessageDisplay(message: state.message,);
                    } else {
                      return null;
                    }
                  }
              ),

              SizedBox(height: 20),

              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }

}





