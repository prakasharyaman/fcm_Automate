import 'package:fcm_automate/provider/articleprovider.dart';
import 'package:fcm_automate/provider/fcmprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final fcmProvider = Provider.of<FcmProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Consumer(
        builder: (context, ArticleProvider provider, _) {
          switch (provider.getArticlesState) {
            case ArticlesState.Loading:
              provider.createArticleList(category: 'general');
              // if Loading then show loading indicator
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ArticlesState.Loaded:
              // function for getting different category news
              var artList = provider.categoryList(category: 'general');
              fcmProvider.sendNotifications(articles: artList);
              return Center(
                child: Text('Loaded'),
              );
            case ArticlesState.Error:
              return AlertDialog(
                title: Text('Error'),
                content: Text('Something went wrong'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
          }
        },
      ),
    );
  }
}
