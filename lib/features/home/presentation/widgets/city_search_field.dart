import 'package:flutter/material.dart';
import 'package:weather_application/core/domain/location/city.dart';

import '../../../../styles/styles.dart';

class CityField extends StatefulWidget {
  final List<CityModel> cities;
  final Function(CityModel) onCitySelected;

  const CityField({
    super.key,
    required this.cities,
    required this.onCitySelected,
  });

  @override
  CityFieldState createState() => CityFieldState();
}

class CityFieldState extends State<CityField> {
  // add a controller for the search field
  // _ Underscore for class name - makes it private to the library
  final TextEditingController _searchController = TextEditingController();

  // focusNode to detect when the search field is focused
  final FocusNode _searchFocusNode = FocusNode();

  // list to store filtered cities
  List<CityModel> filteredCities = [];

  @override
  void initState() {
    super.initState();
    // initialize filteredCities with all cities
    filteredCities = widget.cities;
    // add a listener to the search controller
    _searchController.addListener(_filterCities);
  }

  // dispose - утилизация
  @override
  void dispose() {
    _searchController.dispose(); // dispose the controller
    _searchFocusNode.dispose(); // dispose the focusNode
    super.dispose();
  }

  // Filter cities based on search input
  void _filterCities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredCities = widget.cities
          .where((city) => city.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: searchFieldDecoration.copyWith(
            suffixIcon: IconButton(
              onPressed: () => _searchController.clear(),
              icon: const Icon(Icons.close),
            ),
          ),
        ),
        if (_searchFocusNode.hasFocus)
          Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: containerDecoration,
            height: 150,
            child: RawScrollbar(
              thumbVisibility: true, // Всегда показывать полосу прокрутки
              thickness: 6, // Толщина полосы прокрутки
              radius: const Radius.circular(3),
              child: ListView.builder(
                itemCount: filteredCities.length,
                itemBuilder: (context, index) {
                  final city = filteredCities[index];
                  return ListTile(
                    title: Text(city.name),
                    onTap: () {
                      widget.onCitySelected(city);
                      _searchController.clear();
                      _searchFocusNode.unfocus();
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
