import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_trial/sql_helper.dart';

class AllCustomers extends StatefulWidget {
  const AllCustomers({super.key});

  @override
  State<AllCustomers> createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  late String newName;
  late String newPhone;
  late String newCity;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: CupertinoTextField(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CupertinoColors.black.withOpacity(.4),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: SQLHelper.fetchCustomers(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text('Edit Customer'),
                                  content: Material(
                                    color: Colors.transparent,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 12),
                                        // CupertinoTextFormFieldRow(
                                        //     decoration: const BoxDecoration(),
                                        //     initialValue:
                                        //         '${snapshot.data![index]['name']}'),
                                        CupertinoTextField(
                                          placeholder:
                                              '${snapshot.data![index]['name']}',
                                          onChanged: (value) {
                                            newName = value;
                                            // setState(() {});
                                          },
                                        ),
                                        const SizedBox(height: 5),
                                        CupertinoTextField(
                                          placeholder: snapshot.data![index]
                                                  ['phone']
                                              .toString(),
                                          onChanged: (value) {
                                            newPhone = value;
                                          },
                                        ),
                                        const SizedBox(height: 5),
                                        CupertinoTextField(
                                          placeholder: snapshot.data![index]
                                                  ['city']
                                              .toString(),
                                          onChanged: (value) {
                                            newCity = value;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Don\'t edit'),
                                    ),

                                    ///----update detail button---///
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        SQLHelper.updateCustomers(Customers(
                                                id: snapshot.data![index]['id'],
                                                name: newName.toString(),
                                                phone: newPhone.toString(),
                                                city: snapshot.data![index]
                                                    ['city']))
                                            .whenComplete(() {
                                          setState(() {});
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: const Text('yes, edit'),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          child: ListTile(
                            leading: Text(
                              snapshot.data![index]['id'].toString(),
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![index]['name'].toString(),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      snapshot.data![index]['city'].toString(),
                                    ),
                                    Text(snapshot.data![index]['phone']
                                        .toString()),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                SQLHelper.deleteSingleCustomer(
                                        snapshot.data![index]['id'])
                                    .whenComplete(() => setState(() {}));
                              },
                              icon: const Icon(
                                CupertinoIcons.delete,
                                color: CupertinoColors.destructiveRed,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 1,
          backgroundColor: Colors.transparent,
          onPressed: () {
            ///--for adding customers--////
            buildAddCustomers(context);
          },
          child: const Icon(
            CupertinoIcons.add,
          ),
        ),
      ),
    );
  }

  ///---- function created to add customers to database---///
  Future<dynamic> buildAddCustomers(BuildContext context) {
    return showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Add Customers?'),
            content: Column(
              children: [
                const SizedBox(height: 15),

                ///--ask for name--///
                CupertinoTextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  placeholder: 'Enter Name',
                  minLines: 1,
                ),
                const SizedBox(height: 10),

                ///--ask for phone--///
                CupertinoTextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  placeholder: 'Enter Phone',
                  minLines: 1,
                  maxLength: 10,
                ),
                const SizedBox(height: 10),

                ///--ask for city--///
                CupertinoTextField(
                  controller: cityController,
                  keyboardType: TextInputType.name,
                  placeholder: 'Enter City',
                  minLines: 1,
                ),
              ],
            ),
            actions: [
              ///--- for aborting the add operation---///
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              ///---for final adding the customers to the database---///
              CupertinoDialogAction(
                onPressed: () {
                  SQLHelper.addCustomers(
                    Customers(
                        name: nameController.text,
                        phone: phoneController.text,
                        city: cityController.text),
                  ).whenComplete(() {
                    nameController.clear();
                    phoneController.clear();
                    cityController.clear();
                    Navigator.pop(context);
                    setState(() {});
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return const AllCustomers();
                    //     },
                    //   ),
                    // );
                  });
                },
                child: const Text('Yes, Add..!'),
              ),
            ],
          );
        });
  }
}
