import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_trial/all_customers.dart';
import 'package:sqlite_trial/sql_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        ///--- for adding customers---///
        leading: CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          onPressed: () {
            buildAddCustomers(context);
          },
          child: const Text(
            'Add Customers',
            style: TextStyle(fontSize: 23),
          ),
        ),
        middle: CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (context) => buildCupertinoActionSheet(),
            );
          },
          color: CupertinoColors.destructiveRed,
          child: const Text('Show Options',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
              )),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 150),
          Container(
            height: 200,
            width: 200,
            color: CupertinoColors.activeGreen,
          ),
        ],
      ),
    );
  }

  ///--for adding customers--////
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const AllCustomers();
                        },
                      ),
                    );
                  }).then((value) => setState(() {}));
                },
                child: const Text('Yes, Add..!'),
              ),
            ],
          );
        });
  }

  CupertinoActionSheet buildCupertinoActionSheet() {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            //  SQLHelper.addCustomers(Customers());
          },
          child: const Text('Add Customers'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {},
          child: const Text('Edit Customers'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        isDestructiveAction: true,
        child: const Text('Cancel'),
      ),
    );
  }
}
