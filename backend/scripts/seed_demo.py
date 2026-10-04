"""Create a small, presentable local database for the Driving Schools API."""
from __future__ import annotations

import os
from pathlib import Path

import psycopg2
from dotenv import load_dotenv

ROOT = Path(__file__).resolve().parents[1]
load_dotenv(ROOT / '.env')
DB_NAME = os.getenv('DB_NAME', 'driving_schools_demo')
CONNECTION = dict(
    user=os.getenv('DB_USER', 'postgres'), password=os.getenv('DB_PASSWORD', 'postgres'),
    host=os.getenv('DB_HOST', 'localhost'), port=os.getenv('DB_PORT', '5432'),
)

SCHEMA = '''
DROP SCHEMA public CASCADE; CREATE SCHEMA public;
CREATE TABLE raioane (district_id smallint, name_ro varchar(100));
CREATE TABLE localitati (locality_id int, district_id smallint, name_ro varchar(150), latitude numeric, longitude numeric);
CREATE TABLE categorii_permise (category_code varchar(5), parent_category_code varchar(5), description_ro text, min_age smallint, sort_order smallint, is_active boolean);
CREATE TABLE scoli_auto (school_id int, name text, short_name text, is_verified boolean, legal_form text, license_number text, license_expiry_date date, founded_year int, description text, locality_id int, address text, latitude numeric, longitude numeric, phone text, email text, website text, is_active boolean);
CREATE TABLE categorii_scoli_auto (school_id int, category_code varchar(5), price numeric, currency text, theory_hours int, practice_hours int, duration_weeks int, is_active boolean);
CREATE TABLE filiale_scoli_auto (branch_id int, school_id int, name text, locality_id int, address text, latitude numeric, longitude numeric, phone text, has_training_ground boolean, is_active boolean);
CREATE TABLE statistici_scoli_perioade (school_id int, category_code varchar(5), period_year int, period_month int, candidates_total int, theory_attempts int, theory_passed int, theory_first_attempt_passed int, practice_attempts int, practice_passed int, practice_first_attempt_passed int, theory_pass_rate numeric, theory_first_attempt_rate numeric, practice_pass_rate numeric, practice_first_attempt_rate numeric, avg_attempts_to_pass numeric, avg_penalty_points numeric, rank_position int);
CREATE TABLE utilizatori (user_id int, full_name text);
CREATE TABLE recenzii (review_id int, school_id int, user_id int, category_code varchar(5), rating_overall smallint, rating_theory smallint, rating_practice smallint, rating_instructors smallint, rating_vehicles smallint, rating_price smallint, title text, comment_text text, is_verified_graduate boolean, status text, created_at timestamptz);
CREATE TABLE examene (exam_id bigint, candidate_id int, first_attempt_date date);
CREATE TABLE instructori (instructor_id int, school_id int, is_active boolean);
CREATE TABLE vehicule (vehicle_id int, school_id int, is_active boolean);
'''

SCHOOL_NAMES = '''
Școala Auto Codru Drive|Auto-Școala Drum Sigur|Școala de Șoferi Volan Plus|Autostart Moldova|Școala Auto Capitală Drive|Rotor Auto Școală|Școala Auto Magistral|Școala Auto Nord Drive|Auto-Școala Răut Plus|Școala Auto Nistru Drive|Auto-Școala Cetatea Drive|Școala Auto Bîc Drive|Auto-Școala Pas Sigur|Școala Auto Sud Express|Auto-Școala Hotar Drive|Școala Auto Prut Nord|Auto-Școala Pionier|Școala Auto Prut Drive|Auto-Școala Lunca Prutului|Școala Auto Cantemir Drive|Auto-Școala Viteza|Auto-Școala Meridian|Școala Auto Bugeac Drive|Auto-Școala Cursa Sigură|Auto-Școala Stepa Drive|Auto-Școala Vector|Școala Auto Dubăsari Drive|Auto-Școala Nistrean|Școala Auto Nordic Drive|Auto-Școala Orizont|Auto-Școala Zenit Drive|Auto-Școala Drochia Pro|Școala Auto Nistru Verde|Auto-Școala Start Nou|Școala Auto Vest Nord|Auto-Școala Cursor|Școala Auto Lunca Drive|Auto-Școala Falcon|Școala Auto Rapid Drive|Auto-Școala Pilot|Școala Auto Glod Drive|Auto-Școala Itinerar|Școala Auto Codrii Drive|Auto-Școala Sprint Plus|Școala Auto Sud-Est Drive|Auto-Școala Alfa Drive|Școala Auto Prut Sud|Auto-Școala Leova Motor|Școala Auto Gloria Drive|Auto-Școala Tempo|Școala Auto Nistru Nord|Auto-Școala Cobalt|Școala Auto Orheiul Vechi|Auto-Școala Răut Drive|Școala Auto Stâncă Drive|Auto-Școala Delta|Școala Auto Platou Drive|Școala Auto Ritm|Școala Auto Răut Nord|Auto-Școala Optim Drive|Școala Auto Cetate Drive|Școala Auto Meteor|Școala Auto Codru Plus|Auto-Școala Premier|Școala Auto Valea Nistrului|Auto-Școala Avantaj|Școala Auto Bugeac Sud|Auto-Școala Stelar|Școala Auto Bugeac Plus|Școala Auto Euro Drive|Școala Auto Codru Nord|Auto-Școala Impuls|Școala Auto Prut Express|Auto-Școala Frontieră|Școala Auto Gagauzia Drive|Auto-Școala Mozaic
'''.strip().split('|')

LOCATIONS = [
    ('Chișinău', 1, 47.0105, 28.8638), ('Bălți', 2, 47.7617, 27.9289),
    ('Orhei', 3, 47.3849, 28.8245), ('Cahul', 4, 45.9075, 28.1944),
    ('Căușeni', 5, 46.6436, 29.4111),
]

SCHOOLS = [
    (
        name, city, locality, lat + ((cluster % 4) - 1.5) * 0.006,
        lon + ((cluster // 4) - 1.5) * 0.008, 68 + (index * 3) % 16,
        56 + (index * 5) % 18, 48 + (index * 4) % 17,
        5600 + (index * 350) % 5000,
    )
    for index, name in enumerate(SCHOOL_NAMES, 1)
    for city, locality, lat, lon in [LOCATIONS[(index - 1) % len(LOCATIONS)]]
    for cluster in [(index - 1) // len(LOCATIONS)]
]

# Verified public school locations. Metrics remain demonstrative until official
# performance data is imported.
SCHOOLS = [
    ('Școala Auto START', 'Chișinău', 1, 47.0267381, 28.8305813, 75, 58, 50, 12580),
    ('Școala Auto Andrieș-Prim', 'Chișinău', 1, 47.0191237, 28.8277729, 74, 57, 49, 14000),
    ('Școala Auto Rutfor', 'Chișinău', 1, 47.0306130, 28.8319472, 72, 55, 47, 11500),
    ('Școala Auto Altais', 'Chișinău', 1, 47.0284947, 28.8421792, 70, 53, 45, 11000),
    ('Școala Auto Maldini', 'Chișinău', 1, 47.0244537, 28.8214548, 73, 56, 48, 12000),
    ('AutoMaestro', 'Chișinău', 1, 46.9838436, 28.8456427, 71, 54, 46, 12000),
    ('Școala Auto AutoValdor', 'Chișinău', 1, 46.9977281, 28.8622139, 69, 52, 44, 10500),
    ('Școala Auto Maldini Telecentru', 'Chișinău', 1, 46.9941109, 28.8218604, 72, 55, 47, 11500),
    ('Școala Auto USMF', 'Chișinău', 1, 46.9951588, 28.8351395, 76, 60, 52, 11800),
    ('Școala Auto ForȘaj', 'Bălți', 2, 47.7776000, 27.8960000, 74, 59, 51, 10800),
]

SCHOOL_ADDRESSES = {
    'Școala Auto START': 'Stradela Teatrului 3, etajul 2, oficiul 4, Chișinău',
    'Școala Auto Andrieș-Prim': 'Str. Alexandru Pușkin 16, Chișinău',
    'Școala Auto Rutfor': 'Str. Alexandru cel Bun 111, Chișinău',
    'Școala Auto Altais': 'Str. Alexandru Pușkin 54, Chișinău',
    'Școala Auto Maldini': 'Str. Alexei Șciusev 98, Chișinău',
    'AutoMaestro': 'Str. Independenței 10/2, Chișinău',
    'Școala Auto AutoValdor': 'Str. Minsk 47, Chișinău',
    'Școala Auto Maldini Telecentru': 'Str. Gheorghe Asachi 71, Chișinău',
    'Școala Auto USMF': 'Str. Nicolae Testemițanu 27, Chișinău',
    'Școala Auto ForȘaj': 'Str. Conev 48, Bălți',
}

def main() -> None:
    admin = psycopg2.connect(dbname='postgres', **CONNECTION)
    admin.autocommit = True
    with admin.cursor() as cur:
        cur.execute('SELECT 1 FROM pg_database WHERE datname = %s', (DB_NAME,))
        if not cur.fetchone(): cur.execute(f'CREATE DATABASE "{DB_NAME}"')
    admin.close()
    db = psycopg2.connect(dbname=DB_NAME, **CONNECTION)
    with db, db.cursor() as cur:
        cur.execute(SCHEMA)
        cur.executemany('INSERT INTO raioane VALUES (%s,%s)', [(1,'Chișinău'),(2,'Bălți'),(3,'Orhei'),(4,'Cahul'),(5,'Căușeni')])
        cur.executemany('INSERT INTO localitati VALUES (%s,%s,%s,%s,%s)', [(1,1,'Chișinău',47.0105,28.8638),(2,2,'Bălți',47.7617,27.9289),(3,3,'Orhei',47.3849,28.8245),(4,4,'Cahul',45.9075,28.1944),(5,5,'Căușeni',46.6436,29.4111)])
        cur.executemany('INSERT INTO categorii_permise VALUES (%s,%s,%s,%s,%s,%s)', [('A1','A','Motociclete ușoare',16,1,True),('A2','A','Motociclete',18,2,True),('A',None,'Motociclete',24,3,True),('B',None,'Autoturisme',18,4,True),('BE','B','Autoturisme cu remorcă',18,5,True),('C',None,'Camioane',21,6,True),('CE','C','Camioane cu remorcă',21,7,True)])
        for index, (name, city, locality, lat, lon, theory, practice, first, price) in enumerate(SCHOOLS, 1):
            address = SCHOOL_ADDRESSES[name]
            cur.execute('INSERT INTO scoli_auto VALUES (%s,%s,%s,true,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,true)', (index, name+' SRL', name, 'SRL', f'MD-{index:04}', '2029-12-31', 2010+index, 'Școală auto licențiată, cu instructori și programe pentru pregătirea permisului.', locality, address, lat, lon, f'+373 60 000 {index:03}', f'contact{index}@auto.md', f'https://{index}.auto.md'))
            for code, multiplier in [('B',1), ('A1',0.72), ('C',1.25)]:
                cur.execute('INSERT INTO categorii_scoli_auto VALUES (%s,%s,%s,%s,%s,%s,%s,true)', (index, code, round(price*multiplier), 'MDL', 30, 35, 10))
            cur.execute('INSERT INTO filiale_scoli_auto VALUES (%s,%s,%s,%s,%s,%s,%s,%s,true,true)', (index,index,name+' — sediu',locality,address,lat,lon,f'+373 60 000 {index:03}'))
            candidates = 120 + index * 17; ta = candidates + 30; pa = candidates + 20; tp = round(ta*theory/100); pp = round(pa*practice/100)
            cur.execute('INSERT INTO statistici_scoli_perioade VALUES (%s,%s,2025,0,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,1.4,8,%s)', (index,'B',candidates,ta,tp,round(candidates*theory/100),pa,pp,round(candidates*first/100),theory,theory-5,practice,first, index))
            for month in range(1,13):
                delta = (month % 4 - 1.5) * 2
                mtheory, mpractice = round(theory+delta), round(practice-delta)
                cur.execute('INSERT INTO statistici_scoli_perioade VALUES (%s,%s,2025,%s,18,20,%s,14,20,%s,12,%s,70,%s,%s,1.4,8,%s)', (index, 'B', month, round(20 * mtheory / 100), round(20 * mpractice / 100), mtheory, mpractice, first, index))
            for review in range(2): cur.execute('INSERT INTO recenzii VALUES (%s,%s,%s,%s,%s,4,4,5,4,4,%s,%s,true,%s,now())', (index*10+review,index,index*10+review,'B',4+(review%2),'Experiență bună','Instructori profesioniști și program flexibil.','aprobat'))
            for candidate in range(min(candidates, 40)): cur.execute('INSERT INTO examene VALUES (%s,%s,%s)', (index*10000+candidate,index*1000+candidate,'2025-06-01'))
            for item in range(3): cur.execute('INSERT INTO instructori VALUES (%s,%s,true)', (index*10+item,index)); cur.execute('INSERT INTO vehicule VALUES (%s,%s,true)', (index*10+item,index))
    db.close()
    print(f'{DB_NAME} seeded with {len(SCHOOLS)} named schools.')

if __name__ == '__main__': main()
