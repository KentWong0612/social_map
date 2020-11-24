import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Firebase/AuthenticationService.dart';
import 'camera_page.dart';
import 'SettingPageTest.dart';
import 'MapTest.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

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
        // to pass the instance to the service for doing login
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
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
                text: 'MapTest',
              ),
              Tab(
                icon: Icon(Icons.camera),
                text: 'Camera',
              ),
              Tab(
                icon: Icon(Icons.settings),
                text: 'Setting',
              ),
            ],
          ),
          title: searchBar,
          actions: [
            //IconButton(icon: searchIcon, onPressed: _pushSearch),
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
            CameraScreen(),
            SettingPageTest(),
          ],
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final category = [
    'sales',
    'society activity',
    'emergency accident',
    'Sports',
    'Special Incident',
    'In a Hurry',
    'public events',
  ];
  final recentSearch = ['hello', 'bye'];
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
    final suggestionList = query.isEmpty
        ? recentSearch
        : category.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: Icon(Icons.arrow_right),
        //title: Text(suggestionList[index]),
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
