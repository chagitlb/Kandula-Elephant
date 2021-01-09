FROM python:3

LABEL maintainer="chagitlb@gmail.com"

ADD run.py /

RUN pip install -r requirements.txt

EXPOSE 5000

CMD [ "python3", "./run.py" ]

