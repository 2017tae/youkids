package com.capsule.youkids.group.entity;

import com.capsule.youkids.user.entity.User;
import java.io.Serializable;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;


@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@NoArgsConstructor
public class GroupPk implements Serializable {

    @EqualsAndHashCode.Include
    private GroupInfo groupInfo;

    @EqualsAndHashCode.Include
    private User user;
}
