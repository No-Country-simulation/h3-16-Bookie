package com.Bookie.service;

import com.Bookie.config.repository.CountryRepository;
import com.Bookie.config.repository.ProvinceRepository;
import com.Bookie.dto.HistoryDtoRequest;
import com.Bookie.dto.HistoryDtoRequestUpdate;
import com.Bookie.dto.HistoryDtoResponse;
import com.Bookie.entities.CountryEntity;
import com.Bookie.entities.HistoryEntity;
import com.Bookie.entities.ProvinceEntity;
import com.Bookie.entities.UserEntity;
import com.Bookie.config.repository.HistoryRepository;
import com.Bookie.config.repository.UserRepository;
import com.Bookie.enums.GenreLiterary;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class HistoryService {

    @Autowired
    private HistoryRepository historyRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProvinceRepository provinceRepository;

    @Autowired
    private CountryRepository countryRepository;

    public HistoryDtoResponse createHistory(@Valid HistoryDtoRequest historyDto) {

        ProvinceEntity country = getCountryEntityByProvinceEntity(historyDto);


        /** <p> Buscar el usuario y guardar todo en la bbdd </p> */
        Optional<UserEntity> user = userRepository.findById(historyDto.creator_id());
        HistoryEntity historyEntity = HistoryEntity.builder()
                .creator(user.get())
                .genre(historyDto.genre())
                .title(historyDto.title())
                .syopsis(historyDto.synopsis())
                .img(historyDto.img())
                .publish(false)
                .province(country)
                .build();
        HistoryEntity history = historyRepository.save(historyEntity);


        return new HistoryDtoResponse(history);

    }


    /**
     * <p>Obtener el country por la province, si no existe lo crea</p>
     */
    private ProvinceEntity getCountryEntityByProvinceEntity(HistoryDtoRequest historyDto) {

        /**<p>Traer el county desde su probincia</p>*/
        ProvinceEntity province = provinceRepository.findByName(historyDto.province().toUpperCase());
        if (province != null) return province;


        /**<p>Si no existe entonces busco el pais </p>*/
        String countryName = historyDto.country().toUpperCase();
        CountryEntity country = countryRepository.findByName(countryName);

            if (country == null) country = countryRepository.save(new CountryEntity(countryName));


        /** <p>Guardo la ciudad</p> */
        province = ProvinceEntity.builder().name(historyDto.province().toUpperCase()).country(country).build();
        province = provinceRepository.save(province);


        return province;
    }

    public List<HistoryEntity> getAll() {
        return historyRepository.findAll();

    }

    public HistoryDtoResponse updateHistory(HistoryDtoRequestUpdate historyDto, @NotNull Long id) {
        HistoryEntity history = historyRepository.findById(id).orElseThrow(() -> new EntityNotFoundException("Entity not found"));

        if (historyDto.title() != null) history.setTitle(historyDto.title());
        if (historyDto.img() != null) history.setImg(historyDto.img());
        if (historyDto.synopsis() != null) history.setSyopsis(historyDto.synopsis());
        if (historyDto.genre() != null) history.setGenre(historyDto.genre());

        HistoryEntity historyDb = historyRepository.save(history);

        return new HistoryDtoResponse(history);
    }

    public String deleteHistory(@NotNull Long id) {
        HistoryEntity history = historyRepository.findById(id).orElseThrow(() -> new EntityNotFoundException("Entity not found"));
        historyRepository.delete(history);
        return "Delete ok";
    }

    public HistoryDtoResponse publishHistory(@NotNull Long id) {
        HistoryEntity history = historyRepository.findById(id).orElseThrow(() -> new EntityNotFoundException("Entity not found"));
        history.setPublish(true);
        HistoryEntity historyDb = historyRepository.save(history);
        return new HistoryDtoResponse(history);

    }

    public HistoryDtoResponse getHistory(@NotNull Long id) {
        HistoryEntity history = historyRepository.findById(id).orElseThrow(() -> new EntityNotFoundException("Entity not found"));

        return new HistoryDtoResponse(history);

    }

    public List<HistoryDtoResponse> getHistoryByUserId(@NotNull Long userId) {
        var user = userRepository.findById(userId);
        List<HistoryEntity> history = historyRepository.findByCreator(user.get());
        if(history.isEmpty()) return new ArrayList<>();
        return history.stream().map(HistoryDtoResponse::new).toList();
    }

    public List<HistoryDtoResponse> getHistoriesByProvince(String provinceName) {
        String normalizedProvince = provinceName.toLowerCase();
        List<HistoryEntity> histories = historyRepository.findByProvinceName(normalizedProvince);
        return histories.stream().map(HistoryDtoResponse::new).toList();
    }

    public List<HistoryDtoResponse> getHistoriesByCountry(String countryName) {
        List<HistoryEntity> histories = historyRepository.findByCountryName(countryName);
        return histories.stream().map(HistoryDtoResponse::new).toList();
    }

    public List<HistoryDtoResponse> getHistoriesByGenre(GenreLiterary genre) {
        if (!EnumSet.allOf(GenreLiterary.class).contains(genre)) {
            throw new IllegalArgumentException("Invalid genre: " + genre);
        }
        List<HistoryEntity> histories = historyRepository.findByGenre(genre);
        return histories.stream().map(HistoryDtoResponse::new).toList();
    }
}
