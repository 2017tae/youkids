package com.capsule.youkids.global.s3.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.UUID;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class AwsS3ServiceImpl implements AwsS3Service {

    private final AmazonS3 amazonS3;

    @Value("${cloud.aws.s3.bucket}")
    private String bucket;

    // 파일 업로드
    public String uploadFile(MultipartFile multiFile, String type) throws IOException {
        // 파일 이름을 UUID로 생성
        String fileName = type + "/" + UUID.randomUUID(); // img 폴더에 저장

        // MIME 타입 설정
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(multiFile.getSize());
        metadata.setContentType(multiFile.getContentType());

        // Amazon S3에 업로드
        amazonS3.putObject(bucket, fileName, multiFile.getInputStream(), metadata);

        System.out.println(fileName);

        // DB에 저장하기 위한 URL 리턴
        return amazonS3.getUrl(bucket, fileName).toString();
    }

    public void deleteFile(String deleteUrl, String type) {
        String deleteFile = deleteUrl.split("/")[4];
        amazonS3.deleteObject(bucket, type + "/" + deleteFile);
    }
}

