package com.capsule.youkids.place.dto;

import com.capsule.youkids.place.entity.Place;
import java.util.List;
import java.util.stream.Collectors;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
public class PlaceInfoDto {

    private int placeId;
    private int regionCode;
    private String name;
    private String address;
    private Double latitude;
    private Double longitude;
    private String phoneNumber;
    private String category;
    private String homepage;
    private String description;
    private int reviewSum;
    private int reviewNum;
    private boolean subwayFlag;
    private String subwayId;
    private Double subwayDistance;
    private List<String> images;

    public PlaceInfoDto(Place place) {
        this.placeId = place.getPlaceId();
        this.regionCode = place.getVisitedReviewNum();
        this.name = place.getName();
        this.address = place.getAddress();
        this.latitude = place.getLatitude();
        this.longitude = place.getLongitude();
        this.phoneNumber = place.getPhoneNumber();
        this.category = place.getCategory();
        this.homepage = place.getHomepage();
        this.description = place.getDescription();
        this.reviewNum = place.getReviewNum();
        this.reviewSum = place.getReviewSum();
        this.subwayFlag = place.isSubwayFlag();
        this.subwayId = place.getSubwayId();
        this.subwayDistance = place.getSubwayDistance();
        this.images = place.getImages().stream().map((image)->{return image.getUrl();}).collect(
                Collectors.toList());
    }
}
