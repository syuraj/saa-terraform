

### To intsall nodejs
* `sudo curl -sL https://rpm.nodesource.com/setup_lts.x | sudo bash -`
* `sudo dnf install nodejs -y`


### To install codedeploy agent
https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-linux.html
* `sudo yum install ruby`
* `sudo yum install wget`
* `wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install`
* `chmod +x ./install`
* `sudo ./install auto`
* `sudo systemctl status codedeploy-agent`
* `sudo systemctl start codedeploy-agent`
