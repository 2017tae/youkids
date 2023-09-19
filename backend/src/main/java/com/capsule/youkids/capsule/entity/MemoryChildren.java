package com.capsule.youkids.capsule.entity;

import com.capsule.youkids.children.entity.Children;
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
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
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

    @Builder
    public MemoryChildren(MemoryImage memoryImage, Children children){
        this.memoryImage = memoryImage;
        this.children = children;
    }
}
