# Cloudfuzzer work flow

## Pre work

Image are built with [Packer](https://www.packer.io/). Currently supported cloud platforms are [Google Cloud](https://cloud.google.com/) and [Amazon Web Services](https://aws.amazon.com/).

Packer is used to provision ssh keys to the bastion and fuzzvm images.

By default keys should be named bastion-key, bastion-key.pub and fuzzvm-key, fuzzvm-key.pub and should locate in folder ./vm-keys.

You can use ./scripts/create-keys.sh to create rsa 4096 keys for you.

Keys are provisioned so that bastion can access all machines created from fuzzvm-image, and fuzzvm can access all other fuzzvms and bastion.
(Currently there are no separate users for different operations, so you get full root access with these keys.)

### Using Packer

Using Google Compute Engine with Packer is documented in: https://www.packer.io/docs/builders/googlecompute.html

By default, packer files for bastion and fuzzvm use use_variables for account_file and project_id.

One way to use them is to make a separate json-file:
```
{
	"account_file":	"/path/to/your/account_file.json",
	"project_id":	"your_cloudfuzzer_project_id"
}
```

and run Packer build with:

```Google Cloud
packer build -only=gcloud -var-file=/path/to/your/variables.json packer-bastion.json
```

```AWS
packer build -force -only=aws -var-file=/home/mikko/variables.json packer-bastion.json
```
