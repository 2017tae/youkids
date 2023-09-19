package com.capsule.youkids.global.s3.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.StringTokenizer;
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

    // 이미지를 img 폴더에 저장할 경로
    private final String imgFolder = "img/";

    public String uploadImg(MultipartFile multiFile) throws IOException {
        // 파일 이름을 UUID로 생성
        String fileName = imgFolder + UUID.randomUUID() + "-" + multiFile.getOriginalFilename(); // img 폴더에 저장

        // MIME 타입 설정
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(multiFile.getSize());
        metadata.setContentType(multiFile.getContentType());

        // Content-Disposition 헤더 설정 (파일을 바로 열도록 함)
        metadata.setHeader("Content-Disposition", "inline; filename=\"" + multiFile.getOriginalFilename() + "\"");

        // Amazon S3에 업로드
        amazonS3.putObject(bucket, fileName, multiFile.getInputStream(), metadata);

        System.out.println(fileName);

        // DB에 저장하기 위한 URL 리턴
        return amazonS3.getUrl(bucket, fileName).toString();
    }

//    public String uploadImg(MultipartFile multiFile) throws IOException {
//        // img 폴더가 없으면 생성
//        File imgDir = new File(imgFolder);
//        if (!imgDir.exists()) {
//            imgDir.mkdirs();
//        }
//
//        // multiFile을 File로 변환
//        File uploadFile = convert(multiFile);
//
//        // file의 이름을 UUID로 생성
//        String fileName = imgFolder + UUID.randomUUID() + "-" + multiFile.getOriginalFilename(); // img 폴더에 저장
//
//        // amazon에 업로드
//        amazonS3.putObject(new PutObjectRequest(bucket, fileName, uploadFile).withCannedAcl(
//                CannedAccessControlList.PublicRead));
//
//        // DB에 저장하기 위한 URL 리턴
//        return amazonS3.getUrl(bucket, fileName).toString();
//    }

    public File convert(MultipartFile multiFile) throws IOException {
        String originalFileName = multiFile.getOriginalFilename();
        String filePath = imgFolder + originalFileName;
        File uploadFile = new File(filePath);
        FileOutputStream fos = new FileOutputStream(uploadFile);
        fos.write(multiFile.getBytes());
        fos.close();
        return uploadFile;
    }

    public void deleteFile(String deleteUrl) {
        StringTokenizer st = new StringTokenizer(deleteUrl, ".com/");
        st.nextToken();
        String deleteFile = st.nextToken();
        amazonS3.deleteObject(new DeleteObjectRequest(bucket, deleteFile));
    }
}

