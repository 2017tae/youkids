package com.capsule.youkids.children.entity;

import com.capsule.youkids.user.entity.User;
import java.time.LocalDate;
import java.util.UUID;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Table
@NoArgsConstructor
public class Children {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // 애기 고유 id
    private long childrenId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    // 애기 다 - 부모 일
    // 유저 엔티티에 mappedby해서 애기 리스트 넣을지
    private User parent;

    @Column
    // 애기 이름(글자 수 제한?)
    private String name;

    @Column
    // 애기 성별: 0 - 남자, 1 - 여자
    private int gender;

    @Column
    // 애기 생일
    private LocalDate birthday;

    @Column(nullable = true)
    // 애기 사진
    private String childrenImage;

    // 애기 성향

    @Builder
    public Children(User parent, String name, int gender, LocalDate birthday, String childrenImage) {
        this.parent = parent;
        this.name = name;
        this.gender = gender;
        this.birthday = birthday;
        this.childrenImage = childrenImage;
    }

    public void updateChildren(String name, int gender, LocalDate birthday, String childrenImage) {
        this.name = name;
        this.gender = gender;
        this.birthday = birthday;
        this.childrenImage = childrenImage;
    }
}
