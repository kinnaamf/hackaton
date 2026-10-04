# Driving Schools

- `backend/`: FastAPI + PostgreSQL API, served under `/api`
- `frontend/`: Vue + Vite app
- `database/public.sql`: full dataset dump (~58 MB, ~327k `INSERT`s)
- `database/seed/demo.sql`: lightweight demo seed for local development

## Local development with the demo database

`public.sql` is too heavy to import on a low-resource machine. For frontend work, use
the demo seed instead. It loads in about a second and contains:

- 8 schools in 5 localities (Chișinău, Bălți, Cahul, Orhei, Ungheni), 5 branches
- 9 licence categories, with prices per school
- monthly and yearly statistics for 2024–2025, plus ranks
- about 3,800 generated exam rows (2,080 candidates)
- 15 reviews, one of them rejected by moderation so it stays hidden

It creates only the tables the API reads, using the same column definitions as
`public.sql`, so the API works against it unchanged.

### 1. Start PostgreSQL

You need PostgreSQL 12 or newer (the seed uses generated columns). Use either option:

- **An existing local server** (Windows service, Postgres.app, `brew services`, …): make
  sure it is running and you know the `postgres` password.
- **Docker** (port 5433, so it can't clash with a local server):

  ```bash
  docker run -d --name driving-schools-db -e POSTGRES_PASSWORD=postgres -p 5433:5432 postgres:16-alpine
  ```

### 2. Configure the backend

```bash
cd backend
cp .env.example .env
```

In `.env`, set `DB_PASSWORD` (and `DB_PORT=5433` if you use Docker). Then point
`DB_NAME` at a **separate** database:

```dotenv
DB_NAME=driving_schools_demo
```

The seed drops and recreates its tables. The loader refuses to run against a database
that holds the full dump, unless you pass `--force`.

### 3. Install dependencies and load the demo seed

```bash
# inside backend/
python -m venv .venv
.venv\Scripts\activate          # Windows  (macOS/Linux: source .venv/bin/activate)
pip install -r requirements.txt

python -m scripts.seed_demo
```

`scripts.seed_demo` creates the database if it is missing and then runs
`database/seed/demo.sql`. You can run it again at any time to reset the demo data.
If you have `psql`, this does the same thing (the database must already exist):

```bash
psql -U postgres -d driving_schools_demo -f ../database/seed/demo.sql
```

### 4. Run the API

```bash
# inside backend/, with the venv active
uvicorn app.main:app --reload
```

- API: <http://localhost:8000/api/...>
- Interactive docs: <http://localhost:8000/docs>

### 5. Smoke-test the endpoints

```bash
curl http://localhost:8000/api/stats/overview
curl http://localhost:8000/api/filters
curl "http://localhost:8000/api/schools?category=B&limit=5"
curl http://localhost:8000/api/schools/featured
```

`/api/schools` and `/api/schools/featured` default to category `B` and the latest year
with statistics (2025 in the demo data). School detail pages
(`/api/schools/{id}`, `/performance`, `/reviews`) work with the demo data too.

### 6. Run the frontend

```bash
cd frontend
npm install
npm run dev     # http://localhost:5173, already allowed by CORS_ORIGINS
```

## Public dataset

`scripts.seed_public` loads the data from `database/public.sql` into a database named
`postgresql`, limited to the 12 tables the API reads (76 schools, 4.8k statistics rows,
843 reviews, 45k exams). Column definitions, keys, checks, indexes and foreign keys are
kept as in the dump. It skips the attempt-level tables (`tentative_examinare`,
`penalizari_tentative`, …), which make up most of the file, so it loads in a few seconds
without psql.

On top of the dump it:

- adds back the 10 real schools from `seed_demo.py` (ids 77–86, verified addresses and
  coordinates, B/A1/C prices, a seat branch, instructors and vehicles);
- generates 2025 (Jan–Dec) and 2026 (Jan–Sep) statistics and exam rows for every school
  without statistics (ids 46–86);
- keeps every theory pass rate strictly between 80% and 95%, adjusting the dump's own
  statistics rows where needed;
- sets every licence to expire between 2028 and 2031;
- recomputes `rank_position` for every category, year and month
  (0.3 × theory + 0.4 × practice + 0.3 × practice first-try rate).

Generation uses a fixed random seed, so every run produces the same data.

```bash
# inside backend/, with the venv active
python -m scripts.seed_public                 # creates/resets the postgresql database
python -m scripts.seed_public --db my_db      # or another database
```

Then set `DB_NAME=postgresql` in `.env` and run the API as above.

To get every table, import `database/public.sql` into its own database using psql or a
GUI client.
