import 'package:bookie/domain/entities/genre_entity.dart';

class GenreMapper {
  // Mapeo de String del backend a los valores del enum
  static Genre mapStringToEnum(String genreString) {
    switch (genreString) {
      case "NOVELA":
        return Genre.novela;
      case "CUENTO":
        return Genre.cuento;
      case "CIENCIA_FICCION":
        return Genre.cienciaFiccion;
      case "FANTASIA":
        return Genre.fantasia;
      case "ROMANCE":
        return Genre.romance;
      case "MISTERIO":
        return Genre.misterio;
      case "SUSPENSO":
        return Genre.suspenso;
      case "TERROR":
        return Genre.terror;
      case "HISTORICO":
        return Genre.historico;
      case "DISTOPICO":
        return Genre.distopico;
      case "UTOPIA":
        return Genre.utopia;
      case "WESTERN":
        return Genre.western;
      case "GOTICO":
        return Genre.gotico;
      case "EPICO":
        return Genre.epico;
      case "REALISMO_MAGICO":
        return Genre.realismoMagico;
      case "SURREALISMO":
        return Genre.surrealismo;
      default:
        return Genre.novela; // Si no coincide, puedes manejar el error
    }
  }
}

extension GenreExtension on Genre {
  String get displayName {
    switch (this) {
      case Genre.novela:
        return "Novela";
      case Genre.cuento:
        return "Cuento";
      case Genre.cienciaFiccion:
        return "Ciencia ficción";
      case Genre.fantasia:
        return "Fantasía";
      case Genre.romance:
        return "Romance";
      case Genre.misterio:
        return "Misterio";
      case Genre.suspenso:
        return "Suspenso";
      case Genre.terror:
        return "Terror";
      case Genre.historico:
        return "Histórico";
      case Genre.distopico:
        return "Distópico";
      case Genre.utopia:
        return "Utopía";
      case Genre.western:
        return "Western";
      case Genre.gotico:
        return "Gótico";
      case Genre.epico:
        return "Épico";
      case Genre.realismoMagico:
        return "Realismo mágico";
      case Genre.surrealismo:
        return "Surrealismo";
    }
  }
}

extension GenreToStringExtension on Genre {
  String get toBackendString {
    switch (this) {
      case Genre.novela:
        return "NOVELA";
      case Genre.cuento:
        return "CUENTO";
      case Genre.cienciaFiccion:
        return "CIENCIA_FICCION";
      case Genre.fantasia:
        return "FANTASIA";
      case Genre.romance:
        return "ROMANCE";
      case Genre.misterio:
        return "MISTERIO";
      case Genre.suspenso:
        return "SUSPENSO";
      case Genre.terror:
        return "TERROR";
      case Genre.historico:
        return "HISTORICO";
      case Genre.distopico:
        return "DISTOPICO";
      case Genre.utopia:
        return "UTOPIA";
      case Genre.western:
        return "WESTERN";
      case Genre.gotico:
        return "GOTICO";
      case Genre.epico:
        return "EPICO";
      case Genre.realismoMagico:
        return "REALISMO_MAGICO";
      case Genre.surrealismo:
        return "SURREALISMO";
    }
  }
}
