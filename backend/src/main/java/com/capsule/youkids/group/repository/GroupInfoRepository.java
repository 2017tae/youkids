package com.capsule.youkids.group.repository;

import com.capsule.youkids.group.entity.GroupInfo;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GroupInfoRepository extends JpaRepository<GroupInfo, UUID> {

    Optional<GroupInfo> findByLeaderId(UUID leaderId);
}
