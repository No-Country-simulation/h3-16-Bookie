package com.Bookie.service;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.*;


class ChapterServiceTest {

    @Test
    void calcularDistanciaPuntosSuperficieTierra() {


        Double BarranquillaLatitud = 10.96854;
        Double BarranquillaLongitud = 74.78132;
        Double CartagenaLatitud = 10.39972;
        Double CartagenaLongitud = 75.51444;
        Double totalMetros = 96220.0;
        double distancia = ChapterService.calcularDistanciaPuntosSuperficieTierra(BarranquillaLatitud, BarranquillaLongitud, CartagenaLatitud, CartagenaLongitud);
        assertEquals(distancia, totalMetros, 0.1);

    }
}