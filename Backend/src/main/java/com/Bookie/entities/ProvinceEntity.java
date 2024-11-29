package com.Bookie.entities;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

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

    @Column(name = "name")
    private String name;

    @ManyToOne
    @JoinColumn(name = "CountryEntity_id")
    @JsonIgnore
    private CountryEntity country;

    @Override
    public String toString() {
        return "ProvinceEntity{id=" + id + ", name='" + name + "', country=" + country.getName() + "}";
    }
}