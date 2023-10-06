package com.capsule.youkids.festival.dto.response;

import com.capsule.youkids.capsule.entity.Memory;
import com.capsule.youkids.capsule.entity.Memory.MemoryBuilder;
import com.capsule.youkids.festival.dto.view.FestivalReserveDto;
import com.capsule.youkids.festival.entity.Festival;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class FestivalDetailResponseDto {

    private List<FestivalReserveDto> reserveDtoList;
    private String name;
    private LocalDate startDate;
    private LocalDate endDate;
    private String state;
    private String category;
    private String placeName;
    private String age;
    private String price;
    private String whenTime;
    private String poster;
    private List<String> images = new ArrayList<>();

    @Builder
    public FestivalDetailResponseDto(List<FestivalReserveDto> reserveDtoList, String name,
            LocalDate startDate, LocalDate endDate,
            String state,
            String category, String placeName, String age, String price, String whenTime,
            String poster, List<String> images) {
        this.name = name;
        this.startDate = startDate;
        this.endDate = endDate;
        this.state = state;
        this.category = category;
        this.placeName = placeName;
        this.age = age;
        this.price = price;
        this.whenTime = whenTime;
        this.images = images;
        this.poster = poster;
        this.reserveDtoList = reserveDtoList;
    }

    public static class FestivalDetailResponseDtoBuilder {

        private String name;
        private LocalDate startDate;
        private LocalDate endDate;
        private String state;
        private String category;
        private String placeName;
        private String age;
        private String price;
        private String whenTime;
        private String poster;

        public FestivalDetailResponseDto.FestivalDetailResponseDtoBuilder festival(
                Festival festival) {
            this.name = festival.getName();
            this.age = festival.getAge();
            this.startDate = festival.getStartDate();
            this.endDate = festival.getEndDate();
            this.state = festival.getState();
            this.category = festival.getCategory();
            this.placeName = festival.getPlaceName();
            this.price = festival.getPrice();
            this.whenTime = festival.getWhenTime();
            this.poster = festival.getPoster();
            return this;
        }
    }
}
