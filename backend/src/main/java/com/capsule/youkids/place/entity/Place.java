package com.capsule.youkids.place.entity;

import java.util.ArrayList;
import java.util.List;
import lombok.*;

import javax.persistence.*;

@Entity
@Table
@Getter
@Setter
@NoArgsConstructor
public class Place {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int placeId;

    @Column
    private String name;

	@Column
	private String address;

    @Column
    private Double latitude;

    @Column
    private Double longitude;

    @Column
    private String phoneNumber;

    @Column
    private String category;

    @Column
    private String homepage;

    @Column(length = 1000)
    private String description;

    @Column(columnDefinition = "integer default 0")
    private int reviewSum;

    @Column(columnDefinition = "integer default 0")
    private int reviewNum;

    @Column(columnDefinition = "boolean default false")
    private boolean subwayFlag;

    @Column
    private String subwayId;

    @Column
    private Double subwayDistance;

    @Column
    private Integer naverReviewNum;

    @Column
    private Integer visitedReviewNum;

    @Column
    private int naverNum;

    @OneToMany(mappedBy = "place")
    private List<PlaceImage> images = new ArrayList<>();

    @OneToMany(mappedBy = "place")
    private List<Review> reviews = new ArrayList<>();

    @Builder
    public Place(int placeId, String name, String address, Double latitude, Double longitude,
            String phoneNumber, String category, String homepage, String description, int reviewSum,
            int reviewNum, boolean subwayFlag, String subwayId, Double subwayDistance,
            Integer naverReviewNum, Integer visitedReviewNum, int naverNum) {
        this.placeId = placeId;
        this.name = name;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.phoneNumber = phoneNumber;
        this.category = category;
        this.homepage = homepage;
        this.description = description;
        this.reviewSum = reviewSum;
        this.reviewNum = reviewNum;
        this.subwayFlag = subwayFlag;
        this.subwayId = subwayId;
        this.subwayDistance = subwayDistance;
        this.naverReviewNum = naverReviewNum;
        this.visitedReviewNum = visitedReviewNum;
        this.naverNum = naverNum;
    }

    public void upReviewNum() {
        this.reviewNum++;
    }

    public void downReviewNum() {
        this.reviewNum--;
    }

    public void addReviewSum(double score) {
        this.reviewSum += score;
    }

    public void subReviewSum(double score) {
        this.reviewSum -= score;
    }

    @Override
    public String toString() {
        return "Place{" +
                "placeId=" + placeId +
                ", name='" + name + '\'' +
                ", address='" + address + '\'' +
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                ", phoneNumber='" + phoneNumber + '\'' +
                ", category='" + category + '\'' +
                ", homepage='" + homepage + '\'' +
                ", description='" + description + '\'' +
                ", reviewSum=" + reviewSum +
                ", reviewNum=" + reviewNum +
                ", subwayFlag=" + subwayFlag +
                ", subwayId='" + subwayId + '\'' +
                ", subwayDistance=" + subwayDistance +
                ", naverReviewNum=" + naverReviewNum +
                ", visitedReviewNum=" + visitedReviewNum +
                ", naverNum=" + naverNum +
                '}';
    }
}