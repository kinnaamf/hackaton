/*
 Navicat Premium Dump SQL

 Source Server         : driver
 Source Server Type    : PostgreSQL
 Source Server Version : 180006 (180006)
 Source Host           : localhost:5432
 Source Catalog        : postgres
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 180006 (180006)
 File Encoding         : 65001

 Date: 03/10/2026 19:18:21
*/


-- ----------------------------
-- Sequence structure for cls_penalizare_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."cls_penalizare_id_seq";
CREATE SEQUENCE "public"."cls_penalizare_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for cot_zile_examen_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."cot_zile_examen_id_seq";
CREATE SEQUENCE "public"."cot_zile_examen_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for ex_tentativa_penalizare_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."ex_tentativa_penalizare_id_seq";
CREATE SEQUENCE "public"."ex_tentativa_penalizare_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for imp_incarcare_load_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."imp_incarcare_load_id_seq";
CREATE SEQUENCE "public"."imp_incarcare_load_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for rec_recenzie_review_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."rec_recenzie_review_id_seq";
CREATE SEQUENCE "public"."rec_recenzie_review_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for reg_candidat_candidate_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."reg_candidat_candidate_id_seq";
CREATE SEQUENCE "public"."reg_candidat_candidate_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for reg_instructor_instructor_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."reg_instructor_instructor_id_seq";
CREATE SEQUENCE "public"."reg_instructor_instructor_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for reg_instruire_training_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."reg_instruire_training_id_seq";
CREATE SEQUENCE "public"."reg_instruire_training_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for reg_oficiu_office_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."reg_oficiu_office_id_seq";
CREATE SEQUENCE "public"."reg_oficiu_office_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for reg_scoala_auto_school_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."reg_scoala_auto_school_id_seq";
CREATE SEQUENCE "public"."reg_scoala_auto_school_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for reg_scoala_filiala_branch_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."reg_scoala_filiala_branch_id_seq";
CREATE SEQUENCE "public"."reg_scoala_filiala_branch_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for reg_vehicul_vehicle_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."reg_vehicul_vehicle_id_seq";
CREATE SEQUENCE "public"."reg_vehicul_vehicle_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for usr_utilizator_user_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."usr_utilizator_user_id_seq";
CREATE SEQUENCE "public"."usr_utilizator_user_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for cls_categorie
-- ----------------------------
DROP TABLE IF EXISTS "public"."cls_categorie";
CREATE TABLE "public"."cls_categorie" (
  "category_id" int2 NOT NULL,
  "category_code" varchar(5) COLLATE "pg_catalog"."default" NOT NULL,
  "parent_category_code" varchar(5) COLLATE "pg_catalog"."default",
  "description_ro" text COLLATE "pg_catalog"."default",
  "description_en" text COLLATE "pg_catalog"."default",
  "description_ru" text COLLATE "pg_catalog"."default",
  "min_age" int2,
  "sort_order" int2,
  "is_active" bool NOT NULL DEFAULT true
)
;

-- ----------------------------
-- Records of cls_categorie
-- ----------------------------

-- ----------------------------
-- Table structure for cls_localitate
-- ----------------------------
DROP TABLE IF EXISTS "public"."cls_localitate";
CREATE TABLE "public"."cls_localitate" (
  "locality_id" int4 NOT NULL,
  "district_id" int2 NOT NULL,
  "cuatm_code" varchar(10) COLLATE "pg_catalog"."default",
  "name_ro" varchar(150) COLLATE "pg_catalog"."default" NOT NULL,
  "name_ru" varchar(150) COLLATE "pg_catalog"."default",
  "locality_type" varchar(20) COLLATE "pg_catalog"."default",
  "latitude" numeric(9,6),
  "longitude" numeric(9,6)
)
;

-- ----------------------------
-- Records of cls_localitate
-- ----------------------------

-- ----------------------------
-- Table structure for cls_penalizare
-- ----------------------------
DROP TABLE IF EXISTS "public"."cls_penalizare";
CREATE TABLE "public"."cls_penalizare" (
  "id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "penalty_id" int4 NOT NULL,
  "category_code" varchar(5) COLLATE "pg_catalog"."default" NOT NULL,
  "practice_type_id" int2 NOT NULL,
  "points" int2 NOT NULL,
  "sort_order" int2,
  "description_ro" text COLLATE "pg_catalog"."default" NOT NULL,
  "description_en" text COLLATE "pg_catalog"."default",
  "description_ru" text COLLATE "pg_catalog"."default",
  "is_eliminatory" bool NOT NULL DEFAULT false,
  "is_active" bool NOT NULL DEFAULT true
)
;

-- ----------------------------
-- Records of cls_penalizare
-- ----------------------------

-- ----------------------------
-- Table structure for cls_raion
-- ----------------------------
DROP TABLE IF EXISTS "public"."cls_raion";
CREATE TABLE "public"."cls_raion" (
  "district_id" int2 NOT NULL,
  "code" varchar(10) COLLATE "pg_catalog"."default",
  "name_ro" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "name_ru" varchar(100) COLLATE "pg_catalog"."default",
  "district_type" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'raion'::character varying
)
;

-- ----------------------------
-- Records of cls_raion
-- ----------------------------

-- ----------------------------
-- Table structure for cls_rezultat
-- ----------------------------
DROP TABLE IF EXISTS "public"."cls_rezultat";
CREATE TABLE "public"."cls_rezultat" (
  "result_id" int2 NOT NULL,
  "code" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "name_ro" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "name_en" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "name_ru" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "is_final" bool NOT NULL DEFAULT true,
  "is_passed" bool NOT NULL DEFAULT false,
  "is_counted" bool NOT NULL DEFAULT true
)
;

-- ----------------------------
-- Records of cls_rezultat
-- ----------------------------
INSERT INTO "public"."cls_rezultat" VALUES (1, 'sustinut', 'Susținut', 'Passed', 'Сдан', 't', 't', 't');
INSERT INTO "public"."cls_rezultat" VALUES (2, 'nesustinut', 'Nu este susținut', 'Failed', 'Не сдан', 't', 'f', 't');
INSERT INTO "public"."cls_rezultat" VALUES (3, 'in_proces', 'În proces', 'In progress', 'В процессе', 'f', 'f', 'f');
INSERT INTO "public"."cls_rezultat" VALUES (4, 'anulat', 'Rezultat anulat', 'Result cancelled', 'Результат аннулирован', 't', 'f', 'f');
INSERT INTO "public"."cls_rezultat" VALUES (5, 'motive_tehnice', 'Tentativa nu a avut loc din motive tehnice', 'Attempt not held for technical reasons', 'Попытка не состоялась по техническим причинам', 't', 'f', 'f');

-- ----------------------------
-- Table structure for cls_rezultat_alias
-- ----------------------------
DROP TABLE IF EXISTS "public"."cls_rezultat_alias";
CREATE TABLE "public"."cls_rezultat_alias" (
  "raw_value" varchar(150) COLLATE "pg_catalog"."default" NOT NULL,
  "result_id" int2 NOT NULL
)
;

-- ----------------------------
-- Records of cls_rezultat_alias
-- ----------------------------
INSERT INTO "public"."cls_rezultat_alias" VALUES ('Susținut', 1);
INSERT INTO "public"."cls_rezultat_alias" VALUES ('Susţinut', 1);
INSERT INTO "public"."cls_rezultat_alias" VALUES ('Susюinut', 1);
INSERT INTO "public"."cls_rezultat_alias" VALUES ('Nu este susținut', 2);
INSERT INTO "public"."cls_rezultat_alias" VALUES ('Nu este susţinut', 2);
INSERT INTO "public"."cls_rezultat_alias" VALUES ('Nu este susюinut', 2);
INSERT INTO "public"."cls_rezultat_alias" VALUES ('În proces', 3);
INSERT INTO "public"."cls_rezultat_alias" VALUES ('Оn proces', 3);
INSERT INTO "public"."cls_rezultat_alias" VALUES ('Rezultat anulat', 4);
INSERT INTO "public"."cls_rezultat_alias" VALUES ('Tentativa nu a avut loc din motive tehnice', 5);

-- ----------------------------
-- Table structure for cls_rol
-- ----------------------------
DROP TABLE IF EXISTS "public"."cls_rol";
CREATE TABLE "public"."cls_rol" (
  "role_id" int2 NOT NULL,
  "code" varchar(30) COLLATE "pg_catalog"."default" NOT NULL,
  "name_ro" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "name_en" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "name_ru" varchar(100) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of cls_rol
-- ----------------------------
INSERT INTO "public"."cls_rol" VALUES (1, 'administrator', 'Administrator', 'Administrator', 'Администратор');
INSERT INTO "public"."cls_rol" VALUES (2, 'autoritate', 'Autoritate de monitorizare', 'Supervisory authority', 'Надзорный орган');
INSERT INTO "public"."cls_rol" VALUES (3, 'scoala', 'Reprezentant școală auto', 'Driving school representative', 'Представитель автошколы');
INSERT INTO "public"."cls_rol" VALUES (4, 'cursant', 'Cursant', 'Student', 'Курсант');
INSERT INTO "public"."cls_rol" VALUES (5, 'vizitator', 'Vizitator', 'Guest', 'Гость');

-- ----------------------------
-- Table structure for cls_tip_examen
-- ----------------------------
DROP TABLE IF EXISTS "public"."cls_tip_examen";
CREATE TABLE "public"."cls_tip_examen" (
  "exam_type_id" int2 NOT NULL,
  "code" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "name_ro" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "name_en" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "name_ru" varchar(50) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of cls_tip_examen
-- ----------------------------
INSERT INTO "public"."cls_tip_examen" VALUES (1, 'teoretic', 'Teoretic', 'Theoretical', 'Теоретический');
INSERT INTO "public"."cls_tip_examen" VALUES (2, 'practic', 'Practic', 'Practical', 'Практический');

-- ----------------------------
-- Table structure for cls_tip_practica
-- ----------------------------
DROP TABLE IF EXISTS "public"."cls_tip_practica";
CREATE TABLE "public"."cls_tip_practica" (
  "practice_type_id" int2 NOT NULL,
  "code" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "name_ro" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "name_en" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "name_ru" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "max_penalty_points" int4
)
;

-- ----------------------------
-- Records of cls_tip_practica
-- ----------------------------
INSERT INTO "public"."cls_tip_practica" VALUES (3, 'poligon', 'Poligon', 'Training ground', 'Полигон', NULL);
INSERT INTO "public"."cls_tip_practica" VALUES (4, 'oras', 'Traseu în oraș', 'City traffic', 'Город', NULL);

-- ----------------------------
-- Table structure for cls_zi_saptamana
-- ----------------------------
DROP TABLE IF EXISTS "public"."cls_zi_saptamana";
CREATE TABLE "public"."cls_zi_saptamana" (
  "weekday_id" int2 NOT NULL,
  "name_ro" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "name_en" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "name_ru" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "is_weekend" bool NOT NULL DEFAULT false,
  "iso_day_order" int2 NOT NULL
)
;

-- ----------------------------
-- Records of cls_zi_saptamana
-- ----------------------------
INSERT INTO "public"."cls_zi_saptamana" VALUES (0, 'duminică', 'sunday', 'воскресенье', 't', 7);
INSERT INTO "public"."cls_zi_saptamana" VALUES (1, 'luni', 'monday', 'понедельник', 'f', 1);
INSERT INTO "public"."cls_zi_saptamana" VALUES (2, 'marți', 'tuesday', 'вторник', 'f', 2);
INSERT INTO "public"."cls_zi_saptamana" VALUES (3, 'miercuri', 'wednesday', 'среда', 'f', 3);
INSERT INTO "public"."cls_zi_saptamana" VALUES (4, 'joi', 'thursday', 'четверг', 'f', 4);
INSERT INTO "public"."cls_zi_saptamana" VALUES (5, 'vineri', 'friday', 'пятница', 'f', 5);
INSERT INTO "public"."cls_zi_saptamana" VALUES (6, 'sâmbătă', 'saturday', 'суббота', 't', 6);

-- ----------------------------
-- Table structure for cot_teorie_parametri
-- ----------------------------
DROP TABLE IF EXISTS "public"."cot_teorie_parametri";
CREATE TABLE "public"."cot_teorie_parametri" (
  "category_code" varchar(5) COLLATE "pg_catalog"."default" NOT NULL,
  "valid_from" date NOT NULL DEFAULT '2000-01-01'::date,
  "valid_to" date,
  "exam_duration_sec" int4,
  "questions_total" int2,
  "correct_required" int2
)
;

-- ----------------------------
-- Records of cot_teorie_parametri
-- ----------------------------

-- ----------------------------
-- Table structure for cot_zile_examen
-- ----------------------------
DROP TABLE IF EXISTS "public"."cot_zile_examen";
CREATE TABLE "public"."cot_zile_examen" (
  "id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "office_id" int4 NOT NULL,
  "exam_type_id" int2 NOT NULL DEFAULT 1,
  "year" int2 NOT NULL,
  "weekday_id" int2 NOT NULL,
  "attempts_urgent" int4 NOT NULL DEFAULT 0,
  "attempts_normal" int4 NOT NULL DEFAULT 0,
  "attempts_total" int4 GENERATED ALWAYS AS (
(attempts_urgent + attempts_normal)
) STORED
)
;

-- ----------------------------
-- Records of cot_zile_examen
-- ----------------------------

-- ----------------------------
-- Table structure for ex_examen
-- ----------------------------
DROP TABLE IF EXISTS "public"."ex_examen";
CREATE TABLE "public"."ex_examen" (
  "exam_id" int8 NOT NULL,
  "exam_type_id" int2 NOT NULL,
  "candidate_id" int4 NOT NULL,
  "category_code" varchar(5) COLLATE "pg_catalog"."default" NOT NULL,
  "training_id" int4,
  "school_id" int4,
  "result_id" int2,
  "attempts_total" int2 NOT NULL DEFAULT 0,
  "first_attempt_date" date,
  "last_attempt_date" date,
  "passed_date" date,
  "is_passed_first_attempt" bool,
  "load_id" int4,
  "created_at" timestamptz(6) NOT NULL DEFAULT now(),
  "updated_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of ex_examen
-- ----------------------------

-- ----------------------------
-- Table structure for ex_tentativa_penalizare
-- ----------------------------
DROP TABLE IF EXISTS "public"."ex_tentativa_penalizare";
CREATE TABLE "public"."ex_tentativa_penalizare" (
  "id" int8 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1
),
  "attempt_id" int8 NOT NULL,
  "category_code" varchar(5) COLLATE "pg_catalog"."default" NOT NULL,
  "penalty_id" int4 NOT NULL,
  "quantity" int2 NOT NULL DEFAULT 1,
  "points" int4 NOT NULL,
  "load_id" int4
)
;

-- ----------------------------
-- Records of ex_tentativa_penalizare
-- ----------------------------

-- ----------------------------
-- Table structure for ex_tentativa_practica
-- ----------------------------
DROP TABLE IF EXISTS "public"."ex_tentativa_practica";
CREATE TABLE "public"."ex_tentativa_practica" (
  "attempt_id" int8 NOT NULL,
  "exam_id" int8 NOT NULL,
  "exam_type_id" int2 NOT NULL DEFAULT 2,
  "attempt_number" int2 NOT NULL,
  "exam_date" date NOT NULL,
  "weekday_id" int2 NOT NULL,
  "result_id" int2,
  "practice_type_id" int2 NOT NULL,
  "vehicle_id" int4,
  "office_id" int4,
  "examiner_id" int4,
  "instructor_id" int4,
  "start_time" time(6),
  "finish_time" time(6),
  "duration_sec" int4,
  "total_points" int4 NOT NULL DEFAULT 0,
  "candidate_age" int2,
  "is_urgent" bool NOT NULL DEFAULT false,
  "load_id" int4
)
;

-- ----------------------------
-- Records of ex_tentativa_practica
-- ----------------------------

-- ----------------------------
-- Table structure for ex_tentativa_teorie
-- ----------------------------
DROP TABLE IF EXISTS "public"."ex_tentativa_teorie";
CREATE TABLE "public"."ex_tentativa_teorie" (
  "attempt_id" int8 NOT NULL,
  "exam_id" int8 NOT NULL,
  "exam_type_id" int2 NOT NULL DEFAULT 1,
  "attempt_number" int2 NOT NULL,
  "exam_date" date NOT NULL,
  "weekday_id" int2 NOT NULL,
  "result_id" int2,
  "office_id" int4,
  "examiner_id" int4,
  "workstation" varchar(10) COLLATE "pg_catalog"."default",
  "start_time" time(6),
  "finish_time" time(6),
  "duration_sec" int4,
  "questions_answered" int2,
  "correct_answers" int2,
  "wrong_answers" int2,
  "candidate_age" int2,
  "is_urgent" bool NOT NULL DEFAULT false,
  "load_id" int4
)
;

-- ----------------------------
-- Records of ex_tentativa_teorie
-- ----------------------------

-- ----------------------------
-- Table structure for imp_incarcare
-- ----------------------------
DROP TABLE IF EXISTS "public"."imp_incarcare";
CREATE TABLE "public"."imp_incarcare" (
  "load_id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "source_file" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "target_table" varchar(63) COLLATE "pg_catalog"."default" NOT NULL,
  "rows_total" int4,
  "rows_loaded" int4,
  "rows_rejected" int4,
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'in_proces'::character varying,
  "error_message" text COLLATE "pg_catalog"."default",
  "started_at" timestamptz(6) NOT NULL DEFAULT now(),
  "finished_at" timestamptz(6)
)
;

-- ----------------------------
-- Records of imp_incarcare
-- ----------------------------

-- ----------------------------
-- Table structure for rec_recenzie
-- ----------------------------
DROP TABLE IF EXISTS "public"."rec_recenzie";
CREATE TABLE "public"."rec_recenzie" (
  "review_id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "school_id" int4 NOT NULL,
  "user_id" int4 NOT NULL,
  "training_id" int4,
  "category_code" varchar(5) COLLATE "pg_catalog"."default",
  "rating_overall" int2 NOT NULL,
  "rating_theory" int2,
  "rating_practice" int2,
  "rating_instructors" int2,
  "rating_vehicles" int2,
  "rating_price" int2,
  "title" varchar(200) COLLATE "pg_catalog"."default",
  "comment_text" text COLLATE "pg_catalog"."default",
  "is_verified_graduate" bool NOT NULL DEFAULT false,
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'in_asteptare'::character varying,
  "moderated_by" int4,
  "moderated_at" timestamptz(6),
  "created_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of rec_recenzie
-- ----------------------------

-- ----------------------------
-- Table structure for reg_candidat
-- ----------------------------
DROP TABLE IF EXISTS "public"."reg_candidat";
CREATE TABLE "public"."reg_candidat" (
  "candidate_id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "idnp" char(13) COLLATE "pg_catalog"."default" NOT NULL,
  "lastname" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "firstname" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "birth_date" date,
  "sex" char(1) COLLATE "pg_catalog"."default",
  "locality_id" int4,
  "phone" varchar(30) COLLATE "pg_catalog"."default",
  "email" varchar(150) COLLATE "pg_catalog"."default",
  "created_at" timestamptz(6) NOT NULL DEFAULT now(),
  "updated_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of reg_candidat
-- ----------------------------

-- ----------------------------
-- Table structure for reg_examinator
-- ----------------------------
DROP TABLE IF EXISTS "public"."reg_examinator";
CREATE TABLE "public"."reg_examinator" (
  "examiner_id" int4 NOT NULL,
  "office_id" int4,
  "lastname" varchar(100) COLLATE "pg_catalog"."default",
  "firstname" varchar(100) COLLATE "pg_catalog"."default",
  "is_active" bool NOT NULL DEFAULT true
)
;

-- ----------------------------
-- Records of reg_examinator
-- ----------------------------

-- ----------------------------
-- Table structure for reg_instructor
-- ----------------------------
DROP TABLE IF EXISTS "public"."reg_instructor";
CREATE TABLE "public"."reg_instructor" (
  "instructor_id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "school_id" int4,
  "idnp" char(13) COLLATE "pg_catalog"."default",
  "lastname" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "firstname" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "instructor_license_number" varchar(50) COLLATE "pg_catalog"."default",
  "license_expiry_date" date,
  "experience_years" int2,
  "is_active" bool NOT NULL DEFAULT true
)
;

-- ----------------------------
-- Records of reg_instructor
-- ----------------------------

-- ----------------------------
-- Table structure for reg_instructor_categorie
-- ----------------------------
DROP TABLE IF EXISTS "public"."reg_instructor_categorie";
CREATE TABLE "public"."reg_instructor_categorie" (
  "instructor_id" int4 NOT NULL,
  "category_code" varchar(5) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of reg_instructor_categorie
-- ----------------------------

-- ----------------------------
-- Table structure for reg_instruire
-- ----------------------------
DROP TABLE IF EXISTS "public"."reg_instruire";
CREATE TABLE "public"."reg_instruire" (
  "training_id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "candidate_id" int4 NOT NULL,
  "school_id" int4 NOT NULL,
  "branch_id" int4,
  "category_code" varchar(5) COLLATE "pg_catalog"."default" NOT NULL,
  "instructor_id" int4,
  "contract_number" varchar(50) COLLATE "pg_catalog"."default",
  "enrollment_date" date,
  "graduation_date" date,
  "certificate_number" varchar(50) COLLATE "pg_catalog"."default",
  "theory_hours_completed" int2,
  "practice_hours_completed" int2,
  "status" varchar(20) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'inscris'::character varying,
  "created_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of reg_instruire
-- ----------------------------

-- ----------------------------
-- Table structure for reg_oficiu
-- ----------------------------
DROP TABLE IF EXISTS "public"."reg_oficiu";
CREATE TABLE "public"."reg_oficiu" (
  "office_id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "office_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "short_name" varchar(100) COLLATE "pg_catalog"."default",
  "is_head_office" bool NOT NULL DEFAULT false,
  "locality_id" int4,
  "address" varchar(255) COLLATE "pg_catalog"."default",
  "phone" varchar(30) COLLATE "pg_catalog"."default",
  "email" varchar(150) COLLATE "pg_catalog"."default",
  "latitude" numeric(9,6),
  "longitude" numeric(9,6),
  "is_active" bool NOT NULL DEFAULT true
)
;

-- ----------------------------
-- Records of reg_oficiu
-- ----------------------------

-- ----------------------------
-- Table structure for reg_oficiu_alias
-- ----------------------------
DROP TABLE IF EXISTS "public"."reg_oficiu_alias";
CREATE TABLE "public"."reg_oficiu_alias" (
  "raw_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "office_id" int4 NOT NULL
)
;

-- ----------------------------
-- Records of reg_oficiu_alias
-- ----------------------------

-- ----------------------------
-- Table structure for reg_scoala_auto
-- ----------------------------
DROP TABLE IF EXISTS "public"."reg_scoala_auto";
CREATE TABLE "public"."reg_scoala_auto" (
  "school_id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "idno" char(13) COLLATE "pg_catalog"."default",
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "short_name" varchar(100) COLLATE "pg_catalog"."default",
  "legal_form" varchar(20) COLLATE "pg_catalog"."default",
  "license_number" varchar(50) COLLATE "pg_catalog"."default",
  "license_issue_date" date,
  "license_expiry_date" date,
  "locality_id" int4,
  "address" varchar(255) COLLATE "pg_catalog"."default",
  "latitude" numeric(9,6),
  "longitude" numeric(9,6),
  "phone" varchar(30) COLLATE "pg_catalog"."default",
  "email" varchar(150) COLLATE "pg_catalog"."default",
  "website" varchar(255) COLLATE "pg_catalog"."default",
  "founded_year" int2,
  "description" text COLLATE "pg_catalog"."default",
  "is_verified" bool NOT NULL DEFAULT false,
  "is_active" bool NOT NULL DEFAULT true,
  "created_at" timestamptz(6) NOT NULL DEFAULT now(),
  "updated_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of reg_scoala_auto
-- ----------------------------

-- ----------------------------
-- Table structure for reg_scoala_categorie
-- ----------------------------
DROP TABLE IF EXISTS "public"."reg_scoala_categorie";
CREATE TABLE "public"."reg_scoala_categorie" (
  "school_id" int4 NOT NULL,
  "category_code" varchar(5) COLLATE "pg_catalog"."default" NOT NULL,
  "price" numeric(10,2),
  "currency" char(3) COLLATE "pg_catalog"."default" NOT NULL DEFAULT 'MDL'::bpchar,
  "theory_hours" int2,
  "practice_hours" int2,
  "duration_weeks" int2,
  "is_active" bool NOT NULL DEFAULT true,
  "updated_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of reg_scoala_categorie
-- ----------------------------

-- ----------------------------
-- Table structure for reg_scoala_filiala
-- ----------------------------
DROP TABLE IF EXISTS "public"."reg_scoala_filiala";
CREATE TABLE "public"."reg_scoala_filiala" (
  "branch_id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "school_id" int4 NOT NULL,
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "locality_id" int4,
  "address" varchar(255) COLLATE "pg_catalog"."default",
  "latitude" numeric(9,6),
  "longitude" numeric(9,6),
  "phone" varchar(30) COLLATE "pg_catalog"."default",
  "has_training_ground" bool NOT NULL DEFAULT false,
  "is_active" bool NOT NULL DEFAULT true
)
;

-- ----------------------------
-- Records of reg_scoala_filiala
-- ----------------------------

-- ----------------------------
-- Table structure for reg_vehicul
-- ----------------------------
DROP TABLE IF EXISTS "public"."reg_vehicul";
CREATE TABLE "public"."reg_vehicul" (
  "vehicle_id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "reg_number" varchar(15) COLLATE "pg_catalog"."default" NOT NULL,
  "school_id" int4,
  "category_code" varchar(5) COLLATE "pg_catalog"."default",
  "brand" varchar(50) COLLATE "pg_catalog"."default",
  "model" varchar(50) COLLATE "pg_catalog"."default",
  "manufacture_year" int2,
  "transmission" varchar(10) COLLATE "pg_catalog"."default",
  "fuel_type" varchar(20) COLLATE "pg_catalog"."default",
  "is_active" bool NOT NULL DEFAULT true
)
;

-- ----------------------------
-- Records of reg_vehicul
-- ----------------------------

-- ----------------------------
-- Table structure for stat_scoala_perioada
-- ----------------------------
DROP TABLE IF EXISTS "public"."stat_scoala_perioada";
CREATE TABLE "public"."stat_scoala_perioada" (
  "school_id" int4 NOT NULL,
  "category_code" varchar(5) COLLATE "pg_catalog"."default" NOT NULL,
  "period_year" int2 NOT NULL,
  "period_month" int2 NOT NULL DEFAULT 0,
  "candidates_total" int4 NOT NULL DEFAULT 0,
  "theory_exams" int4 NOT NULL DEFAULT 0,
  "theory_attempts" int4 NOT NULL DEFAULT 0,
  "theory_passed" int4 NOT NULL DEFAULT 0,
  "theory_first_attempt_passed" int4 NOT NULL DEFAULT 0,
  "practice_exams" int4 NOT NULL DEFAULT 0,
  "practice_attempts" int4 NOT NULL DEFAULT 0,
  "practice_passed" int4 NOT NULL DEFAULT 0,
  "practice_first_attempt_passed" int4 NOT NULL DEFAULT 0,
  "theory_pass_rate" numeric(5,2) GENERATED ALWAYS AS (
round(((100.0 * (theory_passed)::numeric) / (NULLIF(theory_attempts, 0))::numeric), 2)
) STORED,
  "theory_first_attempt_rate" numeric(5,2) GENERATED ALWAYS AS (
round(((100.0 * (theory_first_attempt_passed)::numeric) / (NULLIF(theory_exams, 0))::numeric), 2)
) STORED,
  "practice_pass_rate" numeric(5,2) GENERATED ALWAYS AS (
round(((100.0 * (practice_passed)::numeric) / (NULLIF(practice_attempts, 0))::numeric), 2)
) STORED,
  "practice_first_attempt_rate" numeric(5,2) GENERATED ALWAYS AS (
round(((100.0 * (practice_first_attempt_passed)::numeric) / (NULLIF(practice_exams, 0))::numeric), 2)
) STORED,
  "avg_attempts_to_pass" numeric(5,2),
  "avg_penalty_points" numeric(8,2),
  "avg_rating" numeric(3,2),
  "reviews_count" int4 NOT NULL DEFAULT 0,
  "rank_position" int4,
  "calculated_at" timestamptz(6) NOT NULL DEFAULT now()
)
;

-- ----------------------------
-- Records of stat_scoala_perioada
-- ----------------------------

-- ----------------------------
-- Table structure for usr_utilizator
-- ----------------------------
DROP TABLE IF EXISTS "public"."usr_utilizator";
CREATE TABLE "public"."usr_utilizator" (
  "user_id" int4 NOT NULL GENERATED ALWAYS AS IDENTITY (
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1
),
  "email" varchar(150) COLLATE "pg_catalog"."default" NOT NULL,
  "password_hash" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "full_name" varchar(150) COLLATE "pg_catalog"."default",
  "role_id" int2 NOT NULL,
  "school_id" int4,
  "candidate_id" int4,
  "is_email_confirmed" bool NOT NULL DEFAULT false,
  "is_active" bool NOT NULL DEFAULT true,
  "created_at" timestamptz(6) NOT NULL DEFAULT now(),
  "last_login_at" timestamptz(6)
)
;

-- ----------------------------
-- Records of usr_utilizator
-- ----------------------------

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."cls_penalizare_id_seq"
OWNED BY "public"."cls_penalizare"."id";
SELECT setval('"public"."cls_penalizare_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."cot_zile_examen_id_seq"
OWNED BY "public"."cot_zile_examen"."id";
SELECT setval('"public"."cot_zile_examen_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."ex_tentativa_penalizare_id_seq"
OWNED BY "public"."ex_tentativa_penalizare"."id";
SELECT setval('"public"."ex_tentativa_penalizare_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."imp_incarcare_load_id_seq"
OWNED BY "public"."imp_incarcare"."load_id";
SELECT setval('"public"."imp_incarcare_load_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."rec_recenzie_review_id_seq"
OWNED BY "public"."rec_recenzie"."review_id";
SELECT setval('"public"."rec_recenzie_review_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."reg_candidat_candidate_id_seq"
OWNED BY "public"."reg_candidat"."candidate_id";
SELECT setval('"public"."reg_candidat_candidate_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."reg_instructor_instructor_id_seq"
OWNED BY "public"."reg_instructor"."instructor_id";
SELECT setval('"public"."reg_instructor_instructor_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."reg_instruire_training_id_seq"
OWNED BY "public"."reg_instruire"."training_id";
SELECT setval('"public"."reg_instruire_training_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."reg_oficiu_office_id_seq"
OWNED BY "public"."reg_oficiu"."office_id";
SELECT setval('"public"."reg_oficiu_office_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."reg_scoala_auto_school_id_seq"
OWNED BY "public"."reg_scoala_auto"."school_id";
SELECT setval('"public"."reg_scoala_auto_school_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."reg_scoala_filiala_branch_id_seq"
OWNED BY "public"."reg_scoala_filiala"."branch_id";
SELECT setval('"public"."reg_scoala_filiala_branch_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."reg_vehicul_vehicle_id_seq"
OWNED BY "public"."reg_vehicul"."vehicle_id";
SELECT setval('"public"."reg_vehicul_vehicle_id_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."usr_utilizator_user_id_seq"
OWNED BY "public"."usr_utilizator"."user_id";
SELECT setval('"public"."usr_utilizator_user_id_seq"', 1, false);

-- ----------------------------
-- Uniques structure for table cls_categorie
-- ----------------------------
ALTER TABLE "public"."cls_categorie" ADD CONSTRAINT "cls_categorie_category_code_key" UNIQUE ("category_code");

-- ----------------------------
-- Checks structure for table cls_categorie
-- ----------------------------
ALTER TABLE "public"."cls_categorie" ADD CONSTRAINT "cls_categorie_min_age_check" CHECK (min_age >= 14 AND min_age <= 30);

-- ----------------------------
-- Primary Key structure for table cls_categorie
-- ----------------------------
ALTER TABLE "public"."cls_categorie" ADD CONSTRAINT "cls_categorie_pkey" PRIMARY KEY ("category_id");

-- ----------------------------
-- Uniques structure for table cls_localitate
-- ----------------------------
ALTER TABLE "public"."cls_localitate" ADD CONSTRAINT "cls_localitate_cuatm_code_key" UNIQUE ("cuatm_code");

-- ----------------------------
-- Checks structure for table cls_localitate
-- ----------------------------
ALTER TABLE "public"."cls_localitate" ADD CONSTRAINT "cls_localitate_latitude_check" CHECK (latitude >= '-90'::integer::numeric AND latitude <= 90::numeric);
ALTER TABLE "public"."cls_localitate" ADD CONSTRAINT "cls_localitate_longitude_check" CHECK (longitude >= '-180'::integer::numeric AND longitude <= 180::numeric);

-- ----------------------------
-- Primary Key structure for table cls_localitate
-- ----------------------------
ALTER TABLE "public"."cls_localitate" ADD CONSTRAINT "cls_localitate_pkey" PRIMARY KEY ("locality_id");

-- ----------------------------
-- Auto increment value for cls_penalizare
-- ----------------------------
SELECT setval('"public"."cls_penalizare_id_seq"', 1, false);

-- ----------------------------
-- Uniques structure for table cls_penalizare
-- ----------------------------
ALTER TABLE "public"."cls_penalizare" ADD CONSTRAINT "uq_cls_penalizare" UNIQUE ("category_code", "penalty_id");

-- ----------------------------
-- Checks structure for table cls_penalizare
-- ----------------------------
ALTER TABLE "public"."cls_penalizare" ADD CONSTRAINT "cls_penalizare_points_check" CHECK (points >= 0);

-- ----------------------------
-- Primary Key structure for table cls_penalizare
-- ----------------------------
ALTER TABLE "public"."cls_penalizare" ADD CONSTRAINT "cls_penalizare_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table cls_raion
-- ----------------------------
ALTER TABLE "public"."cls_raion" ADD CONSTRAINT "cls_raion_code_key" UNIQUE ("code");
ALTER TABLE "public"."cls_raion" ADD CONSTRAINT "cls_raion_name_ro_key" UNIQUE ("name_ro");

-- ----------------------------
-- Checks structure for table cls_raion
-- ----------------------------
ALTER TABLE "public"."cls_raion" ADD CONSTRAINT "cls_raion_district_type_check" CHECK (district_type::text = ANY (ARRAY['raion'::character varying, 'municipiu'::character varying, 'uta'::character varying]::text[]));

-- ----------------------------
-- Primary Key structure for table cls_raion
-- ----------------------------
ALTER TABLE "public"."cls_raion" ADD CONSTRAINT "cls_raion_pkey" PRIMARY KEY ("district_id");

-- ----------------------------
-- Uniques structure for table cls_rezultat
-- ----------------------------
ALTER TABLE "public"."cls_rezultat" ADD CONSTRAINT "cls_rezultat_code_key" UNIQUE ("code");
ALTER TABLE "public"."cls_rezultat" ADD CONSTRAINT "cls_rezultat_name_ro_key" UNIQUE ("name_ro");

-- ----------------------------
-- Primary Key structure for table cls_rezultat
-- ----------------------------
ALTER TABLE "public"."cls_rezultat" ADD CONSTRAINT "cls_rezultat_pkey" PRIMARY KEY ("result_id");

-- ----------------------------
-- Primary Key structure for table cls_rezultat_alias
-- ----------------------------
ALTER TABLE "public"."cls_rezultat_alias" ADD CONSTRAINT "cls_rezultat_alias_pkey" PRIMARY KEY ("raw_value");

-- ----------------------------
-- Uniques structure for table cls_rol
-- ----------------------------
ALTER TABLE "public"."cls_rol" ADD CONSTRAINT "cls_rol_code_key" UNIQUE ("code");

-- ----------------------------
-- Primary Key structure for table cls_rol
-- ----------------------------
ALTER TABLE "public"."cls_rol" ADD CONSTRAINT "cls_rol_pkey" PRIMARY KEY ("role_id");

-- ----------------------------
-- Uniques structure for table cls_tip_examen
-- ----------------------------
ALTER TABLE "public"."cls_tip_examen" ADD CONSTRAINT "cls_tip_examen_code_key" UNIQUE ("code");

-- ----------------------------
-- Primary Key structure for table cls_tip_examen
-- ----------------------------
ALTER TABLE "public"."cls_tip_examen" ADD CONSTRAINT "cls_tip_examen_pkey" PRIMARY KEY ("exam_type_id");

-- ----------------------------
-- Uniques structure for table cls_tip_practica
-- ----------------------------
ALTER TABLE "public"."cls_tip_practica" ADD CONSTRAINT "cls_tip_practica_code_key" UNIQUE ("code");

-- ----------------------------
-- Checks structure for table cls_tip_practica
-- ----------------------------
ALTER TABLE "public"."cls_tip_practica" ADD CONSTRAINT "cls_tip_practica_max_penalty_points_check" CHECK (max_penalty_points >= 0);

-- ----------------------------
-- Primary Key structure for table cls_tip_practica
-- ----------------------------
ALTER TABLE "public"."cls_tip_practica" ADD CONSTRAINT "cls_tip_practica_pkey" PRIMARY KEY ("practice_type_id");

-- ----------------------------
-- Uniques structure for table cls_zi_saptamana
-- ----------------------------
ALTER TABLE "public"."cls_zi_saptamana" ADD CONSTRAINT "cls_zi_saptamana_name_ro_key" UNIQUE ("name_ro");
ALTER TABLE "public"."cls_zi_saptamana" ADD CONSTRAINT "cls_zi_saptamana_name_en_key" UNIQUE ("name_en");
ALTER TABLE "public"."cls_zi_saptamana" ADD CONSTRAINT "cls_zi_saptamana_name_ru_key" UNIQUE ("name_ru");
ALTER TABLE "public"."cls_zi_saptamana" ADD CONSTRAINT "cls_zi_saptamana_iso_day_order_key" UNIQUE ("iso_day_order");

-- ----------------------------
-- Checks structure for table cls_zi_saptamana
-- ----------------------------
ALTER TABLE "public"."cls_zi_saptamana" ADD CONSTRAINT "cls_zi_saptamana_weekday_id_check" CHECK (weekday_id >= 0 AND weekday_id <= 6);
ALTER TABLE "public"."cls_zi_saptamana" ADD CONSTRAINT "cls_zi_saptamana_iso_day_order_check" CHECK (iso_day_order >= 1 AND iso_day_order <= 7);

-- ----------------------------
-- Primary Key structure for table cls_zi_saptamana
-- ----------------------------
ALTER TABLE "public"."cls_zi_saptamana" ADD CONSTRAINT "cls_zi_saptamana_pkey" PRIMARY KEY ("weekday_id");

-- ----------------------------
-- Checks structure for table cot_teorie_parametri
-- ----------------------------
ALTER TABLE "public"."cot_teorie_parametri" ADD CONSTRAINT "cot_teorie_parametri_check" CHECK (valid_to IS NULL OR valid_to >= valid_from);
ALTER TABLE "public"."cot_teorie_parametri" ADD CONSTRAINT "cot_teorie_parametri_check1" CHECK (correct_required IS NULL OR questions_total IS NOT NULL AND correct_required <= questions_total);
ALTER TABLE "public"."cot_teorie_parametri" ADD CONSTRAINT "cot_teorie_parametri_correct_required_check" CHECK (correct_required > 0);
ALTER TABLE "public"."cot_teorie_parametri" ADD CONSTRAINT "cot_teorie_parametri_exam_duration_sec_check" CHECK (exam_duration_sec > 0);
ALTER TABLE "public"."cot_teorie_parametri" ADD CONSTRAINT "cot_teorie_parametri_questions_total_check" CHECK (questions_total > 0);

-- ----------------------------
-- Primary Key structure for table cot_teorie_parametri
-- ----------------------------
ALTER TABLE "public"."cot_teorie_parametri" ADD CONSTRAINT "cot_teorie_parametri_pkey" PRIMARY KEY ("category_code", "valid_from");

-- ----------------------------
-- Auto increment value for cot_zile_examen
-- ----------------------------
SELECT setval('"public"."cot_zile_examen_id_seq"', 1, false);

-- ----------------------------
-- Uniques structure for table cot_zile_examen
-- ----------------------------
ALTER TABLE "public"."cot_zile_examen" ADD CONSTRAINT "cot_zile_examen_office_id_exam_type_id_year_weekday_id_key" UNIQUE ("office_id", "exam_type_id", "year", "weekday_id");

-- ----------------------------
-- Checks structure for table cot_zile_examen
-- ----------------------------
ALTER TABLE "public"."cot_zile_examen" ADD CONSTRAINT "cot_zile_examen_attempts_urgent_check" CHECK (attempts_urgent >= 0);
ALTER TABLE "public"."cot_zile_examen" ADD CONSTRAINT "cot_zile_examen_year_check" CHECK (year >= 2000 AND year <= 2100);
ALTER TABLE "public"."cot_zile_examen" ADD CONSTRAINT "cot_zile_examen_attempts_normal_check" CHECK (attempts_normal >= 0);

-- ----------------------------
-- Primary Key structure for table cot_zile_examen
-- ----------------------------
ALTER TABLE "public"."cot_zile_examen" ADD CONSTRAINT "cot_zile_examen_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table ex_examen
-- ----------------------------
CREATE INDEX "ix_ex_examen_candidat" ON "public"."ex_examen" USING btree (
  "candidate_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "ix_ex_examen_scoala" ON "public"."ex_examen" USING btree (
  "school_id" "pg_catalog"."int4_ops" ASC NULLS LAST,
  "category_code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Checks structure for table ex_examen
-- ----------------------------
ALTER TABLE "public"."ex_examen" ADD CONSTRAINT "ex_examen_attempts_total_check" CHECK (attempts_total >= 0);

-- ----------------------------
-- Primary Key structure for table ex_examen
-- ----------------------------
ALTER TABLE "public"."ex_examen" ADD CONSTRAINT "ex_examen_pkey" PRIMARY KEY ("exam_id", "exam_type_id");

-- ----------------------------
-- Auto increment value for ex_tentativa_penalizare
-- ----------------------------
SELECT setval('"public"."ex_tentativa_penalizare_id_seq"', 1, false);

-- ----------------------------
-- Indexes structure for table ex_tentativa_penalizare
-- ----------------------------
CREATE INDEX "ix_ex_tentativa_penalizare_cls" ON "public"."ex_tentativa_penalizare" USING btree (
  "category_code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
  "penalty_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table ex_tentativa_penalizare
-- ----------------------------
ALTER TABLE "public"."ex_tentativa_penalizare" ADD CONSTRAINT "ex_tentativa_penalizare_attempt_id_penalty_id_key" UNIQUE ("attempt_id", "penalty_id");

-- ----------------------------
-- Checks structure for table ex_tentativa_penalizare
-- ----------------------------
ALTER TABLE "public"."ex_tentativa_penalizare" ADD CONSTRAINT "ex_tentativa_penalizare_points_check" CHECK (points >= 0);
ALTER TABLE "public"."ex_tentativa_penalizare" ADD CONSTRAINT "ex_tentativa_penalizare_quantity_check" CHECK (quantity >= 1);

-- ----------------------------
-- Primary Key structure for table ex_tentativa_penalizare
-- ----------------------------
ALTER TABLE "public"."ex_tentativa_penalizare" ADD CONSTRAINT "ex_tentativa_penalizare_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table ex_tentativa_practica
-- ----------------------------
CREATE INDEX "ix_ex_tentativa_practica_data" ON "public"."ex_tentativa_practica" USING btree (
  "exam_date" "pg_catalog"."date_ops" ASC NULLS LAST
);
CREATE INDEX "ix_ex_tentativa_practica_examinator" ON "public"."ex_tentativa_practica" USING btree (
  "examiner_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "ix_ex_tentativa_practica_oficiu" ON "public"."ex_tentativa_practica" USING btree (
  "office_id" "pg_catalog"."int4_ops" ASC NULLS LAST,
  "exam_date" "pg_catalog"."date_ops" ASC NULLS LAST
);
CREATE INDEX "ix_ex_tentativa_practica_vehicul" ON "public"."ex_tentativa_practica" USING btree (
  "vehicle_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table ex_tentativa_practica
-- ----------------------------
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_exam_id_exam_type_id_attempt_number_key" UNIQUE ("exam_id", "exam_type_id", "attempt_number");

-- ----------------------------
-- Checks structure for table ex_tentativa_practica
-- ----------------------------
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_candidate_age_check" CHECK (candidate_age >= 14 AND candidate_age <= 100);
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_check" CHECK (finish_time IS NULL OR start_time IS NOT NULL);
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_duration_sec_check" CHECK (duration_sec >= 0);
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_exam_type_id_check" CHECK (exam_type_id = 2);
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_total_points_check" CHECK (total_points >= 0);
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_attempt_number_check" CHECK (attempt_number >= 1);

-- ----------------------------
-- Primary Key structure for table ex_tentativa_practica
-- ----------------------------
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_pkey" PRIMARY KEY ("attempt_id");

-- ----------------------------
-- Indexes structure for table ex_tentativa_teorie
-- ----------------------------
CREATE INDEX "ix_ex_tentativa_teorie_data" ON "public"."ex_tentativa_teorie" USING btree (
  "exam_date" "pg_catalog"."date_ops" ASC NULLS LAST
);
CREATE INDEX "ix_ex_tentativa_teorie_examinator" ON "public"."ex_tentativa_teorie" USING btree (
  "examiner_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "ix_ex_tentativa_teorie_oficiu" ON "public"."ex_tentativa_teorie" USING btree (
  "office_id" "pg_catalog"."int4_ops" ASC NULLS LAST,
  "exam_date" "pg_catalog"."date_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table ex_tentativa_teorie
-- ----------------------------
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_exam_id_exam_type_id_attempt_number_key" UNIQUE ("exam_id", "exam_type_id", "attempt_number");

-- ----------------------------
-- Checks structure for table ex_tentativa_teorie
-- ----------------------------
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_candidate_age_check" CHECK (candidate_age >= 14 AND candidate_age <= 100);
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_check" CHECK (finish_time IS NULL OR start_time IS NOT NULL);
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_correct_answers_check" CHECK (correct_answers >= 0);
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_duration_sec_check" CHECK (duration_sec >= 0);
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_exam_type_id_check" CHECK (exam_type_id = 1);
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_questions_answered_check" CHECK (questions_answered >= 0);
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_wrong_answers_check" CHECK (wrong_answers >= 0);
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_attempt_number_check" CHECK (attempt_number >= 1);

-- ----------------------------
-- Primary Key structure for table ex_tentativa_teorie
-- ----------------------------
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_pkey" PRIMARY KEY ("attempt_id");

-- ----------------------------
-- Auto increment value for imp_incarcare
-- ----------------------------
SELECT setval('"public"."imp_incarcare_load_id_seq"', 1, false);

-- ----------------------------
-- Checks structure for table imp_incarcare
-- ----------------------------
ALTER TABLE "public"."imp_incarcare" ADD CONSTRAINT "imp_incarcare_rows_loaded_check" CHECK (rows_loaded >= 0);
ALTER TABLE "public"."imp_incarcare" ADD CONSTRAINT "imp_incarcare_rows_rejected_check" CHECK (rows_rejected >= 0);
ALTER TABLE "public"."imp_incarcare" ADD CONSTRAINT "imp_incarcare_rows_total_check" CHECK (rows_total >= 0);
ALTER TABLE "public"."imp_incarcare" ADD CONSTRAINT "imp_incarcare_status_check" CHECK (status::text = ANY (ARRAY['in_proces'::character varying, 'finalizat'::character varying, 'eroare'::character varying]::text[]));

-- ----------------------------
-- Primary Key structure for table imp_incarcare
-- ----------------------------
ALTER TABLE "public"."imp_incarcare" ADD CONSTRAINT "imp_incarcare_pkey" PRIMARY KEY ("load_id");

-- ----------------------------
-- Auto increment value for rec_recenzie
-- ----------------------------
SELECT setval('"public"."rec_recenzie_review_id_seq"', 1, false);

-- ----------------------------
-- Indexes structure for table rec_recenzie
-- ----------------------------
CREATE INDEX "ix_rec_recenzie_scoala" ON "public"."rec_recenzie" USING btree (
  "school_id" "pg_catalog"."int4_ops" ASC NULLS LAST,
  "status" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table rec_recenzie
-- ----------------------------
ALTER TABLE "public"."rec_recenzie" ADD CONSTRAINT "rec_recenzie_school_id_user_id_category_code_key" UNIQUE ("school_id", "user_id", "category_code");

-- ----------------------------
-- Checks structure for table rec_recenzie
-- ----------------------------
ALTER TABLE "public"."rec_recenzie" ADD CONSTRAINT "rec_recenzie_rating_instructors_check" CHECK (rating_instructors >= 1 AND rating_instructors <= 5);
ALTER TABLE "public"."rec_recenzie" ADD CONSTRAINT "rec_recenzie_rating_overall_check" CHECK (rating_overall >= 1 AND rating_overall <= 5);
ALTER TABLE "public"."rec_recenzie" ADD CONSTRAINT "rec_recenzie_rating_practice_check" CHECK (rating_practice >= 1 AND rating_practice <= 5);
ALTER TABLE "public"."rec_recenzie" ADD CONSTRAINT "rec_recenzie_rating_price_check" CHECK (rating_price >= 1 AND rating_price <= 5);
ALTER TABLE "public"."rec_recenzie" ADD CONSTRAINT "rec_recenzie_rating_theory_check" CHECK (rating_theory >= 1 AND rating_theory <= 5);
ALTER TABLE "public"."rec_recenzie" ADD CONSTRAINT "rec_recenzie_rating_vehicles_check" CHECK (rating_vehicles >= 1 AND rating_vehicles <= 5);
ALTER TABLE "public"."rec_recenzie" ADD CONSTRAINT "rec_recenzie_status_check" CHECK (status::text = ANY (ARRAY['in_asteptare'::character varying, 'aprobat'::character varying, 'respins'::character varying]::text[]));

-- ----------------------------
-- Primary Key structure for table rec_recenzie
-- ----------------------------
ALTER TABLE "public"."rec_recenzie" ADD CONSTRAINT "rec_recenzie_pkey" PRIMARY KEY ("review_id");

-- ----------------------------
-- Auto increment value for reg_candidat
-- ----------------------------
SELECT setval('"public"."reg_candidat_candidate_id_seq"', 1, false);

-- ----------------------------
-- Uniques structure for table reg_candidat
-- ----------------------------
ALTER TABLE "public"."reg_candidat" ADD CONSTRAINT "reg_candidat_idnp_key" UNIQUE ("idnp");

-- ----------------------------
-- Checks structure for table reg_candidat
-- ----------------------------
ALTER TABLE "public"."reg_candidat" ADD CONSTRAINT "reg_candidat_idnp_check" CHECK (idnp ~ '^[0-9]{13}$'::text);
ALTER TABLE "public"."reg_candidat" ADD CONSTRAINT "reg_candidat_sex_check" CHECK (sex = ANY (ARRAY['M'::bpchar, 'F'::bpchar]));

-- ----------------------------
-- Primary Key structure for table reg_candidat
-- ----------------------------
ALTER TABLE "public"."reg_candidat" ADD CONSTRAINT "reg_candidat_pkey" PRIMARY KEY ("candidate_id");

-- ----------------------------
-- Primary Key structure for table reg_examinator
-- ----------------------------
ALTER TABLE "public"."reg_examinator" ADD CONSTRAINT "reg_examinator_pkey" PRIMARY KEY ("examiner_id");

-- ----------------------------
-- Auto increment value for reg_instructor
-- ----------------------------
SELECT setval('"public"."reg_instructor_instructor_id_seq"', 1, false);

-- ----------------------------
-- Uniques structure for table reg_instructor
-- ----------------------------
ALTER TABLE "public"."reg_instructor" ADD CONSTRAINT "reg_instructor_idnp_key" UNIQUE ("idnp");

-- ----------------------------
-- Checks structure for table reg_instructor
-- ----------------------------
ALTER TABLE "public"."reg_instructor" ADD CONSTRAINT "reg_instructor_idnp_check" CHECK (idnp ~ '^[0-9]{13}$'::text);
ALTER TABLE "public"."reg_instructor" ADD CONSTRAINT "reg_instructor_experience_years_check" CHECK (experience_years >= 0);

-- ----------------------------
-- Primary Key structure for table reg_instructor
-- ----------------------------
ALTER TABLE "public"."reg_instructor" ADD CONSTRAINT "reg_instructor_pkey" PRIMARY KEY ("instructor_id");

-- ----------------------------
-- Primary Key structure for table reg_instructor_categorie
-- ----------------------------
ALTER TABLE "public"."reg_instructor_categorie" ADD CONSTRAINT "reg_instructor_categorie_pkey" PRIMARY KEY ("instructor_id", "category_code");

-- ----------------------------
-- Auto increment value for reg_instruire
-- ----------------------------
SELECT setval('"public"."reg_instruire_training_id_seq"', 1, false);

-- ----------------------------
-- Indexes structure for table reg_instruire
-- ----------------------------
CREATE INDEX "ix_reg_instruire_candidat" ON "public"."reg_instruire" USING btree (
  "candidate_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);
CREATE INDEX "ix_reg_instruire_scoala" ON "public"."reg_instruire" USING btree (
  "school_id" "pg_catalog"."int4_ops" ASC NULLS LAST,
  "category_code" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);

-- ----------------------------
-- Checks structure for table reg_instruire
-- ----------------------------
ALTER TABLE "public"."reg_instruire" ADD CONSTRAINT "reg_instruire_check" CHECK (graduation_date IS NULL OR enrollment_date IS NULL OR graduation_date >= enrollment_date);
ALTER TABLE "public"."reg_instruire" ADD CONSTRAINT "reg_instruire_practice_hours_completed_check" CHECK (practice_hours_completed >= 0);
ALTER TABLE "public"."reg_instruire" ADD CONSTRAINT "reg_instruire_status_check" CHECK (status::text = ANY (ARRAY['inscris'::character varying, 'in_curs'::character varying, 'absolvit'::character varying, 'abandonat'::character varying, 'transferat'::character varying]::text[]));
ALTER TABLE "public"."reg_instruire" ADD CONSTRAINT "reg_instruire_theory_hours_completed_check" CHECK (theory_hours_completed >= 0);

-- ----------------------------
-- Primary Key structure for table reg_instruire
-- ----------------------------
ALTER TABLE "public"."reg_instruire" ADD CONSTRAINT "reg_instruire_pkey" PRIMARY KEY ("training_id");

-- ----------------------------
-- Auto increment value for reg_oficiu
-- ----------------------------
SELECT setval('"public"."reg_oficiu_office_id_seq"', 1, false);

-- ----------------------------
-- Uniques structure for table reg_oficiu
-- ----------------------------
ALTER TABLE "public"."reg_oficiu" ADD CONSTRAINT "reg_oficiu_office_name_key" UNIQUE ("office_name");

-- ----------------------------
-- Checks structure for table reg_oficiu
-- ----------------------------
ALTER TABLE "public"."reg_oficiu" ADD CONSTRAINT "reg_oficiu_latitude_check" CHECK (latitude >= '-90'::integer::numeric AND latitude <= 90::numeric);
ALTER TABLE "public"."reg_oficiu" ADD CONSTRAINT "reg_oficiu_longitude_check" CHECK (longitude >= '-180'::integer::numeric AND longitude <= 180::numeric);

-- ----------------------------
-- Primary Key structure for table reg_oficiu
-- ----------------------------
ALTER TABLE "public"."reg_oficiu" ADD CONSTRAINT "reg_oficiu_pkey" PRIMARY KEY ("office_id");

-- ----------------------------
-- Primary Key structure for table reg_oficiu_alias
-- ----------------------------
ALTER TABLE "public"."reg_oficiu_alias" ADD CONSTRAINT "reg_oficiu_alias_pkey" PRIMARY KEY ("raw_name");

-- ----------------------------
-- Auto increment value for reg_scoala_auto
-- ----------------------------
SELECT setval('"public"."reg_scoala_auto_school_id_seq"', 1, false);

-- ----------------------------
-- Indexes structure for table reg_scoala_auto
-- ----------------------------
CREATE INDEX "ix_reg_scoala_auto_localitate" ON "public"."reg_scoala_auto" USING btree (
  "locality_id" "pg_catalog"."int4_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table reg_scoala_auto
-- ----------------------------
ALTER TABLE "public"."reg_scoala_auto" ADD CONSTRAINT "reg_scoala_auto_idno_key" UNIQUE ("idno");

-- ----------------------------
-- Checks structure for table reg_scoala_auto
-- ----------------------------
ALTER TABLE "public"."reg_scoala_auto" ADD CONSTRAINT "reg_scoala_auto_founded_year_check" CHECK (founded_year >= 1900 AND founded_year <= 2100);
ALTER TABLE "public"."reg_scoala_auto" ADD CONSTRAINT "reg_scoala_auto_idno_check" CHECK (idno ~ '^[0-9]{13}$'::text);
ALTER TABLE "public"."reg_scoala_auto" ADD CONSTRAINT "reg_scoala_auto_latitude_check" CHECK (latitude >= '-90'::integer::numeric AND latitude <= 90::numeric);
ALTER TABLE "public"."reg_scoala_auto" ADD CONSTRAINT "reg_scoala_auto_longitude_check" CHECK (longitude >= '-180'::integer::numeric AND longitude <= 180::numeric);
ALTER TABLE "public"."reg_scoala_auto" ADD CONSTRAINT "reg_scoala_auto_check" CHECK (license_expiry_date IS NULL OR license_issue_date IS NULL OR license_expiry_date >= license_issue_date);

-- ----------------------------
-- Primary Key structure for table reg_scoala_auto
-- ----------------------------
ALTER TABLE "public"."reg_scoala_auto" ADD CONSTRAINT "reg_scoala_auto_pkey" PRIMARY KEY ("school_id");

-- ----------------------------
-- Checks structure for table reg_scoala_categorie
-- ----------------------------
ALTER TABLE "public"."reg_scoala_categorie" ADD CONSTRAINT "reg_scoala_categorie_duration_weeks_check" CHECK (duration_weeks > 0);
ALTER TABLE "public"."reg_scoala_categorie" ADD CONSTRAINT "reg_scoala_categorie_practice_hours_check" CHECK (practice_hours >= 0);
ALTER TABLE "public"."reg_scoala_categorie" ADD CONSTRAINT "reg_scoala_categorie_price_check" CHECK (price >= 0::numeric);
ALTER TABLE "public"."reg_scoala_categorie" ADD CONSTRAINT "reg_scoala_categorie_theory_hours_check" CHECK (theory_hours >= 0);

-- ----------------------------
-- Primary Key structure for table reg_scoala_categorie
-- ----------------------------
ALTER TABLE "public"."reg_scoala_categorie" ADD CONSTRAINT "reg_scoala_categorie_pkey" PRIMARY KEY ("school_id", "category_code");

-- ----------------------------
-- Auto increment value for reg_scoala_filiala
-- ----------------------------
SELECT setval('"public"."reg_scoala_filiala_branch_id_seq"', 1, false);

-- ----------------------------
-- Checks structure for table reg_scoala_filiala
-- ----------------------------
ALTER TABLE "public"."reg_scoala_filiala" ADD CONSTRAINT "reg_scoala_filiala_latitude_check" CHECK (latitude >= '-90'::integer::numeric AND latitude <= 90::numeric);
ALTER TABLE "public"."reg_scoala_filiala" ADD CONSTRAINT "reg_scoala_filiala_longitude_check" CHECK (longitude >= '-180'::integer::numeric AND longitude <= 180::numeric);

-- ----------------------------
-- Primary Key structure for table reg_scoala_filiala
-- ----------------------------
ALTER TABLE "public"."reg_scoala_filiala" ADD CONSTRAINT "reg_scoala_filiala_pkey" PRIMARY KEY ("branch_id");

-- ----------------------------
-- Auto increment value for reg_vehicul
-- ----------------------------
SELECT setval('"public"."reg_vehicul_vehicle_id_seq"', 1, false);

-- ----------------------------
-- Uniques structure for table reg_vehicul
-- ----------------------------
ALTER TABLE "public"."reg_vehicul" ADD CONSTRAINT "reg_vehicul_reg_number_key" UNIQUE ("reg_number");

-- ----------------------------
-- Checks structure for table reg_vehicul
-- ----------------------------
ALTER TABLE "public"."reg_vehicul" ADD CONSTRAINT "reg_vehicul_manufacture_year_check" CHECK (manufacture_year >= 1950 AND manufacture_year <= 2100);
ALTER TABLE "public"."reg_vehicul" ADD CONSTRAINT "reg_vehicul_transmission_check" CHECK (transmission::text = ANY (ARRAY['manuala'::character varying, 'automata'::character varying]::text[]));

-- ----------------------------
-- Primary Key structure for table reg_vehicul
-- ----------------------------
ALTER TABLE "public"."reg_vehicul" ADD CONSTRAINT "reg_vehicul_pkey" PRIMARY KEY ("vehicle_id");

-- ----------------------------
-- Checks structure for table stat_scoala_perioada
-- ----------------------------
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_avg_penalty_points_check" CHECK (avg_penalty_points >= 0::numeric);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_avg_rating_check" CHECK (avg_rating >= 1::numeric AND avg_rating <= 5::numeric);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_candidates_total_check" CHECK (candidates_total >= 0);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_period_month_check" CHECK (period_month >= 0 AND period_month <= 12);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_period_year_check" CHECK (period_year >= 2000 AND period_year <= 2100);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_practice_attempts_check" CHECK (practice_attempts >= 0);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_practice_exams_check" CHECK (practice_exams >= 0);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_practice_first_attempt_passed_check" CHECK (practice_first_attempt_passed >= 0);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_practice_passed_check" CHECK (practice_passed >= 0);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_rank_position_check" CHECK (rank_position > 0);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_reviews_count_check" CHECK (reviews_count >= 0);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_theory_attempts_check" CHECK (theory_attempts >= 0);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_theory_exams_check" CHECK (theory_exams >= 0);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_theory_first_attempt_passed_check" CHECK (theory_first_attempt_passed >= 0);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_theory_passed_check" CHECK (theory_passed >= 0);
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_avg_attempts_to_pass_check" CHECK (avg_attempts_to_pass >= 0::numeric);

-- ----------------------------
-- Primary Key structure for table stat_scoala_perioada
-- ----------------------------
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_pkey" PRIMARY KEY ("school_id", "category_code", "period_year", "period_month");

-- ----------------------------
-- Auto increment value for usr_utilizator
-- ----------------------------
SELECT setval('"public"."usr_utilizator_user_id_seq"', 1, false);

-- ----------------------------
-- Uniques structure for table usr_utilizator
-- ----------------------------
ALTER TABLE "public"."usr_utilizator" ADD CONSTRAINT "usr_utilizator_email_key" UNIQUE ("email");

-- ----------------------------
-- Primary Key structure for table usr_utilizator
-- ----------------------------
ALTER TABLE "public"."usr_utilizator" ADD CONSTRAINT "usr_utilizator_pkey" PRIMARY KEY ("user_id");

-- ----------------------------
-- Foreign Keys structure for table cls_categorie
-- ----------------------------
ALTER TABLE "public"."cls_categorie" ADD CONSTRAINT "cls_categorie_parent_category_code_fkey" FOREIGN KEY ("parent_category_code") REFERENCES "public"."cls_categorie" ("category_code") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cls_localitate
-- ----------------------------
ALTER TABLE "public"."cls_localitate" ADD CONSTRAINT "cls_localitate_district_id_fkey" FOREIGN KEY ("district_id") REFERENCES "public"."cls_raion" ("district_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cls_penalizare
-- ----------------------------
ALTER TABLE "public"."cls_penalizare" ADD CONSTRAINT "cls_penalizare_category_code_fkey" FOREIGN KEY ("category_code") REFERENCES "public"."cls_categorie" ("category_code") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."cls_penalizare" ADD CONSTRAINT "cls_penalizare_practice_type_id_fkey" FOREIGN KEY ("practice_type_id") REFERENCES "public"."cls_tip_practica" ("practice_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cls_rezultat_alias
-- ----------------------------
ALTER TABLE "public"."cls_rezultat_alias" ADD CONSTRAINT "cls_rezultat_alias_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "public"."cls_rezultat" ("result_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cot_teorie_parametri
-- ----------------------------
ALTER TABLE "public"."cot_teorie_parametri" ADD CONSTRAINT "cot_teorie_parametri_category_code_fkey" FOREIGN KEY ("category_code") REFERENCES "public"."cls_categorie" ("category_code") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table cot_zile_examen
-- ----------------------------
ALTER TABLE "public"."cot_zile_examen" ADD CONSTRAINT "cot_zile_examen_exam_type_id_fkey" FOREIGN KEY ("exam_type_id") REFERENCES "public"."cls_tip_examen" ("exam_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."cot_zile_examen" ADD CONSTRAINT "cot_zile_examen_office_id_fkey" FOREIGN KEY ("office_id") REFERENCES "public"."reg_oficiu" ("office_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."cot_zile_examen" ADD CONSTRAINT "cot_zile_examen_weekday_id_fkey" FOREIGN KEY ("weekday_id") REFERENCES "public"."cls_zi_saptamana" ("weekday_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table ex_examen
-- ----------------------------
ALTER TABLE "public"."ex_examen" ADD CONSTRAINT "ex_examen_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "public"."reg_candidat" ("candidate_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_examen" ADD CONSTRAINT "ex_examen_category_code_fkey" FOREIGN KEY ("category_code") REFERENCES "public"."cls_categorie" ("category_code") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_examen" ADD CONSTRAINT "ex_examen_exam_type_id_fkey" FOREIGN KEY ("exam_type_id") REFERENCES "public"."cls_tip_examen" ("exam_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_examen" ADD CONSTRAINT "ex_examen_load_id_fkey" FOREIGN KEY ("load_id") REFERENCES "public"."imp_incarcare" ("load_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_examen" ADD CONSTRAINT "ex_examen_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "public"."cls_rezultat" ("result_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_examen" ADD CONSTRAINT "ex_examen_school_id_fkey" FOREIGN KEY ("school_id") REFERENCES "public"."reg_scoala_auto" ("school_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_examen" ADD CONSTRAINT "ex_examen_training_id_fkey" FOREIGN KEY ("training_id") REFERENCES "public"."reg_instruire" ("training_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table ex_tentativa_penalizare
-- ----------------------------
ALTER TABLE "public"."ex_tentativa_penalizare" ADD CONSTRAINT "ex_tentativa_penalizare_attempt_id_fkey" FOREIGN KEY ("attempt_id") REFERENCES "public"."ex_tentativa_practica" ("attempt_id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_penalizare" ADD CONSTRAINT "ex_tentativa_penalizare_category_code_penalty_id_fkey" FOREIGN KEY ("category_code", "penalty_id") REFERENCES "public"."cls_penalizare" ("category_code", "penalty_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_penalizare" ADD CONSTRAINT "ex_tentativa_penalizare_load_id_fkey" FOREIGN KEY ("load_id") REFERENCES "public"."imp_incarcare" ("load_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table ex_tentativa_practica
-- ----------------------------
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_exam_id_exam_type_id_fkey" FOREIGN KEY ("exam_id", "exam_type_id") REFERENCES "public"."ex_examen" ("exam_id", "exam_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_examiner_id_fkey" FOREIGN KEY ("examiner_id") REFERENCES "public"."reg_examinator" ("examiner_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_instructor_id_fkey" FOREIGN KEY ("instructor_id") REFERENCES "public"."reg_instructor" ("instructor_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_load_id_fkey" FOREIGN KEY ("load_id") REFERENCES "public"."imp_incarcare" ("load_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_office_id_fkey" FOREIGN KEY ("office_id") REFERENCES "public"."reg_oficiu" ("office_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_practice_type_id_fkey" FOREIGN KEY ("practice_type_id") REFERENCES "public"."cls_tip_practica" ("practice_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "public"."cls_rezultat" ("result_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_vehicle_id_fkey" FOREIGN KEY ("vehicle_id") REFERENCES "public"."reg_vehicul" ("vehicle_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_practica" ADD CONSTRAINT "ex_tentativa_practica_weekday_id_fkey" FOREIGN KEY ("weekday_id") REFERENCES "public"."cls_zi_saptamana" ("weekday_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table ex_tentativa_teorie
-- ----------------------------
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_exam_id_exam_type_id_fkey" FOREIGN KEY ("exam_id", "exam_type_id") REFERENCES "public"."ex_examen" ("exam_id", "exam_type_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_examiner_id_fkey" FOREIGN KEY ("examiner_id") REFERENCES "public"."reg_examinator" ("examiner_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_load_id_fkey" FOREIGN KEY ("load_id") REFERENCES "public"."imp_incarcare" ("load_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_office_id_fkey" FOREIGN KEY ("office_id") REFERENCES "public"."reg_oficiu" ("office_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "public"."cls_rezultat" ("result_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."ex_tentativa_teorie" ADD CONSTRAINT "ex_tentativa_teorie_weekday_id_fkey" FOREIGN KEY ("weekday_id") REFERENCES "public"."cls_zi_saptamana" ("weekday_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table rec_recenzie
-- ----------------------------
ALTER TABLE "public"."rec_recenzie" ADD CONSTRAINT "rec_recenzie_category_code_fkey" FOREIGN KEY ("category_code") REFERENCES "public"."cls_categorie" ("category_code") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."rec_recenzie" ADD CONSTRAINT "rec_recenzie_moderated_by_fkey" FOREIGN KEY ("moderated_by") REFERENCES "public"."usr_utilizator" ("user_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."rec_recenzie" ADD CONSTRAINT "rec_recenzie_school_id_fkey" FOREIGN KEY ("school_id") REFERENCES "public"."reg_scoala_auto" ("school_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."rec_recenzie" ADD CONSTRAINT "rec_recenzie_training_id_fkey" FOREIGN KEY ("training_id") REFERENCES "public"."reg_instruire" ("training_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."rec_recenzie" ADD CONSTRAINT "rec_recenzie_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."usr_utilizator" ("user_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table reg_candidat
-- ----------------------------
ALTER TABLE "public"."reg_candidat" ADD CONSTRAINT "reg_candidat_locality_id_fkey" FOREIGN KEY ("locality_id") REFERENCES "public"."cls_localitate" ("locality_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table reg_examinator
-- ----------------------------
ALTER TABLE "public"."reg_examinator" ADD CONSTRAINT "reg_examinator_office_id_fkey" FOREIGN KEY ("office_id") REFERENCES "public"."reg_oficiu" ("office_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table reg_instructor
-- ----------------------------
ALTER TABLE "public"."reg_instructor" ADD CONSTRAINT "reg_instructor_school_id_fkey" FOREIGN KEY ("school_id") REFERENCES "public"."reg_scoala_auto" ("school_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table reg_instructor_categorie
-- ----------------------------
ALTER TABLE "public"."reg_instructor_categorie" ADD CONSTRAINT "reg_instructor_categorie_category_code_fkey" FOREIGN KEY ("category_code") REFERENCES "public"."cls_categorie" ("category_code") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."reg_instructor_categorie" ADD CONSTRAINT "reg_instructor_categorie_instructor_id_fkey" FOREIGN KEY ("instructor_id") REFERENCES "public"."reg_instructor" ("instructor_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table reg_instruire
-- ----------------------------
ALTER TABLE "public"."reg_instruire" ADD CONSTRAINT "reg_instruire_branch_id_fkey" FOREIGN KEY ("branch_id") REFERENCES "public"."reg_scoala_filiala" ("branch_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."reg_instruire" ADD CONSTRAINT "reg_instruire_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "public"."reg_candidat" ("candidate_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."reg_instruire" ADD CONSTRAINT "reg_instruire_category_code_fkey" FOREIGN KEY ("category_code") REFERENCES "public"."cls_categorie" ("category_code") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."reg_instruire" ADD CONSTRAINT "reg_instruire_instructor_id_fkey" FOREIGN KEY ("instructor_id") REFERENCES "public"."reg_instructor" ("instructor_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."reg_instruire" ADD CONSTRAINT "reg_instruire_school_id_fkey" FOREIGN KEY ("school_id") REFERENCES "public"."reg_scoala_auto" ("school_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table reg_oficiu
-- ----------------------------
ALTER TABLE "public"."reg_oficiu" ADD CONSTRAINT "reg_oficiu_locality_id_fkey" FOREIGN KEY ("locality_id") REFERENCES "public"."cls_localitate" ("locality_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table reg_oficiu_alias
-- ----------------------------
ALTER TABLE "public"."reg_oficiu_alias" ADD CONSTRAINT "reg_oficiu_alias_office_id_fkey" FOREIGN KEY ("office_id") REFERENCES "public"."reg_oficiu" ("office_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table reg_scoala_auto
-- ----------------------------
ALTER TABLE "public"."reg_scoala_auto" ADD CONSTRAINT "reg_scoala_auto_locality_id_fkey" FOREIGN KEY ("locality_id") REFERENCES "public"."cls_localitate" ("locality_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table reg_scoala_categorie
-- ----------------------------
ALTER TABLE "public"."reg_scoala_categorie" ADD CONSTRAINT "reg_scoala_categorie_category_code_fkey" FOREIGN KEY ("category_code") REFERENCES "public"."cls_categorie" ("category_code") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."reg_scoala_categorie" ADD CONSTRAINT "reg_scoala_categorie_school_id_fkey" FOREIGN KEY ("school_id") REFERENCES "public"."reg_scoala_auto" ("school_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table reg_scoala_filiala
-- ----------------------------
ALTER TABLE "public"."reg_scoala_filiala" ADD CONSTRAINT "reg_scoala_filiala_locality_id_fkey" FOREIGN KEY ("locality_id") REFERENCES "public"."cls_localitate" ("locality_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."reg_scoala_filiala" ADD CONSTRAINT "reg_scoala_filiala_school_id_fkey" FOREIGN KEY ("school_id") REFERENCES "public"."reg_scoala_auto" ("school_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table reg_vehicul
-- ----------------------------
ALTER TABLE "public"."reg_vehicul" ADD CONSTRAINT "reg_vehicul_category_code_fkey" FOREIGN KEY ("category_code") REFERENCES "public"."cls_categorie" ("category_code") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."reg_vehicul" ADD CONSTRAINT "reg_vehicul_school_id_fkey" FOREIGN KEY ("school_id") REFERENCES "public"."reg_scoala_auto" ("school_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table stat_scoala_perioada
-- ----------------------------
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_category_code_fkey" FOREIGN KEY ("category_code") REFERENCES "public"."cls_categorie" ("category_code") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."stat_scoala_perioada" ADD CONSTRAINT "stat_scoala_perioada_school_id_fkey" FOREIGN KEY ("school_id") REFERENCES "public"."reg_scoala_auto" ("school_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table usr_utilizator
-- ----------------------------
ALTER TABLE "public"."usr_utilizator" ADD CONSTRAINT "usr_utilizator_candidate_id_fkey" FOREIGN KEY ("candidate_id") REFERENCES "public"."reg_candidat" ("candidate_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."usr_utilizator" ADD CONSTRAINT "usr_utilizator_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."cls_rol" ("role_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."usr_utilizator" ADD CONSTRAINT "usr_utilizator_school_id_fkey" FOREIGN KEY ("school_id") REFERENCES "public"."reg_scoala_auto" ("school_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
