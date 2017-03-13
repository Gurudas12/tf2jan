#!/bin/bash

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "#PRECONDITIONS BEFORE RUNNING ANY SUITE FILE ON VITO:"
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "#H2H:	for suite: ingestion-hdfs-to-hdfs.txt"
	hdfs dfs -rm -r hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/hdfs-to-hdfs/*
	hdfs dfs -mkdir hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/hdfs-to-hdfs/H2H_Copy_Existing_File_At_dest-AS-IS
	hdfs dfs -mkdir hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/hdfs-to-hdfs/H2H_Copy_Existing_File_At_dest-diff-sized
	hdfs dfs -mkdir hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/hdfs-to-hdfs/H2H_Copy_Existing_Dir_At_dest-AS-IS
	hdfs dfs -mkdir hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/hdfs-to-hdfs/H2H_Copy_Existing_Dir_At_dest-diff-sized

	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-file-at-destination.file  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/hdfs-to-hdfs/H2H_Copy_Existing_File_At_dest-AS-IS
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-file-at-destination-diff-size.file  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/hdfs-to-hdfs/H2H_Copy_Existing_File_At_dest-diff-sized
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-dir-at-destination  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/hdfs-to-hdfs/H2H_Copy_Existing_Dir_At_dest-AS-IS
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-dir-at-destination-diff-size  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/hdfs-to-hdfs/H2H_Copy_Existing_Dir_At_dest-diff-sized
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/copy-at-same-location  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/hdfs-to-hdfs/
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/opdir-part-of-ipdir  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/hdfs-to-hdfs/
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "#H2N:	for suite: ingestion-hdfs-to-nfs.txt"
	ssh node30
	sudo su
	rm -rf /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/hdfs-to-nfs/*
	mkdir -p /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/hdfs-to-nfs/
	mkdir -p /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/hdfs-to-nfs/H2N_Copy_Existing_File_At_dest-AS-IS
	mkdir -p /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/hdfs-to-nfs/H2N_Copy_Existing_File_At_dest-diff-sized
	mkdir -p /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/hdfs-to-nfs/H2N_Copy_Existing_Dir_At_dest-AS-IS
	mkdir -p /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/hdfs-to-nfs/H2N_Copy_Existing_Dir_At_dest-diff-sized
	cp -r /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-file-at-destination.file  /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/hdfs-to-nfs/H2N_Copy_Existing_File_At_dest-AS-IS/
	cp -r /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-file-at-destination-diff-size.file  /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/hdfs-to-nfs/H2N_Copy_Existing_File_At_dest-diff-sized/
	cp -r /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-dir-at-destination  /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/hdfs-to-nfs/H2N_Copy_Existing_Dir_At_dest-AS-IS/
	cp -r /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-dir-at-destination-diff-size  /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/hdfs-to-nfs/H2N_Copy_Existing_Dir_At_dest-diff-sized/
	ll /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/hdfs-to-nfs
	chmod -R 777 /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/hdfs-to-nfs
	ll /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/hdfs-to-nfs
	exit
	exit
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "#H2F:	for suite: ingestion-hdfs-to-ftp.txt"
	ssh node34	
	sudo su
	su ftp-dttbc
	rm -rf /home/ftp-dttbc/user/dttbc/DATASETS/ing-dest-data/hdfs-to-ftp
	mkdir -p /home/ftp-dttbc/user/dttbc/DATASETS/ing-dest-data/hdfs-to-ftp
	mkdir -p /home/ftp-dttbc/user/dttbc/DATASETS/ing-dest-data/hdfs-to-ftp/H2F_Copy_Existing_File_At_dest-AS-IS
	mkdir -p /home/ftp-dttbc/user/dttbc/DATASETS/ing-dest-data/hdfs-to-ftp/H2F_Copy_Existing_File_At_dest-diff-sized
	mkdir -p /home/ftp-dttbc/user/dttbc/DATASETS/ing-dest-data/hdfs-to-ftp/H2F_Copy_Existing_Dir_At_dest-AS-IS
	mkdir -p /home/ftp-dttbc/user/dttbc/DATASETS/ing-dest-data/hdfs-to-ftp/H2F_Copy_Existing_Dir_At_dest-diff-sized
	cp -r /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-file-at-destination.file  /home/ftp-dttbc/user/dttbc/DATASETS/ing-dest-data/hdfs-to-ftp/H2F_Copy_Existing_File_At_dest-AS-IS
	cp -r /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-file-at-destination-diff-size.file  /home/ftp-dttbc/user/dttbc/DATASETS/ing-dest-data/hdfs-to-ftp/H2F_Copy_Existing_File_At_dest-diff-sized
	cp -r /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-dir-at-destination  /home/ftp-dttbc/user/dttbc/DATASETS/ing-dest-data/hdfs-to-ftp/H2F_Copy_Existing_Dir_At_dest-AS-IS
	cp -r /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-dir-at-destination-diff-size  /home/ftp-dttbc/user/dttbc/DATASETS/ing-dest-data/hdfs-to-ftp/H2F_Copy_Existing_Dir_At_dest-diff-sized
	exit
	exit
	exit
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
echo "#F2F:"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
echo "#F2H:"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
echo "#F2N:"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
echo "#N2N:	suite: ingestion-nfs-to-nfs.txt"
	ssh node30
	sudo su
	su dttbc
	rm -rf /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs/*
	mkdir -p /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs/
	mkdir -p /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs/N2N_Copy_Existing_File_dest-AS-IS
	mkdir -p /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs/N2N_Copy_Existing_File_dest-diff-sized
	mkdir -p /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs/N2N_Copy_Existing_Dir_dest-AS-IS
	mkdir -p /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs/N2N_Copy_Existing_Dir_dest-diff-sized
	cp -r /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-file-at-destination.file  /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs/N2N_Copy_Existing_File_dest-AS-IS
	cp -r /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-file-at-destination-diff-size.file  /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs/N2N_Copy_Existing_File_dest-diff-sized
	cp -r /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-dir-at-destination  /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs/N2N_Copy_Existing_Dir_dest-AS-IS
	cp -r /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-dir-at-destination-diff-size  /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs/N2N_Copy_Existing_Dir_dest-diff-sized
	cp -r /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/copy-at-same-location  /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs/
	cp -r /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/opdir-part-of-ipdir  /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs/
	ll /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs
	chmod -R 777 /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs
	ll /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-dest-data/nfs-to-nfs
	exit
	exit
	exit
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
echo "#N2H:	suite: ingestion-nfs-to-hdfs.txt"
	hdfs dfs -rm -r hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/nfs-to-hdfs
	hdfs dfs -mkdir -p hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/nfs-to-hdfs/
	hdfs dfs -mkdir -p hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/nfs-to-hdfs/N2H_Copy_Existing_File_At_dest-AS-IS
	hdfs dfs -mkdir -p hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/nfs-to-hdfs/N2H_Copy_Existing_File_At_dest-diff-sized
	hdfs dfs -mkdir -p hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/nfs-to-hdfs/N2H_Copy_Existing_Dir_At_dest-AS-IS
	hdfs dfs -mkdir -p hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/nfs-to-hdfs/N2H_Copy_Existing_Dir_At_dest-diff-sized
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-file-at-destination.file  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/nfs-to-hdfs/N2H_Copy_Existing_File_At_dest-AS-IS
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-file-at-destination-diff-size.file  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/nfs-to-hdfs/N2H_Copy_Existing_File_At_dest-diff-sized
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-dir-at-destination  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/nfs-to-hdfs/N2H_Copy_Existing_Dir_At_dest-AS-IS
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-dir-at-destination-diff-size  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/nfs-to-hdfs/N2H_Copy_Existing_Dir_At_dest-diff-sized

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
echo "#OverWrite:	suite: ingestion-param-test-overwrite.txt"
	hdfs dfs -rm -r hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/OverWrite
	hdfs dfs -mkdir -p hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/OverWrite/
	hdfs dfs -mkdir -p hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/OverWrite/OWR_Copy_Existing_File_At_dest-AS-IS
	hdfs dfs -mkdir -p hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/OverWrite/OWR_Copy_Existing_File_At_dest-diff-sized
	hdfs dfs -mkdir -p hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/OverWrite/OWR_Copy_Existing_Dir_dest-AS-IS
	hdfs dfs -mkdir -p hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/OverWrite/OWR_Copy_Existing_Dir_dest-diff-sized
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-file-at-destination.file  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/OverWrite/OWR_Copy_Existing_File_At_dest-AS-IS
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-file-at-destination-diff-size.file  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/OverWrite/OWR_Copy_Existing_File_At_dest-diff-sized
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-dir-at-destination  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/OverWrite/OWR_Copy_Existing_Dir_dest-AS-IS
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/existing-dir-at-destination-diff-size  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/OverWrite/OWR_Copy_Existing_Dir_dest-diff-sized
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/ing-dest-data/copy-at-same-location  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/OverWrite/

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
echo "#N2F:"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
echo "#FileFilter: NA"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
echo "#Encryption:	suite: ingestion-param-test-encryption.txt"
	hdfs dfs -rm -r hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/Encryption/*
	hdfs dfs -mkdir -p hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/Encryption/ENC_PKI-2048_Existing_Dir_At_dest-AS-IS/
	hdfs dfs -mkdir -p hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/Encryption/ENC_AES-256b_Existing_Dir_At_dest-AS-IS/
	hdfs dfs -rm -r hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/PSARK/*
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/existing-dir-at-destination  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/Encryption/ENC_PKI-2048_Existing_Dir_At_dest-AS-IS/
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/existing-dir-at-destination  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/Encryption/ENC_AES-256b_Existing_Dir_At_dest-AS-IS/

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "#FastMerge:"

#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
echo "#Compression:	suite: ingestion-param-test-compression.txt"
	hdfs dfs -rm -r hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/Compression
	hdfs dfs -mkdir -p hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/Compression/CMR_GZIP_Existing_Dir_At_dest-AS-IS/
	hdfs dfs -copyFromLocal /disk5/dt-nfs-mount/IngestionAppTesting/user/dttbc/DATASETS/ing-source-data/existing-dir-at-destination  hdfs://node34.morado.com:8020/user/dttbc/DATASETS/ing-dest-data/Compression/CMR_GZIP_Existing_Dir_At_dest-AS-IS/
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "#Compaction:"
	
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	



