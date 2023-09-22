package com.capsule.youkids.group.repository;

import com.capsule.youkids.group.entity.GroupJoin;
import com.capsule.youkids.group.entity.GroupPk;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
public interface GroupJoinRepository extends JpaRepository<GroupJoin, GroupPk> {

    List<GroupJoin> findByUserIdOrderByCreatedTime(UUID userId);

    Optional<GroupJoin> findByGroupIdAndUserId(UUID groupId, UUID userId);

    List<GroupJoin> findByGroupIdOrderByCreatedTime(UUID groupId);

    @Transactional
    void deleteByGroupIdAndUserId(UUID groupId, UUID userId);
}