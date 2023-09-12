package com.capsule.youkids.group.repository;

import com.capsule.youkids.group.entity.Group;
import com.capsule.youkids.group.entity.GroupPK;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GroupRepository extends JpaRepository<Group, GroupPK> {

}
