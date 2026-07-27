이 프로젝트는 홈페이지 편집과 관리 기능만 존재하는 CMS를 목표로 한다.

기술 스택은 다음을 따른다.

- 데이터베이스: PostgreSQL
- 백엔드: Spring Boot
- 뷰: JSP
- 데이터 접근: MyBatis
- 인증: Spring Security + JWT 기반 로그인 기능
- 에디터: CKEditor
- MVC방식: Controller : 요청/응답 처리, Service : 비즈니스 로직, DAO : DB 접근, Mapper : mapper 접근, Mapper XML : SQL 작성, DTO/VO/Entity : 데이터 객체, Config : 설정, Exception : 예외 처리, Util : 공통 기능

구현 시에는 위 기술 조합을 기본 전제로 삼고, 관리자 중심의 콘텐츠 편집 및 운영 기능을 우선한다.
