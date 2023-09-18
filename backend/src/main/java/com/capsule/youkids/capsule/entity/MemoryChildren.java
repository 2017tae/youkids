package com.capsule.youkids.capsule.entity;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;

@Entity
public class MemoryChildren {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column
    private long memoryChildrenId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "memory_image_id")
    private MemoryImage memoryImage;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "children_id")
    private Children children;
}
