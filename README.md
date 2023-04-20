# recipe-app-api
Recipe API Project


## Tech stacks

<img width="557" alt="Group 29" src="https://user-images.githubusercontent.com/29207172/232734953-656311da-ca27-445d-ac31-6affcbd2eb90.png">

- Django Python
- PostgreSQL
- Docker compose

## Create user administration
1. Create `test_models.py`
To run test, use the command `docker-compose run --rm app sh -c "python manage.py test"` 
2. Define model in `models.py` file
3. Remember add config `AUTH_USER_MODE='core.User'` to `settings.py`
4. Run cmd to migrations for project, that will generate the 0001_initial.py file for config User on `models.py` file

```perl
docker-compose run --rm app sh -c "python manage.py makemigrations"
[+] Running 1/0
✔ Container recipe-app-api-db-1  Running                                                                                           0.0s
Migrations for 'core':
core/migrations/0001_initial.py
- Create model User
```

Run the command `docker-compose run --rm app sh -c "python manage.py wait_for_db && python manage.py migrate"` This command waits for the database to become available before proceeding with the next command. This is useful in situations where the database may take some time to start up, such as when using Docker containers.`python manage.py migrate`: This command applies any pending database migrations to the database. It updates the database schema to match the current version of the codebase.

- First, Run cmd to check DB on docker:

`docker volume ls` 

```perl
DRIVER    VOLUME NAME
local     7c28b6ee7ab3fe0f65e0c2262e9ec51db555c3ffa439e2420774cf6a420579d3
local     recipe-app-api_dev-db-data
```

`docker volume rm recipe-app-api_dev-db-data` 

```perl
Error response from daemon: remove recipe-app-api_dev-db-data: volume is in use - [4cdf74550418c8b1975b82f5dd5a4466db0462bd0a1cd221c5e54cf2bec16a0a]
```

If you have this error, run step by step with following cmd:
`docker-compose down`

`docker volume rm recipe-app-api_dev-db-data`

`docker-compose run --rm app sh -c "python manage.py wait_for_db && python manage.py migrate"`

when you see the DB was created successfully. Run cmd test again, it will be return passed.

After making sure the DB migrations successfully, we continue to create test and function on user model
- Add a feature to normalize user email

- Create require the email input

- Add superuser support

5. Testing

`docker-compose up` to start server

Open `127.0.0.1:8000/admin/login` 

<img width="1433" alt="Screenshot 2023-04-20 at 1 28 20 PM" src="https://user-images.githubusercontent.com/29207172/233285787-ddaa6d1e-4c69-40d8-825c-a936a160801b.png">

To by pass login, you must create a superuser by using this command:

`docker-compose run --rm app sh -c "python manage.py createsuperuser"`

```perl
lanluu@Lans-MacBook-Pro recipe-app-api % docker-compose run --rm app sh -c "python [manage.py](http://manage.py/) createsuperuser"
[+] Running 1/0
✔ Container recipe-app-api-db-1  Running                                                                                   0.0s
Email: [admin@example.com](mailto:admin@example.com)
Password:
Password (again):
This password is too short. It must contain at least 8 characters.
This password is too common.
Bypass password validation and create user anyway? [y/N]: n
Password:
Password (again):
Superuser created successfully.
```

email: admin@example.com
password: test123!@#

Done!

