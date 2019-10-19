FROM ubuntu:18.04

# User Name
ARG USERNAME=yoichiro

# Install Dependencies
RUN apt-get update && \
    apt-get install -y build-essential wget curl zip rbenv git language-pack-ja-base language-pack-ja && \
    locale-gen ja_JP.UTF-8

# Add a new user
RUN groupadd --gid 1000 $USERNAME && useradd -u 1000 -g 1000 -s /bin/bash -d /home/$USERNAME -m $USERNAME
USER $USERNAME

WORKDIR /home/$USERNAME

# Install nodebrew and NodeJS 8, Ruby 2.6, jekyll, bower
RUN curl -L git.io/nodebrew | perl - setup && \
    /home/$USERNAME/.nodebrew/current/bin/nodebrew install-binary v8.15.0 && \
    /home/$USERNAME/.nodebrew/current/bin/nodebrew use v8.15.0 && \
    /bin/bash -c 'echo "export PATH=\$HOME/.nodebrew/current/bin:\$PATH" >> $HOME/.bashrc' && \
    mkdir -p "$(rbenv root)"/plugins && \
    git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build && \
    rbenv install 2.6.0 && \
    rbenv global 2.6.0 && \
    /bin/bash -c 'echo "export PATH=\$HOME/.rbenv/bin:\$PATH" >> $HOME/.bashrc' && \
    /bin/bash -c 'echo "eval \"\$(rbenv init -)\"" >> $HOME/.bashrc' && \
    /home/$USERNAME/.rbenv/shims/gem install jekyll -v "3.8.6" && \
    /home/$USERNAME/.rbenv/shims/gem jekyll-archives jekyll-paginate && \
    /bin/bash -c 'echo "export LANG=ja_JP.UTF-8" >> $HOME/.bashrc'

# Prepare working directory
WORKDIR /home/$USERNAME/project

VOLUME /home/$USERNAME/project
EXPOSE 4000

CMD ["/bin/bash"]
