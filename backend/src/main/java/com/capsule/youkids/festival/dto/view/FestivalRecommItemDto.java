package com.capsule.youkids.festival.dto.view;

import com.capsule.youkids.festival.entity.Festival;
import java.time.LocalDate;
import java.util.Date;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class FestivalRecommItemDto {
    private Long festivalChildId;
    private String eachId;
    private String name;
    private LocalDate startDate;
    private LocalDate endDate;
    private String state;
    private String category;
    private String openRun;
    private String poster;
    private String placeName;

    public FestivalRecommItemDto(Festival festival) {
        this.festivalChildId = festival.getFestivalChildId();
        this.eachId = festival.getEachId();
        this.name = festival.getName();
        this.startDate = festival.getStartDate();
        this.endDate = festival.getEndDate();
        this.state = festival.getState();
        this.category = festival.getCategory();
        this.openRun = festival.getOpenRun();
        this.poster = festival.getPoster();
        this.placeName = festival.getPlaceName();
    }
}
