import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = TextStyle(fontSize: 18.0);
  final _saved = <WordPair>{};

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
        key: UniqueKey(),
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        });
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  Widget _pushSaved() {
    // void _pushSaved() {
    // Navigator.of(context)
    //     .push(MaterialPageRoute<void>(builder: (BuildContext context) {
    //   final tiles = _saved.map((WordPair pair) {
    //     return ListTile(
    //         title: Text(
    //       pair.asPascalCase,
    //       style: _biggerFont,
    //     ));
    //   });
    //   final divided =
    //       ListTile.divideTiles(context: context, tiles: tiles).toList();

    //   return Scaffold(
    //     appBar: AppBar(title: Text('Saved Suggestions')),
    //     body: ListView(children: divided),
    //   );
    // }));

    final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
      return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        onTap: () {
          final SnackBar snackBar = SnackBar(
            content: Text(pair.asPascalCase),
            duration: Duration(seconds: 1),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      );
    });
    final divided = tiles.isEmpty
        ? List<Widget>.empty()
        : ListTile.divideTiles(context: context, tiles: tiles).toList();

    return Scaffold(
      // appBar: AppBar(title: Text('Saved Suggestions')),
      body: ListView(children: divided),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Like some things'),
      // ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.account_balance)),
                Tab(icon: Icon(Icons.favorite))
              ],
            ),
          ),
          body: TabBarView(
            children: [_buildSuggestions(), _pushSaved()],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Startup Name Generator'),
    //     actions: [
    //       IconButton(
    //         icon: Icon(Icons.list),
    //         onPressed: _pushSaved,
    //       )
    //     ],
    //   ),
    //   body: _buildSuggestions(),
    // );
  }
}
