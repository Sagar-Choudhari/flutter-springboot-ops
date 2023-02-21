import 'package:flutter/material.dart';
import '../Services/remote.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '../Models/lang.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Lang>? lang;
  var isLoaded = false;
  // ignore: prefer_typing_uninitialized_variables

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    lang = await BaseClient().get();
    if (lang != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  postData(lang) async {
    var result = await BaseClient().post(lang);
    if (result != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  putData(lang) async {
    var result = await BaseClient().put(lang);
    if (result != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  deleteData(id) async {
    var result = await BaseClient().delete(id);
    if (result != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  // final _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _desc = TextEditingController();

  late int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider<ButtonProvider>(
          create: (context) => ButtonProvider(),
          child: Consumer<ButtonProvider>(builder: (context, provider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _title,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _desc,
                    decoration: const InputDecoration(labelText: 'Desc'),
                  ),
                ),
                provider.wantToUpdate == true
                    ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                              child: const Text('Update'),
                              onPressed: () {
                                var uTitle = _title.text;
                                var uDesc = _desc.text;
                                provider.currentId = id.toString();
                                var lang = Lang(
                                    id: id, title: uTitle, description: uDesc);
                                putData(lang);
                                _title.clear();
                                _desc.clear();
                              },
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Delete'),
                              onPressed: () {
                                deleteData(provider.currentId);
                                _title.clear();
                                _desc.clear();
                              },
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Cancel'),
                              onPressed: () {
                                provider.wantToUpdate = false;
                                _title.clear();
                                _desc.clear();
                              },
                            ),
                          ],
                        ),
                    )
                    : Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: const Text('Add'),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')),
                                );
                                var title = _title.text;
                                var desc = _desc.text;
                                var lang = Lang(title: title, description: desc);
                                postData(lang);
                                _title.clear();
                                _desc.clear();
                              },
                            ),
                          ],
                        ),
                    ),
                FutureBuilder(
                  future: getData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<dynamic> snapshot) {
                    return Visibility(
                      visible: isLoaded,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: Expanded(
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: lang?.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Text(lang![index].title),
                                  subtitle: Text(lang![index].description),
                                  tileColor: Colors.grey.shade100,
                                  trailing: IconButton(
                                    onPressed: () {
                                      provider.checkButton(true);
                                      id = lang![index].id!;
                                      provider.currentId = id.toString();
                                      _title.text = lang![index].title;
                                      _desc.text = lang![index].description;
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    );
                  },
                ),
              ],
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add new item',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ButtonProvider extends ChangeNotifier {
  bool? wantToUpdate;
  String? currentId;
  void checkButton(bool value) {
    if (value == true) {
      wantToUpdate = true;
      notifyListeners();
    } else {
      wantToUpdate = false;
      notifyListeners();
    }
  }
}
