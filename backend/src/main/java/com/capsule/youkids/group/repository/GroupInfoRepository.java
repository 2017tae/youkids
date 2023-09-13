package com.capsule.youkids.group.repository;

import com.capsule.youkids.group.entity.GroupInfo;
import com.capsule.youkids.user.entity.User;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface GroupInfoRepository extends JpaRepository<GroupInfo, Long> {

//    @Query("select gi from GroupInfo gi where gi.leader = :leader")
    Optional<GroupInfo> findByLeaderId(UUID leaderId);
}
