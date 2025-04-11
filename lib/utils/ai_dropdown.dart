import 'package:flutter/material.dart';

import 'helpers.dart';

class AIDropDown extends StatelessWidget {
  final Function(String?)? callBack;
  const AIDropDown({
    super.key,
    this.callBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButton<String>(
        menuMaxHeight: 500,
        isExpanded: true,
        hint: Text('Select a Model'),
        value: Utils.selectedAIModel.isEmpty
            ? null
            : Utils.selectedAIModel,
        onChanged: callBack,
        items:
            Utils.aiListModels.map<DropdownMenuItem<String>>((ModelInfo model) {
          return DropdownMenuItem<String>(
            value: model.id,
            child: Text(model.id),
          );
        }).toList(),
      ),
    );
  }
}
