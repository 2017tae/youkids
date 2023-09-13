package com.capsule.youkids.group.entity;

import com.capsule.youkids.user.entity.User;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import lombok.Builder;
import lombok.Getter;

@Entity
@Getter
@Table
@IdClass(GroupPk.class)
public class GroupJoin {

//    @EmbeddedId
//    // 유저가 이 그룹에 가입했는데
//    private GroupPK pk;

    @Id
    @ManyToOne
    @JoinColumn(name = "group_id")
    private GroupInfo groupInfo;

    @Id
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column
    // 그룹 이름을 이거로 설정함
    private String groupName;

    @Builder
    public GroupJoin(GroupInfo groupInfo, User user, String groupName) {
        this.groupInfo = groupInfo;
        this.user = user;
        this.groupName = groupName;
    }

    public void updateGroupName(String groupName) {
        this.groupName = groupName;
    }


}
