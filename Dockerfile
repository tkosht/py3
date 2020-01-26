FROM nvidia/cuda

MAINTAINER tkosht <takehito.oshita.business@gmail.com>

ENV TZ Asia/Tokyo
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y sudo git sysstat vim tmux tzdata

RUN apt-get install -y --no-install-recommends \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        apt-utils \
        dialog \
    && apt-get -y install autoconf libtool \
    # for python modules
    && apt-get install -y iproute2 procps lsb-release git locales \
    && localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

ENV LANG="ja_JP.UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8"

# - upgrade system
RUN apt-get upgrade -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# - make links
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN ln -s /usr/bin/pdb3 /usr/bin/pdb

# - prepare the scripts
ARG tmp_dir=/tmp/build
RUN mkdir -p $tmp_dir
COPY requirements.txt $tmp_dir
RUN pip3 install --no-cache-dir -r $tmp_dir/requirements.txt
RUN rm -rf $tmp_dir

ARG user_id=1000
ARG group_id=1000
ARG user_name=gpuser
ARG group_name=gpuser

RUN groupadd --gid $group_id $group_name
RUN useradd -s /bin/bash --uid $user_id --gid $group_id -m $user_name
ARG home_dir=/home/$user_name
# COPY config/tmux/.tmux.conf $home_dir

# - for sudo
RUN echo $user_name ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$user_name\
    && chmod 0440 /etc/sudoers.d/$user_name

ARG lab_dir=$home_dir/pj/lab
RUN mkdir -p $lab_dir
WORKDIR $lab_dir
RUN git clone https://github.com/pytorch/examples.git

RUN chown -R $user_name:$group_name $home_dir

USER $user_name
WORKDIR $lab_dir

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
