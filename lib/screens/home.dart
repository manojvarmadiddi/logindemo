import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fininfo/components/reusable_text.dart';
import 'package:fininfo/model/data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<String> currentList = [
    'Sort By name',
    'Sort By age',
    'Sort By city'
  ];
  String selectedtring = currentList[0];
  String selectedSortingValue = 'name';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  var key = GlobalKey<FormState>();
                  TextEditingController name = TextEditingController();
                  TextEditingController city = TextEditingController();
                  TextEditingController age = TextEditingController();

                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text('Add new Record'),
                            content: Form(
                              key: key,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  children: [
                                    TextWidget(controller: name, label: 'Name'),
                                    TextWidget(
                                      controller: age,
                                      label: 'Age',
                                      isNumber: true,
                                      inputType: TextInputType.number,
                                    ),
                                    TextWidget(controller: city, label: 'City'),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (!key.currentState!.validate()) {
                                              print('null .........');
                                              //Navigator.pop(context);
                                              return;
                                            } else {
                                              var model = DataModel(
                                                name: name.text,
                                                age: int.parse(age.text),
                                                city: city.text,
                                              );
                                              await FirebaseFirestore.instance
                                                  .collection('demo')
                                                  .doc()
                                                  .set(model.toMap())
                                                  .then((value) async {
                                                Navigator.pop(context);
                                                setState(() {});
                                              });
                                            }
                                          },
                                          child: Text('Save '),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel '),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ));
                },
                child: Text('Insert Record'),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('demo')
                      .orderBy(
                        selectedSortingValue,
                        descending: false,
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.size <= 0) {
                        return const Center(
                          child: Text('No data to display'),
                        );
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          //   shrinkWrap: true,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //   const Text('Sort By '),
                                DropdownButton(
                                  value: selectedtring,
                                  hint: const Text('Sort By'),
                                  icon: const Icon(Icons.arrow_downward),
                                  items: currentList.map((items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items.toString()),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    String? selected;
                                    if (newValue == currentList[0]) {
                                      selected = 'name';
                                    } else if (newValue == currentList[1]) {
                                      selected = 'age';
                                    } else {
                                      selected = 'city';
                                    }
                                    setState(() {
                                      selectedtring = newValue!;
                                      selectedSortingValue = selected!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.size,
                              itemBuilder: (context, index) {
                                var json = snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                                var model = DataModel.fromMap(json);
                                return Card(
                                  child: Column(
                                    children: [
                                      Text(model.name!),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(model.age.toString()),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(model.city!),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container(
                      child: const Text('Something went Wrong...'),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
