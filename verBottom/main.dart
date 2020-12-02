import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'EventDetailPage.dart';
import 'Firebase/AuthenticationService.dart';
import 'Firebase/MapEventProviderFS.dart';
import 'MapFab copy.dart';
import 'MapFab.dart';
import 'TestingTabPage.dart';
import 'camera_page.dart';
import 'SettingPage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//TODO: changed authservice.dart ge user from cutom to firebase one, test if login still work
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: HomePage(),
    ),
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Icon searchIcon = Icon(Icons.search);
  Widget searchBar = Text('Social Map');

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventTableFromDBFS>(
          create: (context) => EventTableFromDBFS(FirebaseFirestore.instance),
        ),
        // to pass the instance to the service for doing login
        Provider<AuthenticationService>(
          create: (context) => AuthenticationService(FirebaseAuth.instance),
        ),
        // access to the getter function of the service so as to listen to the change
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        //insert auth service before materialapp
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget searchBar = Text('Social Map');
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      debugPrint(firebaseUser.email);
    }
    List<Widget> widget_list = [MapFabScreen2(), SettingPage(), TestingTabPage()];
    return BottomNavigatorView(widget_list);
  }
}

class BottomNavigatorView extends StatefulWidget {
  final List<Widget> screens;
  BottomNavigatorView(this.screens);
  @override
  _BottomNavigatorViewState createState() => _BottomNavigatorViewState();
}

class _BottomNavigatorViewState extends State<BottomNavigatorView> {
  int _selectedIndex = 0;
  MapFabScreen mapScreenWidget;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBar = Text('Social Map');
    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              })
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: widget.screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  //TODOL recent search not working
  final recentSearch = [];
  EventTableFromDBFS eventTableDB;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 100,
        color: Colors.red,
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    eventTableDB = context.watch<EventTableFromDBFS>();
    final suggestionList = query.isEmpty ? recentSearch : eventTableDB.eventMapFS.keys.where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () async {
          recentSearch.add(suggestionList[index]);
          close(context, null);
          final navigator = Navigator.of(context);
          await navigator.push(MaterialPageRoute(builder: (context) => DetailScreenPage(suggestionList[index])));
        },
        leading: Icon(Icons.arrow_right),
        title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                children: [
              TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle(color: Colors.grey),
              ),
            ])),
      ),
      itemCount: suggestionList.length,
    );
  }
}
