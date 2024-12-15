import 'package:bookie/config/constants/environment.dart';
import 'package:bookie/infrastructure/models/search_db.dart';
import 'package:bookie/presentation/widgets/search/search_item_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  final bool isCardVisible;
  final bool isSwiperVisible;
  final Function toggleCard;
  final Function toggleSwiper;
  final bool isViewListPredictions;
  final Function toggleViewListPredictions;
  final Function goAdress;

  const SearchInput({
    super.key,
    required this.isCardVisible,
    required this.isSwiperVisible,
    required this.toggleCard,
    required this.toggleSwiper,
    required this.isViewListPredictions,
    required this.toggleViewListPredictions,
    required this.goAdress,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  List<AutocompletePrediction> predictions = [];

  void placeSearch(String query) async {
    try {
      final dio = Dio();
      final response = await dio.get(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${Environment.theGoogleMapsApiKey}&language=es');

      final data = PlaceAutocompleteResponse.fromJson(response.data);

      if (data.predictions != null) {
        if (!widget.isViewListPredictions) {
          widget.toggleViewListPredictions();
        }
        setState(() {
          predictions = data.predictions!;
        });
      }
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Form(
          // child: Padding(
          //   padding: const EdgeInsets.all(16),
          //   child:
          child: TextFormField(
            onChanged: (value) {
              placeSearch(value);
            },
            onTap: () {
              if (widget.isCardVisible) {
                widget.toggleCard();
              }
              if (widget.isSwiperVisible) {
                widget.toggleSwiper();
              }
            },
            textInputAction: TextInputAction.search,
            style: TextStyle(
              fontSize: 14,
              color: isDarkmode ? Colors.white : Colors.black,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: 'Busca por dirección o lugar',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                // borderSide: BorderSide(color: Colors.green),
              ),
              fillColor: isDarkmode ? Colors.black : Colors.white,
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        if (predictions.isNotEmpty && widget.isViewListPredictions)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              height: 230,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: isDarkmode ? Colors.black : Colors.white,
                  border: Border.all(
                    color: colors.primary,
                    width: 1,
                  ),
                ),
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return SearchItemList(
                        press: () {
                          widget.goAdress(
                            predictions[index].description!,
                          );
                          widget.toggleViewListPredictions();
                        },
                        location: predictions[index].description!,
                      );
                    },
                    itemCount: predictions.length),
              ),
            ),
          ),
      ],
    );
  }
}
