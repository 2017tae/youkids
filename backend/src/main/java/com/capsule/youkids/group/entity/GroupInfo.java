package com.capsule.youkids.group.entity;

import java.util.UUID;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Table
@NoArgsConstructor
public class GroupInfo {
    @Id
    @Column(columnDefinition = "BINARY(16)")
    private UUID groupId;

    @Column(columnDefinition = "BINARY(16)")
    private UUID leaderId;

    @Column
    private String groupImg;

//    @OneToMany(mappedBy = "user")
//    private List<Group> groupJoinedList;

    @Builder
    public GroupInfo(UUID groupId, UUID leaderId, String groupImg) {
        this.groupId = groupId;
        this.leaderId = leaderId;
        this.groupImg = groupImg;
    }

    public void updateGroupImg(String groupImg) {
        this.groupImg = groupImg;
    }
}
