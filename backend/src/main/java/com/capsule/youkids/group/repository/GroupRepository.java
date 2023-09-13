package com.capsule.youkids.group.repository;

import com.capsule.youkids.group.entity.GroupJoin;
import com.capsule.youkids.group.entity.GroupInfo;
import com.capsule.youkids.group.entity.GroupPk;
import com.capsule.youkids.user.entity.User;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GroupRepository extends JpaRepository<GroupJoin, GroupPk> {

//    @Query("select g from Group g where g.user = :user")
    List<GroupJoin> findByUser(User user);
    Optional<GroupJoin> findByGroupInfoAndUser(GroupInfo groupInfo, User user);

    void deleteByGroupInfoAndUser(GroupInfo groupInfo, User user);
}