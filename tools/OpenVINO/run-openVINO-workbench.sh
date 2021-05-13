#!/bin/bash -x

# ref: https://docs.openvinotoolkit.org/latest/workbench_docs_Workbench_DG_Jupyter_Notebooks.html#go_to_the_playground

#docker run --name openvino-workbench --rm -p 5665:5665 --name workbench -it openvino/workbench:2021.3
docker run -d -p 0.0.0.0:5665:5665 --name openvino-workbench -it openvino/workbench:2021.3
