package com.capsule.youkids.group.entity;

import com.capsule.youkids.user.entity.User;
import javax.persistence.Column;
import javax.persistence.Embeddable;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@Table
@NoArgsConstructor
public class Group {

    @EmbeddedId
    // 유저가 이 그룹에 가입했는데
    private GroupPK groupPK;

    @Column
    // 그룹 이름을 이거로 설정함
    private String groupName;

    @Builder
    public Group(GroupInfo groupInfo, User user, String groupName) {
        GroupPK groupPK = new GroupPK(groupInfo, user);
        this.groupPK = groupPK;
        this.groupName = groupName;
    }

    public void updateGroupName(String groupName) {
        this.groupName = groupName;
    }
}
