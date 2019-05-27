#!/bin/bash -x

sudo docker run -d -p 5000:5000 --restart always --name registry registry:2

function usage() {
   echo "Now, use it from within Docker environment"
   echo "1.) docker pull ubuntu"
   echo "1.) docker tag ubuntu localhost:5000/ubuntu"
   echo "1.) docker push localhost:5000/ubuntu"
}
