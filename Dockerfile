# Use python 3.9 with Alpine Linux 3.13 as base image
FROM python:3.9-alpine3.13

# Set the maintainer label for the image
LABEL maintainer="londonappdeveloper.com"

# Set the PYTHONUNBUFFERED environment variable to prevent Python from buffering stdout and stderr
ENV PYTHONUNBUFFERED 1

# Copy the requirements.txt files to the /tmp directory of the container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy the 'app' directory to '/app' in the container
COPY ./app /app

# Set the working directory to '/app'
WORKDIR /app

# Expose port 8000
EXPOSE 8000

# Set an argument for whether the image is being built for development
ARG DEV=false
# Create a Python virtual environment and install dependencies
RUN python -m venv /py && \ 
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    # remove the /tmp directory to reduce image size
    rm -rf /tmp && \
    # remove the temporary build dependencies
    apk del .tmp-build-deps && \
    # create a new user for running the Docker container
    adduser \
        --disabled-password \
        --no-create-home \
        django-user
# Install Flake8
RUN pip install --no-cache-dir flake8
# Add /py/bin to PATH and set user to 'django-user'
ENV PATH="/py/bin:$PATH"
USER django-user

