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
    private double latitude;

    @Column
    private double longitude;

    @Column
    private String phoneNumber;

    @Column
    private String category;

    @Column
    private String homepage;

    @Column
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
    private double subwayDistance;

    @OneToMany(mappedBy = "place")
    private List<PlaceImage> images = new ArrayList<>();

    @OneToMany(mappedBy = "place")
    private List<Review> reviews = new ArrayList<>();
}