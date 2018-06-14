# Generated by precisionFDA exporter (v1.0.3) on 2018-06-14 15:45:38 +0000
# The asset download links in this file are valid only for 24h.

# Exported app: rna2dnalign, revision: 6, authored by: keylie.gibson
# https://precision.fda.gov/apps/app-F0Fg1q8048jGy59VJQ1Kqk1K

# For more information please consult the app export section in the precisionFDA docs

# Start with Ubuntu 14.04 base image
FROM ubuntu:14.04

# Install default precisionFDA Ubuntu packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
	aria2 \
	byobu \
	cmake \
	cpanminus \
	curl \
	dstat \
	g++ \
	git \
	htop \
	libboost-all-dev \
	libcurl4-openssl-dev \
	libncurses5-dev \
	make \
	perl \
	pypy \
	python-dev \
	python-pip \
	r-base \
	ruby1.9.3 \
	wget \
	xz-utils

# Install default precisionFDA python packages
RUN pip install \
	requests==2.5.0 \
	futures==2.2.0 \
	setuptools==10.2

# Add DNAnexus repo to apt-get
RUN /bin/bash -c "echo 'deb http://dnanexus-apt-prod.s3.amazonaws.com/ubuntu trusty/amd64/' > /etc/apt/sources.list.d/dnanexus.list"
RUN /bin/bash -c "echo 'deb http://dnanexus-apt-prod.s3.amazonaws.com/ubuntu trusty/all/' >> /etc/apt/sources.list.d/dnanexus.list"
RUN curl https://wiki.dnanexus.com/images/files/ubuntu-signing-key.gpg | apt-key add -

# Update apt-get
RUN DEBIAN_FRONTEND=noninteractive apt-get update

# Download app assets
RUN curl https://dl.dnanex.us/F/D/Kz751YVgZxv9JG0GQyy1QpBjBBbK47qxPk6724KV/RNA2DNAlign.tar.gz | tar xzf - -C / --no-same-owner --no-same-permissions

# Download helper executables
RUN curl https://dl.dnanex.us/F/D/0K8P4zZvjq9vQ6qV0b6QqY1z2zvfZ0QKQP4gjBXp/emit-1.0.tar.gz | tar xzf - -C /usr/bin/ --no-same-owner --no-same-permissions
RUN curl https://dl.dnanex.us/F/D/bByKQvv1F7BFP3xXPgYXZPZjkXj9V684VPz8gb7p/run-1.2.tar.gz | tar xzf - -C /usr/bin/ --no-same-owner --no-same-permissions

# Write app spec and code to root folder
RUN ["/bin/bash","-c","echo -E \\{\\\"spec\\\":\\{\\\"input_spec\\\":\\[\\{\\\"name\\\":\\\"bams\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":false,\\\"label\\\":\\\"Mapped\\ aligned\\ reads\\ \\(compressed\\)\\\",\\\"help\\\":\\\"compressed\\ tarball\\ \\(\\*.tar.gz\\)\\ containing\\ \\ a\\ .bam\\ \\\\u0026\\ corresponding\\ .bai\\ for\\ Normal\\ exome\\ \\(Nex\\),\\ normal\\ transcriptome\\ \\(Ntr\\),\\ Tumor\\ exome\\ \\(Tex\\)\\ and\\ tumor\\ transcriptome\\ \\(Ttr\\)\\\"\\},\\{\\\"name\\\":\\\"vcfs\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":false,\\\"label\\\":\\\"Variant\\ call\\ files\\ \\(compressed\\)\\\",\\\"help\\\":\\\"compressed\\ tarball\\ \\(\\*tar.gz\\)\\ containing\\ variant\\ files\\ \\(.vcf\\)\\ for\\ Normal\\ exome\\ \\(Nex\\),\\ normal\\ transcriptome\\ \\(Ntr\\),\\ Tumor\\ exome\\ \\(Tex\\)\\ and\\ tumor\\ transcriptome\\ \\(Ttr\\)\\\"\\}\\],\\\"output_spec\\\":\\[\\{\\\"name\\\":\\\"event_summaries\\\",\\\"class\\\":\\\"file\\\",\\\"optional\\\":false,\\\"label\\\":\\\"Event\\ Summaries\\ of\\ outputs\\\",\\\"help\\\":\\\"tarball\\ containing\\ event\\ summaries\\ and\\ read-counts\\ for\\ analysis\\\"\\}\\],\\\"internet_access\\\":false,\\\"instance_type\\\":\\\"hidisk-36\\\"\\},\\\"assets\\\":\\[\\\"file-F03B2qQ09fG82Qx6pbx6Pbj9\\\"\\],\\\"packages\\\":\\[\\]\\} \u003e /spec.json"]
RUN ["/bin/bash","-c","echo -E \\{\\\"code\\\":\\\"module\\ load\\ python/2.7.6\\\\necho\\ start_now...\\\\nPPath\\=\\'/usr/bin/src/\\'\\\\necho\\ \\$bams_path\\\\necho\\ \\$vcfs_path\\\\n\\\\ntar\\ xvfz\\ \\$bams_path\\\\ntar\\ xvfz\\ \\$vcfs_path\\\\n\\\\nbam_files\\=/work/in/\\$bams_prefix/\\*\\'.bam\\'\\\\necho\\ \\$bam_files\\\\nvcf_files\\=/work/in/\\$vcfs_prefix/\\*\\'.vcf\\'\\\\necho\\ \\$vcf_files\\\\n\\\\npython\\ \\$PPath/RNA2DNAlign.py\\ \\\\\\\\\\\\n-t\\ 20\\ \\\\\\\\\\\\n-e\\ \\$PPath\\'/data/\\*coordinates.txt\\'\\\\\\\\\\\\n-m\\ 10\\ \\\\\\\\\\\\n-U\\ False\\ \\\\\\\\\\\\n-f\\ False\\ \\\\\\\\\\\\n-q\\ False\\ \\\\\\\\\\\\n-d\\ \\$PPath\\'/data/\\*hg19.txt\\'\\ \\\\\\\\\\\\n-c\\ \\$PPath\\'/data/\\*Export.tsv\\'\\ \\\\\\\\\\\\n-r\\ \\\\\\\"\\$bam_files\\\\\\\"\\ \\\\\\\\\\\\n-s\\ \\\\\\\"\\$vcf_files\\\\\\\"\\ \\\\\\\\\\\\n--tumortransre\\ Ttr\\ \\\\\\\\\\\\n--normaltransre\\ Ntr\\ \\\\\\\\\\\\n--tumordnare\\ Tex\\ \\\\\\\\\\\\n--normaldnare\\ Nex\\ \\\\\\\\\\\\n-o\\ \\'RNA2DNAlign_out\\'\\\\necho\\ \\'DONE\\'\\\\n\\\\necho\\ \\'compressing\\ and\\ emitting\\ outputs...\\'\\\\ntar\\ -czvf\\ \\$event_summaries_prefix.tar.gz\\ RNA2DNAlign_out/\\\\nemit\\ event_summaries\\ \\$event_summaries_prefix.tar.gz\\\\n\\\\n\\\"\\} | python -c 'import sys,json; print json.load(sys.stdin)[\"code\"]' \u003e /script.sh"]

# Create directory /work and set it to $HOME and CWD
RUN mkdir -p /work
ENV HOME="/work"
WORKDIR /work

# Set entry point to container
ENTRYPOINT ["/usr/bin/run"]

VOLUME /data
VOLUME /work