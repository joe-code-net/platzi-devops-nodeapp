wget -O /tmp/packer.zip https://releases.hashicorp.com/packer/1.2.0/packer_1.2.0_linux_amd64.zip?_ga=2.173872099.119078101.1518455055-680632328.1518455055
wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_linux_amd64.zip?_ga=2.109260102.256372412.1519195389-1455872783.1519195389
unzip /tmp/packer.zip -d ~/bin
unzip /tmp/terraform.zip -d ~/bin
packer validate deployments/template.json &&
packer build deployments/template.json &&
export TF_VAR_image_id=$(curl -X GET -H "Content-Type: application/json" -H "Authorization: Bearer $DIGITALOCEAN_API_TOKEN" "https://api.digitalocean.com/v2/images?private=true" | jq ".images[] | select(.name == \"platzi-snapshot-$CIRCLE_BUILD_NUM\") | .id")
echo $TF_VAR_image_id
cd infra && terraform init -input=false && terraform apply -input=false && cd .. &&
git add infra && git commit -m "Deployed $CIRCLE_BUILD_NUM [skip ci]" &&
git push origin master