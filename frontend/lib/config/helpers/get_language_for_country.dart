import 'package:bookie/config/constants/general.dart';

String getLanguageForCountry(String country) {
  // Comprobación de las listas sin duplicados
  if (CountriesList.countriesSpanish.contains(country)) {
    return "es";
  } else if (CountriesList.countriesPortuguese.contains(country)) {
    return "pt";
  } else if (CountriesList.countriesEnglish.contains(country)) {
    return "en";
  } else if (CountriesList.countriesFrench.contains(country)) {
    return "fr";
  } else if (CountriesList.countriesItalian.contains(country)) {
    return "it";
  } else {
    return "en"; // Valor por defecto si el país no está en las listas
  }
}
