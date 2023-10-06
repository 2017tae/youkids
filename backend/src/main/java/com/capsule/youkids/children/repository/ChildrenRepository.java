package com.capsule.youkids.children.repository;

import com.capsule.youkids.children.dto.response.ChildrenResponse;
import com.capsule.youkids.children.entity.Children;
import com.capsule.youkids.user.entity.User;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ChildrenRepository extends JpaRepository<Children, Long> {

    // 부모 엔티티로 애기 찾기, 애기는 먼저 태어난 순서대로 정렬
    @Query("select c from Children c where c.parent = :parent order by c.birthday asc")
    List<Children> findAllByParentOrderByBirthday(@Param("parent") User parent);
}
