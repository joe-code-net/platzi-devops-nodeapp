wget -O packer.zip https://releases.hashicorp.com/packer/1.2.0/packer_1.2.0_linux_amd64.zip?_ga=2.173872099.119078101.1518455055-680632328.1518455055
unzip packer.zip
./packer validate deployments/template.json
./packer build deployments/template.json