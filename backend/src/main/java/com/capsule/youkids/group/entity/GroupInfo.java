package com.capsule.youkids.group.entity;

import com.capsule.youkids.user.entity.User;
import java.util.List;
import java.util.UUID;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.web.bind.annotation.Mapping;

@Entity
@Getter
@Table
@NoArgsConstructor
public class GroupInfo {
    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long groupId;

    private UUID leaderId;

    private String groupImg;

//    @OneToMany(mappedBy = "user")
//    private List<Group> groupJoinedList;

    @Builder
    public GroupInfo(UUID leaderId, String groupImg) {
        this.leaderId = leaderId;
        this.groupImg = groupImg;
    }

    public void updateGroupImg(String groupImg) {
        this.groupImg = groupImg;
    }
}
