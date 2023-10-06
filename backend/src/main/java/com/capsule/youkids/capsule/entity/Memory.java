package com.capsule.youkids.capsule.entity;

import com.capsule.youkids.capsule.dto.MemoryUpdateRequestDto;
import com.capsule.youkids.global.time.BaseTimeEntity;
import com.capsule.youkids.user.entity.User;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;
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
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor
public class Memory extends BaseTimeEntity {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long memoryId;

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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "capsule_id")
    private Capsule capsule;

    @OneToMany(mappedBy = "memory", cascade = CascadeType.ALL)
    private List<MemoryImage> memoryImages;

    @Builder
    public Memory(String description, String location, Capsule capsule,
            List<MemoryImage> memoryImages) {
        LocalDate ld = LocalDate.now((ZoneId.of("Asia/Seoul")));

        this.year = ld.getYear();
        this.month = ld.getMonthValue();
        this.day = ld.getDayOfMonth();
        this.flag = true;
        this.description = description;
        this.location = location;
        this.capsule = capsule;
        this.memoryImages = memoryImages;
    }

    public static class MemoryBuilder {

        private int year;
        private int month;
        private int day;

        public MemoryBuilder date() {
            this.year = LocalDate.now(ZoneId.of("Asia/Seoul")).getYear();
            this.month = LocalDate.now(ZoneId.of("Asia/Seoul")).getMonthValue();
            this.day = LocalDate.now(ZoneId.of("Asia/Seoul")).getDayOfMonth();
            return this;
        }
    }

    public void setCapsule(Capsule capsule) {
        this.capsule = capsule;
    }

    public void setMemoryImages(List<MemoryImage> memoryImages) {
        this.memoryImages = memoryImages;
    }

    public void updateMemory(MemoryUpdateRequestDto dto) {
        this.location = dto.getLocation();
        this.description = dto.getDescription();
    }
}
