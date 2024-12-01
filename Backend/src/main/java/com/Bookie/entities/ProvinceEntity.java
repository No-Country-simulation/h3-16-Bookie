package com.Bookie.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity(name = "ProvinceEntity")
@Table(name = "Province")
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(of = "id")
public class
ProvinceEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name",unique = true)
    private String name;

    @ManyToOne
    @JoinColumn(name = "CountryEntity_id")
    @JsonIgnore
    private CountryEntity country;

    @OneToMany(mappedBy = "province", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @JsonIgnore
    private List<HistoryEntity> histories = new ArrayList<>();

    @Override
    public String toString() {
        return "ProvinceEntity{id=" + id + ", name='" + name + "', country=" + country.getName() + "}";
    }
}