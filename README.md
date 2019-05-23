docker-jqplay-jackson-jq
========================

Dockerfile for [jqplay](https://github.com/jingweno/jqplay) with jq replaced with jackson-jq.

Usage
-----

1. Build docker image

   ```
   docker build -t jqplay-jackson-jq .
   ```

2. Setup PostgreSQL

   ```sh
   docker run --name jqplay-postgres -e POSTGRES_DB=jqplay -d postgres
   curl https://raw.githubusercontent.com/jingweno/jqplay/929ffc5df87b9cd586a617277bdcbeba85406f93/server/db.sql | docker exec -i jqplay-postgres psql -d jqplay -U postgres -f -
   ```

3. Run jqplay server

   ```sh
   docker run --rm -e DATABASE_URL="host=jqplay-postgres dbname=jqplay sslmode=disable user=postgres" --link=jqplay-postgres -p 8080:8080 jqplay-jackson-jq
   ```

4. Go to [http://localhost:8080](http://localhost:8080).

License
-------

This Dockerfile is released under the MIT license. See [LISENSE.md](LICENSE.md)
