FROM frolvlad/alpine-glibc:latest

ENV PATH /usr/local/texlive/2019/bin/x86_64-linux:$PATH
RUN apk upgrade --update && \
  apk add --no-cache perl py-pygments fontconfig-dev freetype-dev && \
  apk add --no-cache --virtual .build-dep wget xz tar unzip && \
  mkdir /tmp/install-tl-unx && \
  wget -qO - http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz | \
  tar -xz -C /tmp/install-tl-unx --strip-components=1 && \
  printf "%s\n" \
  "selected_scheme scheme-basic" \
  "binary_x86_64-darwin 0" \
  "binary_x86_64-linux 1" \
  "binary_win32 0" \
  "collection-xetex 0" \
  "collection-latexextra 1" \
  "collection-fontsrecommended 1" \
  "collection-langjapanese 1" \
  "option_doc 0" \
  "option_src 0" \
  "tlpdbopt_install_docfiles 0" \
  "tlpdbopt_install_srcfiles 0" \
  "in_place 0" \
  "option_adjustrepo 0" \
  "option_autobackup 0" \
  "option_desktop_integration 0" \
  "option_file_assocs 0" \
  "option_letter 0" \
  "option_menu_integration 0" \
  > /tmp/install-tl-unx/texlive.profile && \
  /tmp/install-tl-unx/install-tl \
  --profile=/tmp/install-tl-unx/texlive.profile

ENV FONTPATH /usr/local/texlive/texmf-local/fonts/opentype
VOLUME /usr/local/texlive/2019/texmf-var/luatex-cache
RUN mkdir -p $FONTPATH/public && \
  wget -qO $FONTPATH/public/haranoaji.zip \
  https://github.com/trueroad/HaranoAjiFonts/archive/master.zip && \
  cd $FONTPATH/public && unzip -q -j -d haranoaji haranoaji.zip && \
  rm haranoaji.zip && \
  mktexlsr && \
  luaotfload-tool -u -f

RUN tlmgr install latexmk ulem && \
  rm -fr /tmp/install-tl-unx && \
  apk del .build-dep

WORKDIR /workdir

CMD ["/bin/sh"]
