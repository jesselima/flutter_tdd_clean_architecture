import 'package:flutter/material.dart';
import 'package:flutter_tdd_clean_architecture/features/number_trivia/domain/entities/number_trivia_entity.dart';

class TriviaDisplay extends StatelessWidget {

  final NumberTriviaEntity numberTriviaEntity;

  const TriviaDisplay({
    Key key,
    @required this.numberTriviaEntity
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          children: [
            Text(
              numberTriviaEntity.number.toString(),
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    numberTriviaEntity.text,
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}