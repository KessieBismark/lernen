import 'package:flutter/material.dart';
import 'package:lernen/utils/helpers.dart';

import 'app_config.dart';

class AIDropDown extends StatelessWidget {
  final Function(String?)? callBack;
  const AIDropDown({
    super.key,
    this.callBack,
  });

  @override
  Widget build(BuildContext context) {
    // First filter the models, then map them
    final filteredModels = Utils.aiListModels
        .where((model) => AppConfig.aiSupportedImageModels.contains(model.id))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButton<String>(
        menuMaxHeight: 500,
        isExpanded: true,
        hint: Text('Select a Model'),
        value: Utils.selectedAIModel.isEmpty ? null : Utils.selectedAIModel,
        onChanged: callBack,
        items: filteredModels.map<DropdownMenuItem<String>>((ModelInfo model) {
          print(model.id);
          return DropdownMenuItem<String>(
            value: model.id,
            child: Text(model.id),
          );
        }).toList(),
      ),
    );
  }
}
