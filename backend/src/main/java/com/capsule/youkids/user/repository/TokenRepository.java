package com.capsule.youkids.user.repository;

import com.capsule.youkids.user.entity.Token;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TokenRepository extends JpaRepository<Token, Long> {


}
