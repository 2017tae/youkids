package com.capsule.youkids.place.repository;

import com.capsule.youkids.place.entity.BookmarkMongo;
import com.capsule.youkids.place.entity.Place;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface BookmarkMongoRepository extends MongoRepository<BookmarkMongo, String> {

}
