package com.capsule.youkids.capsule.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Memory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column
    private Long memoryId;

    @Column
    private int year;

    @Column
    private int month;

    @Column
    private int day;

    @Column
    private String description;

    @Column
    private String location;

    @Column
    private boolean flag;

    @ManyToOne

}
