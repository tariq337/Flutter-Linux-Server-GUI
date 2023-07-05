import 'package:flutter/material.dart';

DialogWidget(context, onBuild, title) {
  showDialog(
      context: context,
      builder: (context) {
        TextEditingController textcontroll = TextEditingController();
        return AlertDialog(
          title: Text(title),
          content: TextField(
              autofocus: true,
              controller: textcontroll,
              decoration: const InputDecoration(
                labelText: "Name..",
                hintStyle: TextStyle(color: Color(0xff3c4046)),
                border: InputBorder.none,
              )),
          actions: [
            TextButton(
              onPressed: () {
                onBuild(textcontroll.text.split(' '));
                Navigator.of(context).pop();
              },
              child: const Text(
                'build',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'close',
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        );
      });
}

DialogWidgetUser(context, onBuild, title, sub) {
  showDialog(
      context: context,
      builder: (context) {
        TextEditingController textcontroll = TextEditingController();
        return AlertDialog(
          title: Text("Enter your  $title"),
          content: TextField(
              autofocus: true,
              controller: textcontroll,
              decoration: InputDecoration(
                labelText: sub,
                hintStyle: const TextStyle(color: Color(0xff3c4046)),
                border: InputBorder.none,
              )),
          actions: [
            TextButton(
              onPressed: () {
                onBuild(textcontroll.text.trim());

                Navigator.of(context).pop();
              },
              child: const Text(
                'Done',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'close',
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        );
      });
}

DialogWidgetgroups(context, onBuild, title, List<String> groups) {
  showDialog(
      context: context,
      builder: (context) {
        String nameSelect = '';
        return AlertDialog(
          title: Text("Enter your  $title"),
          content: Autocomplete<String>(
            optionsBuilder: (textcontroll) {
              return groups
                  .where((String county) => county
                      .toLowerCase()
                      .startsWith(textcontroll.text.toLowerCase()))
                  .toList();
            },
            displayStringForOption: (String option) => option,
            fieldViewBuilder: (BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted) {
              return TextField(
                controller: fieldTextEditingController,
                focusNode: fieldFocusNode,
                onChanged: (v) {
                  nameSelect = v;
                },
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
            },
            onSelected: (String selection) {
              nameSelect = selection;
            },
            optionsViewBuilder: (BuildContext context,
                AutocompleteOnSelected<String> onSelected,
                Iterable<String> options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  child: Container(
                    width: 300,
                    color: Colors.black38.withOpacity(.5),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = groups.elementAt(index);

                        return GestureDetector(
                          onTap: () {
                            onSelected(option);
                          },
                          child: ListTile(
                            title: Text(option,
                                style: const TextStyle(color: Colors.white)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                onBuild(nameSelect);

                Navigator.of(context).pop();
              },
              child: const Text(
                'Done',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'close',
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        );
      });
}
