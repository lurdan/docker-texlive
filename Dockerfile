FROM debian:sid-slim

RUN apt update && \
  apt -y full-upgrade && \
  apt install -y --no-install-recommends \
    $(apt-cache depends texlive-full | awk '/Depends:/{print $2}' | egrep -v '(\-doc|arabic|chinese|cyrillic|czechslovak|european|french|german|greek|italian|korean|polish|portuguese|spanish|lang-other|games|music|^context|cjk-all|formats-extra|extra-links|science|xetex|humanities|fonts-extra|bibtex-extra|tex-gyre|cm-super)') \
    wget unzip ca-certificates && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

ENV FONTPATH /usr/local/share/texmf/fonts/opentype
VOLUME /var/lib/texmf/luatex-cache
RUN mkdir -p $FONTPATH/public && \
  wget -qO $FONTPATH/public/haranoaji.zip \
  https://github.com/trueroad/HaranoAjiFonts/archive/master.zip && \
  cd $FONTPATH/public && unzip -q -j -d haranoaji haranoaji.zip && \
  rm haranoaji.zip && \
  texhash && \
  luaotfload-tool -u -f

WORKDIR /workdir

CMD ["/bin/sh"]
