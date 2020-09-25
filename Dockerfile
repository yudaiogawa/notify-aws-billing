FROM lambci/lambda:python3.8

RUN pip install pipenv
RUN pipenv install -r requirements.txt
