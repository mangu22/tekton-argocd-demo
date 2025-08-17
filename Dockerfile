# ==================================================
# 첫 번째 단계: 빌드 단계 (멀티스테이지 빌드)
# - 소스 코드를 컴파일하고 JAR 파일을 생성하는 단계
# - 빌드 도구들(Maven 등)이 포함된 큰 이미지를 사용
# ==================================================
FROM openjdk:17-jdk-slim as builder

# 컨테이너 내부의 작업 디렉토리를 /app으로 설정
# 이후 모든 명령어는 이 디렉토리에서 실행됨
WORKDIR /app

# Maven 프로젝트 설정 파일(pom.xml)을 먼저 복사
# 이를 통해 의존성 정보를 확인하고 캐싱 최적화 가능
COPY pom.xml .

# 애플리케이션 소스 코드를 컨테이너의 src 디렉토리로 복사
# ./src는 호스트의 src 디렉토리, ./src는 컨테이너의 /app/src
COPY src ./src

# 패키지 매니저 업데이트 후 Maven 빌드 도구 설치
# apt-get update: 패키지 목록 업데이트
# apt-get install -y maven: Maven 설치 (-y는 자동 승인)
RUN apt-get update && apt-get install -y maven

# Maven을 사용하여 애플리케이션 빌드
# clean: 이전 빌드 결과물 삭제
# package: 컴파일 후 JAR 파일 생성
# -DskipTests: 테스트 실행 건너뛰기 (빌드 시간 단축)
RUN mvn clean package -DskipTests

# ==================================================
# 두 번째 단계: 실행 단계 (프로덕션 런타임)
# - 빌드된 JAR 파일만 가져와서 실행하는 경량화된 단계
# - 빌드 도구나 소스 코드 없이 실행에 필요한 것만 포함
# ==================================================
FROM openjdk:17-jdk-slim

# 실행 환경의 작업 디렉토리 설정
WORKDIR /app

# 첫 번째 빌드 단계(builder)에서 생성된 JAR 파일을 현재 단계로 복사
# --from=builder: 이전 단계의 파일시스템에서 가져옴
# /app/target/*.jar: 빌드된 JAR 파일 위치 (와일드카드로 파일명 자동 매칭)
# app.jar: 복사될 파일의 새로운 이름
COPY --from=builder /app/target/*.jar app.jar

# 컨테이너가 8080 포트를 사용한다고 문서화
# 실제로 포트를 열지는 않고, 다른 개발자들에게 정보 제공
# docker run -p 8080:8080 명령어로 실제 포트 매핑 필요
EXPOSE 8080

# 컨테이너가 시작될 때 실행할 기본 명령어
# java -jar app.jar: Spring Boot 애플리케이션 실행
# ENTRYPOINT는 CMD와 달리 실행 시 명령어 변경 불가
ENTRYPOINT ["java", "-jar", "app.jar"]