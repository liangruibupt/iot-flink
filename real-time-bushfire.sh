https://aws.amazon.com/blogs/big-data/real-time-bushfire-alerting-with-complex-event-processing-in-apache-flink-on-amazon-emr-and-iot-sensor-network/

https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?stackName=iot-alert-stack&templateURL=https://s3.amazonaws.com/aws-big-data-blog/realtime-bushfire-alert-with-apache-flink-cep/cfn-template/cfn-template.yml

https://s3.cn-north-1.amazonaws.com.cn/cf-templates-7arfdirw3u3s-cn-north-1/real-time-bushfire-template-cn.yml

SNS: ruiliang@amazon.com

domain and stack name: real-time-bushfire

EMR logs: s3://ray-emr-lab-03242151/logs

EMR Subnet: public subnet

Iot Simulator subnet: public subnet

Iot Simulator security group: allow 22 port access

PublicIP To Access ES Kibana: 0.0.0.0/0

ES Subnet: public subnet

ES security group: allow 80/443/9200 port access

Metadata:
  'AWS::CloudFormation::Interface':
    ParameterGroups:
      Label:
        default: 'Amazon Elasticsearch Service domain details'
      Parameters:
      - ESDomainName
      - PublicIPToAccessKibana
      - ESSubnet
      - ESSecurityGroupId
    ParameterLabels:
      PublicIPToAccessKibana:
        default: 'Public IP address to access Kibana from local machine'
      ESSubnet:
        default: 'Elasticsearch domain subnet'
      ESSecurityGroupId:
        default: 'Elasticsearch domain SecurityGroup'
                  
Parameters:
  ESSubnet:
    Type: AWS::EC2::Subnet::Id
  ESSecurityGroupId:
    Description: 'Security group for the corresponding public subnet specified above for the ESDomain'
    Type: 'AWS::EC2::SecurityGroup::Id'

Resources:
  ESDomain:
    Type: AWS::Elasticsearch::Domain
    Properties:
      VPCOptions:
        SecurityGroupIds: 
        - !Ref ESSecurityGroupId
        SubnetIds: 
        - !Ref ESSubnet


Problem:
1. aws-es-proxy Can not work for China region
aws-es-proxy-0.8-linux-amd64 -endpoint https://search-real-time-bushfire-hql7siqa3m4sz6altvkp3t76e4.cn-north-1.es.amazonaws.com.cn
2019/08/14 05:50:24 error: submitted endpoint is not a valid Amazon ElasticSearch Endpoint

The code
if (len(parts) == 5 || len(parts) == 6) {
            p.region, p.service = parts[1], parts[2]
        } else {
            return fmt.Errorf("error: submitted endpoint is not a valid Amazon ElasticSearch Endpoint")
        }
should adopt the China region url

*.cn-north-1.es.amazonaws.com.cn
*.cn-northwest-1.es.amazonaws.com.cn

https://github.com/abutaha/aws-es-proxy/pull/63 has been fixed: by v1.0

- Fix: https://github.com/abutaha/aws-es-proxy
In Linux:
sudo yum install -y git / sudo apt-get install -y git
sudo yum install -y go / sudo apt-get install -y go
sudo su
export GOPATH=/usr/lib/golang  / export GOPATH=/usr/lib/go-1.10/
export PATH=$GOPATH/bin:$PATH 
vi ~/.bash_profile
source ~/.bash_profile
curl https://glide.sh/get | sh / sudo add-apt-repository ppa:masterminds/glide && sudo apt-get update && sudo apt-get install glide

In Mac:
brew install go
brew install glide
export GOPATH=/usr/local/opt/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

Build from source
#requires go1.5
export GO15VENDOREXPERIMENT=1
mkdir -p $GOPATH/src/github.com/abutaha
cd $GOPATH/src/github.com/abutaha
git clone https://github.com/abutaha/aws-es-proxy
cd aws-es-proxy
glide install
go build github.com/abutaha/aws-es-proxy

aws s3 cp aws-es-proxy s3://ray-datalake-lab/realtime-bushfire/aws-es-proxy