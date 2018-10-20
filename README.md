# Infrastructure as code - Insert Data into ES From RDS

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

If you want to search your database entities from Elasticsearch then you can use Logstash to do just that! If you already have the Logstah server then you can jump to logstah configuration else create the AMI using packer and update the CF template to spin up the server along with RDS & elastic search.
In this Doc, I will walk through you with the Packer for building the AMI, CloudFormation for building the infra in AWS, JDBC input, which has been created to import data from any database that supports the JDBC interface.

# Tools Used 
  - Packer - Image Builder
  - MySql RDS - Dats Source
  - ElasticSearch - Open-source search engine 
  - Logstash - Data processing pipeline 
  - CloudFormation - Infrastructure Management
# Provisioning Infra in AWS

Create ES & RDS in a existing VPC & security group using below command

```sh
$ git clone https://github.com/amalcp/Insert-Data-into-ES-From-Database
$ cd Insert-Data-into-ES-From-Database
$ aws cloudformation create-stack --stack-name myteststack --template-body file://master.yml --parameters ParameterKey=DBUser,ParameterValue=admin ParameterKey=BucketName,ParameterValue=rds_es_mirror ParameterKey=DBPassword,ParameterValue=f3wsQHiAzVL61tq5,ParameterKey=DBName,ParameterValue=MyDb
 
```



# Setting up the LogStash server

Building the the logstash server using packer and set the RDS & ES end point URLs as environment variable to configure the logstash. 
### Instaling Packer
```sh
$ cd /opt/
$ git clone https://github.com/hashicorp/packer.git
$ cd packer && make dev
```
### Building the Logstash AMI
Build & configure the AMI with all nessary packegs and config files 

```sh
$ cd logstash
$ packer build \
  -var 'aws_access_key=your_key' \
  -var 'aws_secret_key=your_secret' \
  -var 'aws_vpc_id=your_vpc_id' \
  -var 'rds_end_point=rds_end_point' \
  -var 'es_end_point=your_es_dns' \
  -var 'db_pass=your_dbpass' \
  -var 'db_user=your_dbuser' \
  -var 'table_to_index=your_dbtable' \
  logstash.json
```