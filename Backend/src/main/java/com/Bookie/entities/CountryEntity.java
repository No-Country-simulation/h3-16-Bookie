package com.Bookie.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity(name = "CountryEntity")
@Table(name = "country")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(of = "id")
public class CountryEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name")
    private String name;


    @OneToMany(mappedBy = "country", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnore
    private List<ProvinceEntity> provinces = new ArrayList<>();

    @OneToMany(mappedBy = "countries", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnore
    private List<HistoryEntity> histories = new ArrayList<>();

    public CountryEntity(String country) {
        this.name = country;
    }

    @Override
    public String toString() {
        return "CountryEntity{id=" + id + ", name='" + name + "'}";
    }
}