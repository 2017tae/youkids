package com.capsule.youkids.group.repository;

import com.capsule.youkids.group.entity.Group;
import com.capsule.youkids.group.entity.GroupInfo;
import com.capsule.youkids.group.entity.GroupPK;
import com.capsule.youkids.user.entity.User;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface GroupRepository extends JpaRepository<Group, GroupPK> {

    @Query("select g from Group g where g.user = :user")
    List<Group> getAllJoinedGroup(@Param("user") User user);
}