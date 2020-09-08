###########
# BUILDER #
###########

# pull official base image
FROM python:3.8.3-alpine as builder

# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install psycopg2 dependencies
RUN apk update \
    && apk add postgresql-dev gcc python3-dev musl-dev && apk add jpeg-dev zlib-dev libjpeg \
    && pip install Pillow

# lint
RUN pip install --upgrade pip

# install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# RUN pip install flake8
COPY . .
# RUN flake8 --ignore=E501,F401 .

# # copy project
RUN chmod +x /usr/src/app/deploy/entrypoint.sh
ENV SQL_HOST db
# run entrypoint.sh
ENTRYPOINT ["/usr/src/app/deploy/entrypoint.sh"]