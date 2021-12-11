import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:poliquiz_app/utils/Apis.dart';
import 'dart:math';

class QuizPage extends StatefulWidget {
  const QuizPage({ Key? key, required this.categoryID, required this.title }) : super(key: key);

  final int categoryID;
  final String title;

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool isLoading = true;
  List<dynamic> quizzes = [];
  @override
  void initState() {
    super.initState();
    (() async {
      quizzes = await Apis().getTest(widget.categoryID);
      start();
      isLoading = false;
    })();
  }
  int id = 0;
  void start() {
    ended = false;
    answerID = -1;
    var rndID = Random().nextInt(quizzes.length);
    while(rndID == id) {rndID = Random().nextInt(quizzes.length);}
    id = rndID;
    setState(() {});
  }

  void end() {
    setState(() {
      ended = true;
    });
  }

  late int answerID;
  late bool ended;

  Color getTileColor(int index) {
    if(ended) {
      if(quizzes[id]['right_answer_index'] == index) {
        return Colors.green;
      } else if(index == answerID) {
        return Colors.red;
      }
      return Colors.white;
    } 
    return answerID == index? Colors.blue : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      body: LoadingOverlay(
        child: Center(
          child:isLoading? Container() : Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10), 
                child: Text(
                  "${quizzes[id]['question'].toString()} :",
                  style: const TextStyle(
                    fontSize: 25,
                  )
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: List.generate(quizzes[id]['answers'].length, (index) {
                  return ListTile(
                    title: Text(quizzes[id]['answers'][index].toString()),
                    onTap: () {
                      setState(() {
                        answerID = index;  
                      });
                    },
                    tileColor: getTileColor(index),
                  );
                }),
              ),

              quizzes[id]['explanation'].toString() != 'null' && ended? 
                Text("Spiegazione: ${quizzes[id]['explanation'].toString()}") : 
                Container(),

              ElevatedButton(
                onPressed: !ended? end : start,
                child: !ended? const Text("Rispondi") : const Text("Nuova Domanda")
              )
            ],
          )
        ),
        isLoading: isLoading,
      )
    );
  }
}