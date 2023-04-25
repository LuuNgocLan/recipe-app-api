# recipe-app-api
This is the source code repository for a recipe management RESTful API built with Django and Django REST Framework.

The API allows users to create, read, update, and delete recipes, as well as manage recipe ingredients and tags.

## Tech Stack
The Recipe App API is built using the following technologies:
- Python: Version 3.6 or later.
- Django
- Django REST Framework
- PostgreSQL
- Docker

<img width="557" alt="Group 29" src="https://user-images.githubusercontent.com/29207172/232734953-656311da-ca27-445d-ac31-6affcbd2eb90.png">

## Requirements
To run the Recipe App API, you will need the following:

- Python 3.6 or later
- Docker (optional)

## API Documentation
API documentation is available at http://127.0.0.1:8000/api/docs/ (when running the API locally) or at the corresponding URL on your server.


## Running Tests

----

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

- First, check DB on docker:

Run `docker volume ls` 

```perl
DRIVER    VOLUME NAME
local     7c28b6ee7ab3fe0f65e0c2262e9ec51db555c3ffa439e2420774cf6a420579d3
local     recipe-app-api_dev-db-data
```

Run `docker volume rm recipe-app-api_dev-db-data` 

```perl
Error response from daemon: remove recipe-app-api_dev-db-data: volume is in use - [4cdf74550418c8b1975b82f5dd5a4466db0462bd0a1cd221c5e54cf2bec16a0a]
```

If you have this error, run step by step with following cmd:
`docker-compose down`

`docker volume rm recipe-app-api_dev-db-data`

`docker-compose run --rm app sh -c "python manage.py wait_for_db && python manage.py migrate"`

When you see the DB was created successfully. Run cmd test again, it will be return passed.

After making sure the DB migrations successfully, we continue to create test and function on user model
- Add a feature to normalize user email

- Create require the email input

- Add superuser support

5. Testing function

Run `docker-compose up` to start server

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

## Setup Django Admin
Django Admin is GUI for models with basic functions: create, read, update, delete. The main concept of code as below:

![Group 39](https://user-images.githubusercontent.com/29207172/233340760-620a652a-a5bc-4302-9aa0-8064f2a2a9bb.png)

Run test: `docker-compose run --rm app sh -c "python manage.py test"`
Run Admin console: `docker-compose up`

![Screen_Recording_2023-04-20_at_5_36_42_PM_AdobeExpress_AdobeExpress](https://user-images.githubusercontent.com/29207172/233344609-45338dbd-accd-4e2d-a894-fd51c6b0c1c7.gif)

## Create API swagger documentation

![Group 44](https://user-images.githubusercontent.com/29207172/233530834-a14742cc-215f-4d96-9858-16f8085954db.png)

- First, define  the lib on `requirementations.txt`

```perl
drf-spectacular>=0.15.1,<0.16
```

- Run `docker-compose build` to build the library added
- On `settings.py` add the following code to define two Django packages that will be included as part of the installed apps in a Django project.

```python
INSTALLED_APPS = [
    ...,
    'rest_framework',
    'drf_spectacular',
]
```

`'rest_framework'`refers to the Django REST framework (DRF) which is a toolkit for building Web APIs

`'drf_spectacular'` is an extension for DRF that simplifies the process of generating OpenAPI documentation for your API views

- Configuring Django REST framework (DRF) to use the `AutoSchema`class as the default schema for generating OpenAPI documentation.

In  `settings.py`

```
REST_FRAMEWORK = {
    'DEFAULT_SCHEMA_CLASS': 'drf_spectacular.openapi.AutoSchema',
}
```

Add the config URL in `urls.py`

```python
from drf_spectacular.views import (
    SpectacularAPIView,
    SpectacularSwaggerView,
)
from django.contrib import admin
from django.urls import path

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/schema/', SpectacularAPIView.as_view(), name='api-schema'),
    path(
        'api/docs/',
        SpectacularSwaggerView.as_view(url_name='api-schema'),
        name='api-docs',
    )
         
]
```

Run `docker-compose up` to run server and access API doc at `127.0.0.1:8000/api/docs/`

![Screenshot 2023-04-21 at 9 51 00 AM](https://user-images.githubusercontent.com/29207172/233530888-0a3b918a-1dca-49a9-a60d-1bf54bbb4fa7.png)

## Build User API

### Create User API

The main steps/flow of creating User API was described below:

![Group 45 (1)](https://user-images.githubusercontent.com/29207172/234165792-fd944dc5-4f09-4227-803b-57830fa9f230.png)

- Create `user` app:

    ```perl
    docker-compose run --rm app sh -c "python manage.py startapp user"
    ```

to create `user` app in project. After creating, let remove the file unnecessary as below:

<img width="426" alt="Screenshot 2023-04-21 at 10 20 01 AM" src="https://user-images.githubusercontent.com/29207172/234165887-58f6f262-1f81-47c5-b36d-83d80d57a62c.png">

- Add `user` app to `settings.py`

`settings.py`

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'core',
    'rest_framework',
    'drf_spectacular',
    'user',
]
```

- Create `test_user_api.py`

This file contains integration tests using API testing techniques to ensure that the User API endpoint works as intended and meets the project requirements.

Run test `docker-compose run --rm app sh -c "python manage.py test"` It will be failed 🙃

- Implementation create User API to pass test

Create file `user/serializers.py` for the user API view

- Create view
- Define and mapping URL to main app

### Authorization

There are 4 types of authentication API in the browser

- Basic authentication: send username & password for each request
- Token: use in HTTP/HTTPs Header
- Json Web Token (JWT): use access and refresh token
- Session: use cookies

Let's explore token authentication and see how it works

<img width="848" alt="Group 51" src="https://user-images.githubusercontent.com/29207172/234165970-d86a7dd9-b2b9-4598-8d01-5b079d0a15d3.png">

From the Main Flow of creating new user API and we can apply for each API. With creating authentication API:

- In `[settings.py](http://settings.py)` remember to add `rest_framework.authtoken` to `INSTALLED_APPS` section.
- Create the test  for each use case related to the authentication in `test_user_api.py` file
    - test_create_token_for_user
    - test_retrieve_user_authorized
    - test_create_token_bad_credentials
    - test_create_token_blank_password
    
    Remember to define URL:
    
    ```perl
    TOKEN_URL = reverse('user:token')
    ME_URL = reverse('user:me')
    ```
    
- In `[serializers.py](http://serializers.py)`  add a method to update the password to `UserSerializer` . Besides that, create `AuthTokenSerializer` for the user and auth token.
- Import the `AuthTokenSerializer` and then define API View `CreateTokenView` and `ManageUserView` in `views.py`
- Mapping URL in `user/urls.py`

    ```perl
    path('token/', views.CreateTokenView.as_view(), name = 'token'),
    path('me/', views.ManageUserView.as_view(), name = 'me'),
    ```

Great! Let’s run the test command to see the test case passed and restart the server by using:

```perl
docker-compose up
```
See the result of User API section:

<img width="1437" alt="Screenshot 2023-04-25 at 10 58 19 AM" src="https://user-images.githubusercontent.com/29207172/234171156-3edfa185-9a75-4717-b458-0409d89079a9.png">

---
## References

- Learning Memo: https://literate-technician-def.notion.site/Learning-Memo-REST-API-with-Python-and-Django-1fa21c66933c4b56b4d3452f6b4c436e
- The Course that I learned in Udemy: https://www.udemy.com/share/101XNg3@XgZeEzx8lXZI0ZwnbZuoTCxc3LLGPg95-UPorA2qbPYBU0bijccFlbUS-6RcCRHQ/
