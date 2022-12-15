#!/bin/bash -x

# ①: Download the Database tools package
wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu1804-x86_64-100.5.0.deb
        
# ②: Install downloaded Database tools package
sudo apt install ./mongodb-database-tools-*-100.5.0.deb
        
# ③: Verify installation by exporting MongoDB collection data
echo -e "... try the command similar to below to test"
echo mongoexport --uri="mongodb+srv://username:password@hostname/database"  --collection=collection_name --out=output.json
        
        
