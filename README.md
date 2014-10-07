# Honebot

Honebot for [Hone's](http://gohone.com) internal slack chat room. He's uber smart and is pretty much a [hubot](https://hubot.github.com/).

## To install

```
$ git clone https://github.com/jcblw/honebot.git
$ cd honebot
$ npm install
```

Also if you dont have [redis](https://hubot.github.com/) you might want to install it for honebot's redis brain.

## To run

```
$ bin/hubot 
```

Some scripts will want differnt dependencies and enviroments variables. So not all will work out of box you might want to look at the script to see what its expecting

Script are all located in `/scripts` or some are specified in `hubot-scripts.json`.
