import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fininfo/model/data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static List<String> currentList = ['name', 'age', 'city'];
  String selectedSortingValue = currentList[0];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('demo')
                .orderBy(selectedSortingValue)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.size <= 0) {
                  return const Center(
                    child: Text('No data to display'),
                  );
                }
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Sort By '),
                        DropdownButton(
                          value: selectedSortingValue,
                          hint: const Text('Sort By'),
                          icon: const Icon(Icons.arrow_downward),
                          items: currentList.map((items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items.toString()),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedSortingValue = newValue!;
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
      ),
    );
  }
}
