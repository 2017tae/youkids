package com.capsule.youkids.group.entity;

import java.util.UUID;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Table
@NoArgsConstructor
@IdClass(GroupPk.class)
public class GroupJoin {

//    @EmbeddedId
//    // 유저가 이 그룹에 가입했는데
//    private GroupPk pk;

    @Id
    @Column(columnDefinition = "BINARY(16)")
    private UUID groupId;

    @Id
    @Column(columnDefinition = "BINARY(16)")
    private UUID userId;

    @Column
    // 그룹 이름을 이거로 설정함
    private String groupName;

    @Builder
    public GroupJoin(UUID groupId, UUID userId, String groupName) {
        this.groupId = groupId;
        this.userId = userId;
        this.groupName = groupName;
    }

    public void updateGroupName(String groupName) {
        this.groupName = groupName;
    }


}
