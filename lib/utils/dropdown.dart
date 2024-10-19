import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'extension.dart';
import 'waiting.dart';

class DropDownText extends StatelessWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validate;
  final List<String> list;
  final Function(String?)? onChange;

  const DropDownText(
      {super.key,
      required this.hint,
      required this.label,
      required this.controller,
      this.validate,
      this.onChange,
      required this.list});

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: hint,
          labelText: hint,
          border: OutlineInputBorder(
            gapPadding: 20,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      popupProps: PopupProps.menu(
        title: hint.toLabel(),
        showSearchBox: true,
        searchFieldProps: const TextFieldProps(
          autofocus: true,
        ),
      ),
      onChanged: onChange,
      validator: validate,
      selectedItem: controller.text,
      items: (filter, infiniteScrollProps) => list,
    );
  }
}

class DropDownText2 extends StatelessWidget {
  final String hint;
  final String label;
  final bool isLoading;
  final DropDownModel? controller;
  final bool validate;
  final List<DropDownModel> list;
  final Function(DropDownModel?)? onChange;

  const DropDownText2(
      {super.key,
      required this.hint,
      required this.label,
      this.controller,
      this.isLoading = false,
      this.validate = false,
      this.onChange,
      required this.list});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const MWaiting()
        : validate
            ? DropdownSearch<DropDownModel>(
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    hintText: hint,
                    labelText: hint,
                    border: OutlineInputBorder(
                      gapPadding: 20,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                popupProps: PopupProps.menu(
                  title: hint.toLabel(),
                  constraints: const BoxConstraints(maxHeight: 280),
                  showSearchBox: true,
                  searchFieldProps: const TextFieldProps(
                    autofocus: true,
                  ),
                ),
                selectedItem: controller,
                validator: (DropDownModel? value) =>
                    value == null ? 'Please this field is required' : null,
                onChanged: onChange,
                items: (filter, infiniteScrollProps) => list,
                itemAsString: (DropDownModel u) => u.name,
              )
            : DropdownSearch<DropDownModel>(
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    hintText: hint,
                    labelText: hint,
                    border: OutlineInputBorder(
                      gapPadding: 10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                popupProps: PopupProps.menu(
                  title: hint.toLabel(),
                  showSearchBox: true,
                  searchFieldProps: const TextFieldProps(
                    autofocus: true,
                  ),
                ),
                selectedItem: controller,
                onChanged: onChange,
                compareFn: (item1, item2) => item1.id == item2.id,
                items: (filter, infiniteScrollProps) => list,
                itemAsString: (DropDownModel u) => u.name.capitalize!,
              );
  }
}

class DropDownModel {
  final String id;
  final String name;

  DropDownModel({required this.id, required this.name});
}

class CusModel {
  final String id;
  final String name;
  final double? discount;
  final String? contact;
  final double? creditLimit;
  final double? totalDeposit;
  final double? creditUsed;
  CusModel({
    required this.id,
    required this.name,
    this.discount = 1,
    this.contact,
    this.totalDeposit,
    this.creditUsed,
    this.creditLimit,
  });
}

class CusDropDown extends StatelessWidget {
  final String hint;
  final String label;
  final bool isLoading;
  final CusModel? controller;
  final String? Function(CusModel?)? validate;
  final List<CusModel> list;
  final Function(CusModel?)? onChange;

  const CusDropDown(
      {super.key,
      required this.hint,
      required this.label,
      this.controller,
      this.isLoading = false,
      this.validate,
      this.onChange,
      required this.list});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const MWaiting()
        : DropdownSearch<CusModel>(
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                hintText: hint,
                labelText: hint,
                border: OutlineInputBorder(
                  gapPadding: 20,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            popupProps: PopupProps.menu(
              title: hint.toLabel(),
              showSearchBox: true,
              searchFieldProps: const TextFieldProps(
                autofocus: true,
              ),
            ),
            selectedItem: controller,
            validator: validate,
            onChanged: onChange,
            items: (filter, infiniteScrollProps) => list,
            itemAsString: (CusModel u) => u.name,
          );
  }
}
