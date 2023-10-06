package com.capsule.youkids.place.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Subway {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int subwayId;

    @Column
    private String name;

    @Column
    private double latitude;

    @Column
    private double longitude;

}
