[
    {
        "id": "f6f2187d.f17ca8",
        "type": "tab",
        "label": "Flow 1",
        "disabled": false,
        "info": ""
    },
    {
        "id": "3cc11d24.ff01a2",
        "type": "comment",
        "z": "f6f2187d.f17ca8",
        "name": "WARNING: please check you have started this container with a volume that is mounted to /data\\n otherwise any flow changes are lost when you redeploy or upgrade the container\\n (e.g. upgrade to a more recent node-red docker image).\\n  If you are using named volumes you can ignore this warning.\\n Double click or see info side panel to learn how to start Node-RED in Docker to save your work",
        "info": "\nTo start docker with a bind mount volume (-v option), for example:\n\n```\ndocker run -it -p 1880:1880 -v /home/user/node_red_data:/data --name mynodered nodered/node-red\n```\n\nwhere `/home/user/node_red_data` is a directory on your host machine where you want to store your flows.\n\nIf you do not do this then you can experiment and redploy flows, but if you restart or upgrade the container the flows will be disconnected and lost. \n\nThey will still exist in a hidden data volume, which can be recovered using standard docker techniques, but that is much more complex than just starting with a named volume as described above.",
        "x": 350,
        "y": 80,
        "wires": []
    },
    {
        "id": "799fac6bbb648cfe",
        "type": "inject",
        "z": "f6f2187d.f17ca8",
        "name": "",
        "props": [
            {
                "p": "payload"
            },
            {
                "p": "topic",
                "vt": "str"
            }
        ],
        "repeat": "1",
        "crontab": "",
        "once": false,
        "onceDelay": 0.1,
        "topic": "",
        "payload": "1",
        "payloadType": "num",
        "x": 210,
        "y": 300,
        "wires": [
            [
                "c29ca44c84345abe"
            ]
        ]
    },
    {
        "id": "c29ca44c84345abe",
        "type": "LED",
        "z": "f6f2187d.f17ca8",
        "name": "",
        "LEDtype": "GPIO",
        "targetPort": "0",
        "targetPort_mode": "2",
        "onBoardLED": "",
        "x": 430,
        "y": 340,
        "wires": []
    }
]
