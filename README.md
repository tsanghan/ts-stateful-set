# ts-stateful-set

Start your `kind` cluster.  
Install your CNI.

```sh
metallb.sh # install metallb
nfs-storage-class.sh # install CSI
cd ~/Projects
git clone https://gitlab.es.f5net.com/tsanghan/techsummit-stateful-set.git
cd techsummit-stateful-set
./mongo-stateful-set.sh
k apply -f pymongo-fastapi-crud-app.yaml
export HOST=$(k get svc pymongo-fastapi-crud -ojson | jq -Mr '.status.loadBalancer.ingress[].ip')
export PORT=$(k get svc pymongo-fastapi-crud -ojson | jq -Mr '.spec.ports[].port')
xh "$HOST:$PORT/book/"
parallel ./single-create-item.sh ::: {1..100}
xh "$HOST:$PORT/book/"
xh "$HOST:$PORT/book/" | jq '. | length'

k exec -it pods/mongo-mongodb-2 -- /bin/bash -c \
    "mongosh 'mongodb://root:xtech42@localhost:27017/ts_2025?authSource=admin' \
    --eval 'db.books.find().toArray()'"

k exec -it pods/mongo-mongodb-2 -- /bin/bash -c \
    "mongosh 'mongodb://root:xtech42@localhost:27017/ts_2025?authSource=admin' \
    --eval 'db.books.find().toArray()'" 2> /dev/null | \
    grep _id | wc -l

k exec -it pods/mongo-mongodb-1 -- /bin/bash -c \
    "mongosh 'mongodb://root:xtech42@localhost:27017/ts_2025?authSource=admin' \
    --eval 'db.books.find().toArray()'"

k exec -it pods/mongo-mongodb-1 -- /bin/bash -c \
    "mongosh 'mongodb://root:xtech42@localhost:27017/ts_2025?authSource=admin' \
    --eval 'db.books.find().toArray()'" 2> /dev/null | \
    grep _id | wc -l

k exec -it pods/mongo-mongodb-0 -- /bin/bash -c \
    "mongosh 'mongodb://root:xtech42@localhost:27017/ts_2025?authSource=admin' \
    --eval 'db.books.find().toArray()'"

k exec -it pods/mongo-mongodb-0 -- /bin/bash -c \
    "mongosh 'mongodb://root:xtech42@localhost:27017/ts_2025?authSource=admin' \
    --eval 'db.books.find().toArray()'" 2> /dev/null | \
    grep _id | wc -l

DATA=($(xh "$HOST:$PORT/book/" | jq -Mr '.[]._id')) && \
    parallel ./single-delete-item.sh ::: $(echo "${DATA[@]}")
```
