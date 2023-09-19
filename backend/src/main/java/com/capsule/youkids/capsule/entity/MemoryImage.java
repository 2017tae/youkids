package com.capsule.youkids.capsule.entity;

import java.util.List;
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
    private Long memoryImageId;

    @Column
    private String memoryUrl;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "memory_id")
    private Memory memory;

    @OneToMany(mappedBy = "memoryImage", fetch = FetchType.LAZY)
    private List<MemoryChildren> memoryChildrenList;

    @Builder
    public MemoryImage(String memoryUrl, Memory memory){
        this.memoryUrl = memoryUrl;
        this.memory =memory;
    }

    public void setChildren(List<MemoryChildren> memoryChildrenList) {
        this.memoryChildrenList = memoryChildrenList;
    }
}
