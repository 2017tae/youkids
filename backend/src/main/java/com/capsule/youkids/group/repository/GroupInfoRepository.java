package com.capsule.youkids.group.repository;

import com.capsule.youkids.group.entity.GroupInfo;
import com.capsule.youkids.user.entity.User;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface GroupInfoRepository extends JpaRepository<GroupInfo, Long> {

    @Query("select g from GroupInfo g where g.leader = :leader")
    Optional<GroupInfo> findByLeader(User leader);
}
