FROM lsiobase/nginx:3.13

# set version label
ARG BUILD_DATE
ARG VERSION
ARG TT_RSS_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="dreytac"

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache --upgrade \
	curl \
	git \
	grep \
	php8 \
	php8-curl \
	php8-dom \
	php8-fileinfo \
	php8-fpm \
	php8-gd \
	php8-iconv \
	php8-intl \
	php8-json \
	php8-ldap \
	php8-mbstring \
	php8-mysqli \
	php8-mysqlnd \
	php8-pcntl \
	php8-pdo \
	php8-pdo_mysql \
	php8-pdo_pgsql \
	php8-pgsql \
	php8-posix \
	php8-openssl \
	php8-session \
	php8-simplexml
	php8-xml \
	php8-xmlwriter \
	php8-zlib \
	php8-zip \
	tar && \
 echo "**** install software ****" && \
 mkdir -p \
	/var/www/html/ && \
 if [ -z ${TT_RSS_VERSION+x} ]; then \
 	TT_RSS_VERSION=$(git ls-remote https://git.tt-rss.org/fox/tt-rss.git HEAD | cut -c1-8); \
 fi && \
#curl -o \
#	/tmp/ttrss.tar.gz -L \
#	"https://git.tt-rss.org/git/tt-rss/archive/${TT_RSS_VERSION}.tar.gz" && \
# tar xf \
# /tmp/ttrss.tar.gz -C \
#	/var/www/html/ --strip-components=1 && \
 git clone https://git.tt-rss.org/fox/tt-rss.git /var/www/html && \
 echo "**** link php8 to php ****" && \
 ln -sf /usr/bin/php8 /usr/bin/php && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
