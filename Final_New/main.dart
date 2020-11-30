import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'EventDetailPage.dart';
import 'Firebase/AuthenticationService.dart';
import 'Firebase/MapEventProvider.dart';
import 'MapFab.dart';
import 'camera_page.dart';
import 'SettingPage.dart';
import 'Map.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

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
        ChangeNotifierProvider<EventTableFromDB>(
          create: (context) =>
              EventTableFromDB(FirebaseDatabase.instance.reference()),
        ),
        // to pass the instance to the service for doing login
        Provider<AuthenticationService>(
          create: (context) => AuthenticationService(FirebaseAuth.instance),
        ),
        // access to the getter function of the service so as to listen to the change
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.map),
                text: 'Map',
              ),
              Tab(
                icon: Icon(Icons.settings),
                text: 'Setting',
              ),
              Tab(
                icon: Icon(Icons.camera),
                text: 'Camera',
              ),
            ],
          ),
          title: searchBar,
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                })
          ],
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            MapTestScreen(),
            SettingPage(),
            CameraScreen(),
          ],
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  //TODOL recent search not working
  final recentSearch = [];
  EventTableFromDB eventTableDB;

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
    eventTableDB = context.watch<EventTableFromDB>();
    final suggestionList = query.isEmpty
        ? recentSearch
        : eventTableDB.eventMap.keys
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () async {
          recentSearch.add(suggestionList[index]);
          close(context, null);
          final navigator = Navigator.of(context);
          await navigator.push(MaterialPageRoute(
              builder: (context) => DetailScreenPage(suggestionList[index])));
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
