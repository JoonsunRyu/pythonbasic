show databases;
create database alpha;
use alpha;

##### AUTO-INCREMENT
create table test (
	id int auto_increment primary key
);
desc test;  # 테이블에 대해 어떤 것을 갖고 있는지 확인하기 위해 조회함


##### 생성 값 살펴보기
insert into test values ();  # into와 test 사이에 열이름 생략 / value의 ()에 들어갈 내용도 생략
select * from test;  # 반영여부 조회 / *: 모든 필드에 대해서 조회 / from 뒤에는 테이블 이름
  # 10행을 반복 실행하면 하나 큰 값이 반복해서 들어감. 1, 2, 3...
select max(id);

insert into test values (100);  # 다른 숫자 건너뛰고 100 입력
select * from test;
insert into test values ();

delete from test where id = 101;  # 101 삭제
insert into test values ();  # 102 추가됨
select * from test;

delete from test;
select * from test;
ALTER table test auto_increment = 1;  # 1로 바뀌려면 데이터가 아무것도 없어야 함

show table status where name = 'test';

# 아무렇게나 자료 입력
insert into test values ();
select * from test;
insert into test values (17);
select * from test;
insert into test values ();

##### 숫자 재정렬
set @count = 0;
update test set id = @count:=@count + 1;  # 입력되어 있던 id를 1부터 다시 매길 때 사용
select * from test;


##### 테이블 데이터 추가
create table table1 (
	column1 varchar(100),
    column2 varchar(100),
    column3 varchar(100)
);

desc table1;

insert into table1 (column1, column2, column3) values ('a', 'aa', 'aaa');
# 각 열에 값을 1줄씩 넣어줌
select * from table1;  # where절 불필요

insert into table1 (column1, column2) values ('b', 'bb');
# 각 열에 값을 1줄씩 넣어줌
select * from table1;  # column3에 NULL 생김 (넣은 것이 없으므로)

## 수정
update table1 set column1 = 'z';
select * from table1;

update table1 set column1 = 'x' where column2 = 'aa';
select * from table1;

update table1
	set column1 = 'y'
      , column2 = 'yy'
  where column3 = 'aaa';
select * from table1;

## 삭제
delete from table1 where column1 = 'y';
select * from table1;


##### 테스트용 테이블 생성
drop table if exists day_visitor_realtime;

create table if not exists day_visitor_realtime (
	ipaddress varchar(16),
    iptime_first datetime,
    before_url varchar(250),
    device_info varchar(40),
    os_info varchar(40),
    session_id varchar(80)
);

# 값 입력
insert into day_visitor_realtime (
	ipaddress, iptime_first, before_url, device_info)
values ('192.165.0.0', '2023-02-23 11:34:22', 'localhost', 'PC');

select * from day_visitor_realtime;
desc day_visitor_realtime;

insert into day_visitor_realtime (
	ipaddress, iptime_first, before_url, device_info)
		  # varchar(16)
values ('12345678901234567', '2023-02-23 11:34:30', 'localhost', 'PC');
# 에러 발생  -> varchar(16)에 17자리 값을 넣어서


insert into `day_visitor_realtime` (`session_id`) values ('12345.567890');
insert into `day_visitor_realtime` (`session_id`) values ('1234.567890');
insert into `day_visitor_realtime` (`session_id`) values ('123');
insert into `day_visitor_realtime` (`session_id`) values ('1235');
insert into `day_visitor_realtime` (`session_id`) values ('456313');

select * from day_visitor_realtime;


##### 무결성 제약조건
DROP TABLE IF EXISTS day_visitor_realtime;
CREATE TABLE day_visitor_realtime (
   ipaddress varchar(16) NOT NULL,
  iptime_first datetime,
before_url varchar(250),
device_info varchar(40),
	os_info varchar(40),
session_id varchar(80)
);

INSERT INTO day_visitor_realtime (
ipaddress, iptime_first, before_url, device_info, os_info
/*session_id*/)
VALUES ('asdf', NOW(), 'aa', 'asdf', 'aa');
SELECT * FROM day_visitor_realtime;

# 에러 발생 - ipaddress는 NULL이 되면 안 되므로
INSERT INTO day_visitor_realtime (
/*ipaddress*/  # 주석 처리
iptime_first, before_url, device_info, os_info
/*session_id*/)
VALUES (NOW(), 'aa', 'asdf', 'aa');


## PRIMARY KEY
DROP TABLE IF EXISTS day_visitor_realtime;
CREATE TABLE day_visitor_realtime (
  id INT,
  ipaddress varchar(16),
  iptime_first datetime,
  before_url varchar(250),
  device_info varchar(40),
  os_info varchar(40),
  session_id varchar(80),
  PRIMARY KEY(id)
);

select * from day_visitor_realtime;

# 기본키에 같은 값 2번 넣으면 오류 발생
INSERT INTO day_visitor_realtime (
id, ipaddress, iptime_first, before_url, device_info, os_info
/*session_id*/)
VALUES (1, 'asdf', NOW(), 'aa', 'asdf', 'aa')
, (1, 'asdf2', NOW(), 'aa2', 'asdf2', 'aa2');


##### FOREIGN KEY
CREATE TABLE orders (
  order_id INT,
  customer_id INT,
  order_date DATETIME,
  PRIMARY KEY(order_id)
);

insert into orders values(1, 1, now());
select * from orders;

insert into orders values(1, 1, now());
insert into orders values(2, 1, now());
insert into orders values(3, 1, now());
select * from orders;

CREATE TABLE order_detail (
  order_id INT,
  product_id INT,
  product_name VARCHAR(200),
  order_date DATETIME,
  CONSTRAINT FK_ORDERS_ORDERID FOREIGN KEY (order_id) REFERENCES orders(order_id),
  PRIMARY KEY(order_id, product_id)
);

insert into order_detail (order_id, product_id, product_name)
values(1, 100, 'iPhone')
	, (1, 101, 'iPad');
select * from order_detail;

# 에러 발생 - PK에는 4가 없는데 FK에서 4로 지정했으므로
insert into order_detail (order_id, product_id, product_name)
values (4, 100, 'iPhone')
	 , (4, 101, 'iPad');


##### employees 실습
show databases;
use employees;

### SELECT문
select * from departments;
# select * from titles;  # 너무 많이 실행됨 -> 무엇을 출력할 지 추려야 함

# DISTINCT절 - column에 대한 유일한 값 추출 (중복 제거)
select distinct title from titles;

# WHERE절 - 데이터를 필터링하고 싶을 때
select * from salaries where salary > 150000;

# 연습 문제
select * from dept_manager where emp_no = 111133;

# AND, OR, NOT, BETWEEN, LIKE
select * from dept_manager where emp_no between 111133 and 111939;
select * from employees where first_name like 'Geo%';

# 연습 문제2
select * from titles where title = 'Senior Engineer' and from_date > 2002-6-1;

# ORDERBY, INSERT INTO, NULL, UPDATE, DELETE, SELECT LIMIT
# 집계함수 COUNT(), AVG()
# Aliases
# JOIN - inner join, left join, right join, 
# UNION, UNION ALL, GROUIP BY, HAVING, EXISTS
# CASE 표현식
# IFNULL





