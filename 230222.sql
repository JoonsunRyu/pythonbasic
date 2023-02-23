desc mysql.user;
describe mysql.user;  # describe = desc

##### 사용자 테이블 데이터 조회
select user, host from mysql.user;

##### 시스템 내 유저 조회
show columns from mysql.user;
show full columns from mysql.user;  # full -> 더 많은 것들이 조회됨
select Host, user from mysql.user;


##### 데이터베이스 사용자 만들기
create user 'test'@'localhost' identified by '1234';
# '아이디'@'접근 가능한 주소' identified by '비밀번호';

## 어디서든 접속 가능한 사용자 만들기
create user 'anywhere'@'%' identified by '1234';  # 어디에서나 접근 가능
select user, Host from mysql.user;
# %: 와일드카드. 어떤 값을 대체할 수 있음

## 특정 주소 내에서 접속 가능한 사용자 만들기
create user 'test2'@'192.168.0.%' identified by '1234';  # 특정 대역에서는 접근 가능
select user, Host from mysql.user;

## OR REPLACE - 이미 존재하는 사용자 이름으로 만들어도 에러 X
# 기존 사용자를 삭제하고 다시 만듦
create or replace user 'test'@'localhost' identified by '1234';  # 사용하는 pc에서만 접근 가능
select user, host from mysql.user;

## 같은 이름의 사용자가 없을 때에만 사용자를 추가한다
create user if not exists 'test'@'localhost' identified by '1234';
# 이미 있는 사용자 이름이므로 생성되지 않음
select user, host from mysql.user;


##### 사용자 이름 변경
rename user 'test2'@'192.168.0.%' to 'test3'@'%';
select user, host from mysql.user;

##### 비밀번호 변경
set password for 'test3'@'%' = password('12345');


##### 데이터베이스 사용자 삭제
# 1) User 조회
select host, user from mysql.user;
# 2) 삭제할 user 지정
drop user 'test3'@'%';

# 특정 사용자 삭제
drop user if exists 'anywhere'@'%';


##### 데이터베이스 권한 부여
show grants for 'test'@'localhost';
grant all privileges on test.* to 'test'@'localhost';
flush privileges;


##### 데이터베이스 권한 확인
show grants for 'test'@'localhost';
 ## <참고> 데이터에 대하여 취할 수 있는 것: CRUD, Create, Read, Update, Delete


##### 데이터베이스 권한 삭제
revoke all on test.* from 'test'@'localhost';
flush privileges;
show grants for 'test'@'localhost';


##### 데이터베이스 생성
show databases;

create database test;  # 'test'라는 데이터베이스 만들기
create database if not exists test;  # 이미 존재한다면 생성하지 말 것

create database `test.test`;

# 삭제
drop database `test.test`;

show databases;

# 데이터베이스 명칭 변경 - 편법. 애초에 이름을 잘 짓자!
# 프롬프트 창에서 진행. mysqldump -u root -p test > 덤프로 만든다 = 파일을 만든다


##### 테이블 만들기
create database python;
use python;
create table table1 (column1 varchar(100));  # 최대 길이가 100인 가변 문자열 테이블을 만들어라

# 테이블 목록 조회
select database();
show tables;

# 이름 변경
rename table table1 to table2;
show tables;

# 삭제
drop table table2;
show tables;


##### 테이블 생성
# 여러 개의 열 추가하기 - 콤마(,)로 구분
create table test_table(
	test_column1 int,
    test_column2 int,
    test_column3 int
);
desc test_table;

alter table test_table
add test_column4 int;
desc test_table;

alter table test_table
add(
	test_column5 int,
    test_column6 int,
    test_column7 int
);
desc test_table;

# 삭제
alter table test_table
drop test_column1;
desc test_table;

# 순서 변경 - 데이터 타입도 같이 적어야 함!
alter table test_table
modify test_column7 int  # 첫 번재 위치로
first;

desc test_table;

# 특정 위치로 이동
alter table test_table
modify test_column7 int
after test_column6;

desc test_table;

# 열 이름 변경
alter table test_table
change test_column2 test_column0 int;

desc test_table;

# 데이터 타입 변경
alter table test_table
change test_column0 test_column0 varchar(10);

desc test_table;

# 이름과 데이터 타입 동시에 변경하기
alter table test_table
change test_column0 test_column2 int;

desc test_table;
