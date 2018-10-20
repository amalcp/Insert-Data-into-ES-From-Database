
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
  -var 'es_end_point=your_key' \
  -var 'db_pass=your_secret' \
  -var 'db_user=your_vpc_id' \
  -var 'table_to_index=your_subnet_id' \
  logstash.json
```

