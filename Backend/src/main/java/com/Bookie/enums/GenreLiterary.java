package com.Bookie.enums;

import java.util.Arrays;
import java.util.List;

public enum GenreLiterary {
    NOVELA("Novel"),
    CUENTO("Short Story"),
    CIENCIA_FICCION("Science Fiction"),
    FANTASIA("Fantasy"),
    ROMANCE("Romance"),
    MISTERIO("Mystery"),
    SUSPENSO("Thriller"),
    TERROR("Horror"),
    HISTORICO("Historical Fiction"),
    DISTOPICO("Dystopian"),
    UTOPIA("Utopian"),
    WESTERN("Western"),
    GOTICO("Gothic"),
    EPICO("Epic"),
    REALISMO_MAGICO("Magical Realism"),
    SURREALISMO("Surrealism");

    private final String descripcion;

    GenreLiterary(String descripcion) {

        this.descripcion = descripcion;
    }

    public String getDescripcion() {

        return descripcion;
    }

    public static List<GenreLiterary> getGenreList(){
        return Arrays.stream(GenreLiterary.values()).toList();
    }
}
