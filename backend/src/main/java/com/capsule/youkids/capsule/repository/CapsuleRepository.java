package com.capsule.youkids.capsule.repository;

import com.capsule.youkids.capsule.entity.Capsule;
import com.capsule.youkids.user.entity.User;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CapsuleRepository extends JpaRepository<Capsule, Integer> {

    /**
     * 유저를 사용해 모든 캡슐을 리턴 받는다.
     *
     * @param user 유저를 통해 검색한다.
     * @return List<Capsule> 검색하고자 하는 유저의 모든 캡슐을 가져온다.
     */
    List<Capsule> findAllByUser(User user);
}
