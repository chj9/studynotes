FROM 'docker.elastic.co/elasticsearch/elasticsearch:7.12.1'

COPY --chown=1000:1000 ./jieba /usr/share/elasticsearch/plugins/jieba
COPY --chown=1000:1000 ./jieba/dic/stopwords.txt /usr/share/elasticsearch/config/stopwords/
