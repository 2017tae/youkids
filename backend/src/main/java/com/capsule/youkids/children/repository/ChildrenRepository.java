package com.capsule.youkids.children.repository;

import com.capsule.youkids.children.entity.Children;
import com.capsule.youkids.user.entity.User;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChildrenRepository extends JpaRepository<Children, Long> {

    // 애기 id로 애기 찾기
    @Override
    Optional<Children> findById(Long childrenId);

    // 부모 id로 애기 찾기, 애기는 먼저 태어난 순서대로 정렬
    List<Children> findAllByParentIdOrderByBirthday(UUID id);
}
