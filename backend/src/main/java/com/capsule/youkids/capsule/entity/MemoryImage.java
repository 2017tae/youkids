package com.capsule.youkids.capsule.entity;

import java.util.ArrayList;
import java.util.List;
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
public class MemoryImage {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long memoryImageId;

    @Column
    private String memoryUrl;

    @ManyToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "memory_id")
    private Memory memory;

    @OneToMany(mappedBy = "memoryImage", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<MemoryChildren> memoryChildrenList = new ArrayList<>();

    @Builder
    public MemoryImage(String memoryUrl, Memory memory){
        this.memoryUrl = memoryUrl;
        this.memory =memory;
    }

    public void setChildren(List<MemoryChildren> memoryChildrenList) {
        this.memoryChildrenList = memoryChildrenList;
    }
}
