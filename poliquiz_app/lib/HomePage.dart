import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:poliquiz_app/QuizPage.dart';
import 'package:poliquiz_app/utils/Apis.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scegli una categoria"),
      ),
      body: FutureBuilder(
        future: Apis().getCategories(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occured',
                  style: const TextStyle(fontSize: 18),
                ),
              );
            } else if (snapshot.hasData) {

              final data = snapshot.data as List;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, id) => ListTile(
                  title: Text(data[id]['name']),
                  onTap:() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizPage(
                          categoryID: data[id]['id'],
                          title: data[id]['name']
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
          return LoadingOverlay(
            isLoading: true,
            opacity: 0.5,
            progressIndicator: const CircularProgressIndicator(color: Colors.blue), 
            child: Container(),
          );
        }
      ),
    );
  }
}
